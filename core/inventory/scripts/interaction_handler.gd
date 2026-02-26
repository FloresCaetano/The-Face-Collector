extends Node

@export var inspect_container : InspectContainer
@export var mouse_ray_cast : MouseRayCast

var current_object = null
var already_interacted = false	
func _physics_process(_delta: float) -> void:
	if inspect_container.is_inspecting and inspect_container.current_item_model:
		var ray = mouse_ray_cast.calc_3D_interactions(1, 5)
		if ray:
			var collider = ray.collider
			if collider is Interactable:
				collider.mouse_interaction()
				if current_object != collider: leave_interaction() #In case we see at other collider
				current_object = collider
				already_interacted = true
		elif already_interacted:
			leave_interaction()
	elif already_interacted:
		leave_interaction()

func leave_interaction():
	if current_object != null and current_object is Interactable:
		current_object.on_mouse_exited()
	current_object = null
	already_interacted = false
