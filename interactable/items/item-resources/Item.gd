extends  Resource
class_name Item

@export var name : String
@export var texture : Texture2D
@export var tag : String

@export_category("3D Inspection Properties")
@export var model : PackedScene
@export var offset : Vector3 = Vector3.ZERO
@export var rot_offset : Vector3 = Vector3.ZERO
