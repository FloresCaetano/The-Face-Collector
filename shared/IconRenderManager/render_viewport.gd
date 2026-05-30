@tool
extends SubViewport

# Un botón real en el Inspector para capturar lo que ve este Viewport exacto
@export_tool_button("Tomar Render Transparente", "ImageTexture")
var boton_captura = _guardar_render_transparente

@export var path : String = ""

func _guardar_render_transparente() -> void:
	# 1. Forzamos la propiedad de transparencia nativa en este Viewport
	self.transparent_bg = true
	
	# 2. Forzamos un frame de renderizado en el Graphic Server para congelar la imagen actual
	await RenderingServer.frame_post_draw
	
	# 3. Capturamos la textura generada en el editor
	var img: Image = get_texture().get_image()
	if not img:
		push_error("THE FACE COLLECTOR: No se pudo obtener la textura del SubViewport.")
		return
		
	# Convertimos la imagen para asegurar que el canal alfa (RGBA) se guarde intacto
	img.convert(Image.FORMAT_RGBA8)
	
	# 4. Definimos una ruta con un timestamp único en la raíz del proyecto
	var ruta: String = path + ".png"
	
	# 5. Guardamos el archivo físico .png
	var error = img.save_png(ruta)
	if error == OK:
		print("THE FACE COLLECTOR: Render de Viewport guardado con éxito en: ", ruta)
	else:
		push_error("Error al guardar el render del Viewport: ", error)
