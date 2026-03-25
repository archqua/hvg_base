extends Control

@onready var _status_label: Label = %StatusLabel
@onready var _test_button: Button = %TestButton

func _ready() -> void:
	_test_button.pressed.connect(_on_test_button_pressed)

func _on_test_button_pressed() -> void:
	var time: String = Time.get_time_string_from_system()
	_status_label.text = "Pressed at: " + time
	Input.vibrate_handheld(50)
	print("Log: button pressed at ", time)

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_GO_BACK_REQUEST:
			if GameManager.has_active_menu():
				GameManager.close_current_menu()
			else:
				get_tree().quit()
		NOTIFICATION_APPLICATION_PAUSED:
			AudioServer.set_bus_mute(0, true)
		NOTIFICATION_APPLICATION_RESUMED:
			AudioServer.set_bus_mute(0, false)
