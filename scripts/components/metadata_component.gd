# metadata_component.gd — Attach to Metadata nodes in template scenes
# Provides exported vars for scene identity, dependency tracking, AI legibility
extends Node

@export var scene_name: String = ""
@export var scene_slug: String = ""
@export var scene_type: String = ""  # island, district, landmark, prop, resource, system
@export_multiline var description: String = ""
@export var dependencies: Array[String] = []
@export var owner_island: String = "_shared"
@export var version: int = 1
@export var last_modified_by: String = "archbishop"
