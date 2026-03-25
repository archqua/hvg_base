extends Node

# ── Scene loading ──────────────────────────────────────────────
var _target_scene_path: String = ""
var _progress: Array[float] = [0.0]

func get_load_progress() -> float:
	return _progress[0]

func change_scene_async(path: String) -> void:
	if _target_scene_path != "":
		return
	_progress[0] = 0.0
	_target_scene_path = path
	var error: Error = ResourceLoader.load_threaded_request(path)
	if error == OK:
		set_process(true)
	else:
		printerr("GameManager: load request error ", error, " for path: ", path)

func _process(_delta: float) -> void:
	if _target_scene_path.is_empty():
		set_process(false)
		return

	var status: ResourceLoader.ThreadLoadStatus = \
		ResourceLoader.load_threaded_get_status(_target_scene_path, _progress)

	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			pass
		ResourceLoader.THREAD_LOAD_LOADED:
			var resource: Resource = ResourceLoader.load_threaded_get(_target_scene_path)
			_target_scene_path = ""
			set_process(false)
			if resource is PackedScene:
				get_tree().change_scene_to_packed(resource)
			else:
				printerr("GameManager: loaded resource is not a PackedScene")
		ResourceLoader.THREAD_LOAD_FAILED, ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			printerr("GameManager: scene failed to load: ", _target_scene_path)
			_target_scene_path = ""
			set_process(false)

# ── Menu stack ─────────────────────────────────────────────────
# Each menu node calls register_menu(self) on _ready
# and unregister_menu(self) on _exit_tree.
var _menu_stack: Array[Node] = []

func register_menu(menu: Node) -> void:
	if not _menu_stack.has(menu):
		_menu_stack.append(menu)

func unregister_menu(menu: Node) -> void:
	_menu_stack.erase(menu)

func has_active_menu() -> bool:
	return not _menu_stack.is_empty()

func close_current_menu() -> void:
	if _menu_stack.is_empty():
		return
	var top: Node = _menu_stack.back()
	# Each menu must implement close(); this keeps coupling minimal.
	if top.has_method("close"):
		top.close()
	else:
		top.queue_free()
