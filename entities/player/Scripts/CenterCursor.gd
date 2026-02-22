class_name Cursor
extends Control

var radius = 1
var color = Color(1, 1, 1, 0.2)
var actual_tween : Tween
func _draw():
	draw_circle(Vector2(0, 0), radius, color)

func _process(_delta):
	queue_redraw()

func increse_cursor():
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(change_radius, 4, 1, 1)
	actual_tween = tween

func decrese_cursor():
	#actual_tween.stop()
	#var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#tween.tween_method(change_radius, 1, 4, 1)
	pass

func change_radius(_radius : float):
	self.radius = _radius
