class_name PlayerDialogManager
extends Control

@export var bg: ColorRect
@export var label: Label

const chars_per_minute : float = 1300

func _ready() -> void:
	bg.visible = false
	label.text = ""

func write(text : String, ammount : int):
	bg.visible = true
	label.text = text.left(ammount)
	if randf() > 0.92:
		$AudioStreamPlayer3D.play()

func clean():
	bg.visible = false
	label.text = ""

func talk(text : String):
	var text_lenght = text.length()
	var tween : Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(
			func(ammount): write(text, ammount),
			0, text_lenght, (text_lenght * 60 / chars_per_minute)
		)
		
	var timer : Timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(func(): clean())
	add_child(timer)
	
	tween.tween_callback(func(): timer.start(4))
	
	
