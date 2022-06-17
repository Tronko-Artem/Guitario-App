extends Camera2D
class_name MainCamera

var previousPosition: Vector2 = Vector2(0, 0);
var moveCamera: bool = false;

func _unhandled_input(event: InputEvent):
	#Moving camera up and down
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		get_tree().set_input_as_handled()
		if event.is_pressed():
			previousPosition.y = event.position.y
			moveCamera = true
		else:
			moveCamera = false
	elif event is InputEventMouseMotion && moveCamera:
		get_tree().set_input_as_handled()
		if position.y >= 0:
			position.y += (previousPosition.y - event.position.y)
			previousPosition.y = event.position.y

		#Preventing the camera from going out of borders
		var bottomCameraPos = get_parent().get_node("Fretboard").texture.get_height() - get_viewport_rect().size.y
		position.y = 0.0 if position.y <= 0.0 else position.y
		position.y = bottomCameraPos if position.y >= bottomCameraPos else position.y
