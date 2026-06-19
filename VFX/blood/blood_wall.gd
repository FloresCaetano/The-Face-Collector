class_name BloodWall
extends Node3D



func set_blood_amount(from_value : float, last_value : float, duration : float) -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.tween_method(set_blood_amount, from_value, last_value, duration)

func set_shader_amount(ammount : float) -> void:
	var blood_material = $SubViewport/Blood.material as ShaderMaterial
	blood_material.set_shader_parameter("blood_coef", ammount)
