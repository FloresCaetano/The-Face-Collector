extends Camera3D

@export var player_spotlight : SpotLight3D
@export var animation_player : AnimationPlayer

func _ready() -> void:
	animation_player.play("first_content")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	flashlight_delay()

func flashlight_delay():
	var tween2 : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween2.tween_property(player_spotlight, "global_transform", self.global_transform, 0.24)
