extends MarginContainer

func _ready() -> void:
	apply_safe_area()
	get_tree().root.size_changed.connect(apply_safe_area)

func apply_safe_area() -> void:
	var safe_area: Rect2i = DisplayServer.get_display_safe_area()
	var window_size: Vector2i = DisplayServer.window_get_size()

	# Guard against division by zero on headless or during init
	if window_size.x == 0 or window_size.y == 0:
		return

	var viewport: Viewport = get_tree().root
	var viewport_size: Vector2 = Vector2(viewport.size)

	# Scale factors: how many logical pixels per physical pixel
	var scale_x: float = viewport_size.x / float(window_size.x)
	var scale_y: float = viewport_size.y / float(window_size.y)

	var margin_top:    int = int(safe_area.position.y * scale_y)
	var margin_left:   int = int(safe_area.position.x * scale_x)
	var margin_bottom: int = int((window_size.y - safe_area.end.y) * scale_y)
	var margin_right:  int = int((window_size.x - safe_area.end.x) * scale_x)

	add_theme_constant_override("margin_top",    margin_top)
	add_theme_constant_override("margin_left",   margin_left)
	add_theme_constant_override("margin_bottom", margin_bottom)
	add_theme_constant_override("margin_right",  margin_right)
