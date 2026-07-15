#!/usr/bin/env node
// AshFall Voxel Lab — WebSocket relay for MCP ↔ browser sync.
// Zero dependencies. Usage: node web/mcp/bridge.js [port]
// Default port: 9138
//
// Both the browser (index.html) and the MCP server (server.js) connect as
// WebSocket clients. The bridge broadcasts messages between them so that
// DB mutations made on either side sync to the other.

const http = require('http');
const crypto = require('crypto');

const WS_GUID = '258EAFA5-E914-47DA-95CA-C5AB0DC85B11';
const PORT = parseInt(process.argv[2], 10) || 9138;

// ── Connected clients ────────────────────────────────────────────
let nextId = 1;
const clients = []; // { id, socket, role }

// ── WebSocket frame helpers ──────────────────────────────────────
function encodeFrame(payload) {
  const buf = Buffer.from(payload, 'utf8');
  const len = buf.length;
  let header;
  if (len < 126) {
    header = Buffer.alloc(2);
    header[0] = 0x81; // FIN + text opcode
    header[1] = len;
  } else if (len < 65536) {
    header = Buffer.alloc(4);
    header[0] = 0x81;
    header[1] = 126;
    header.writeUInt16BE(len, 2);
  } else {
    header = Buffer.alloc(10);
    header[0] = 0x81;
    header[1] = 127;
    header.writeBigUInt64BE(BigInt(len), 2);
  }
  return Buffer.concat([header, buf]);
}

function decodeFrame(data) {
  if (data.length < 2) return null;
  const opcode = data[0] & 0x0f;
  const masked = (data[1] & 0x80) !== 0;
  let len = data[1] & 0x7f;
  let off = 2;
  if (len === 126) { if (data.length < 4) return null; len = data.readUInt16BE(2); off = 4; }
  else if (len === 127) { if (data.length < 10) return null; len = Number(data.readBigUInt64BE(2)); off = 10; }
  const mask = masked ? data.slice(off, off + 4) : null;
  if (mask) off += 4;
  if (data.length < off + len) return null;
  const payload = Buffer.alloc(len);
  for (let i = 0; i < len; i++) payload[i] = data[off + i] ^ (mask ? mask[i % 4] : 0);
  return { opcode, payload: payload.toString('utf8'), consumed: off + len };
}

// ── Broadcast to all clients except sender ───────────────────────
function broadcast(fromId, msg) {
  const raw = encodeFrame(msg);
  for (const c of clients) {
    if (c.id === fromId) continue;
    try { c.socket.write(raw); } catch (e) { /* client gone */ }
  }
}

// ── HTTP server with WebSocket upgrade ──────────────────────────
const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('AshFall Voxel Lab — MCP Bridge. Connect via WebSocket.\n');
});

server.on('upgrade', (req, socket, head) => {
  const key = req.headers['sec-websocket-key'];
  if (!key) { socket.destroy(); return; }

  const accept = crypto.createHash('sha1').update(key + WS_GUID).digest('base64');
  socket.write(
    'HTTP/1.1 101 Switching Protocols\r\n' +
    'Upgrade: websocket\r\n' +
    'Connection: Upgrade\r\n' +
    'Sec-WebSocket-Accept: ' + accept + '\r\n\r\n'
  );

  const client = { id: nextId++, socket, role: 'unknown' };
  clients.push(client);
  console.log(`[bridge] client ${client.id} connected (${clients.length} total)`);

  let buf = Buffer.alloc(0);

  socket.on('data', (chunk) => {
    buf = Buffer.concat([buf, chunk]);
    while (true) {
      const frame = decodeFrame(buf);
      if (!frame) break;
      buf = buf.slice(frame.consumed);

      if (frame.opcode === 0x8) {
        // Close frame
        socket.end();
        return;
      }
      if (frame.opcode === 0x9) {
        // Ping — reply with pong
        const pong = Buffer.alloc(2);
        pong[0] = 0x8a; pong[1] = 0;
        socket.write(pong);
        continue;
      }
      if (frame.opcode !== 0x1) continue; // only text frames

      try {
        const msg = JSON.parse(frame.payload);
        if (msg.type === 'hello') {
          client.role = msg.role || 'unknown';
          console.log(`[bridge] client ${client.id} role: ${client.role}`);
        }
        // Re-broadcast to everyone else
        broadcast(client.id, frame.payload);
      } catch (e) { /* ignore malformed JSON */ }
    }
  });

  socket.on('close', () => {
    const idx = clients.indexOf(client);
    if (idx >= 0) clients.splice(idx, 1);
    console.log(`[bridge] client ${client.id} disconnected (${clients.length} remaining)`);
  });

  socket.on('error', () => {
    const idx = clients.indexOf(client);
    if (idx >= 0) clients.splice(idx, 1);
  });
});

server.listen(PORT, () => {
  console.log(`[bridge] AshFall Voxel Lab MCP bridge listening on ws://localhost:${PORT}`);
});
