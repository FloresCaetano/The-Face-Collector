@abstract
class_name Interactable
extends PhysicsBody3D

var is_interacting := false

@abstract
func mouse_interaction() -> void
@abstract
func on_mouse_exited() -> void