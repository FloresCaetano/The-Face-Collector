extends Control

func _process(_delta):
	queue_redraw() 

func _draw():
	# 1. Obtenemos el tamaño actual de la ventana de juego
	var centro_pantalla = get_viewport_rect().size / 2
	
	# 2. Definimos las propiedades del círculo
	var radio = 2.0
	var color = Color(0.5, 0.5, 0.5, 0.9)
	
	# 3. Dibujamos el círculo en el centro
	draw_circle(centro_pantalla, radio, color)
