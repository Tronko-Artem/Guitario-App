extends Panel


func _on_RotateRightButton_pressed():
	if Global.tween.is_active():
		return
	Global.tween.stop_all()
	Global.tween.interpolate_property($Circle, "rotation_degrees", $Circle.rotation_degrees, $Circle.rotation_degrees - 30, 0.1)
	Global.tween.start()
	Input.vibrate_handheld(50)


func _on_RotateLeftButton_pressed():
	if Global.tween.is_active():
		return
	Global.tween.stop_all()
	Global.tween.interpolate_property($Circle, "rotation_degrees", $Circle.rotation_degrees, $Circle.rotation_degrees + 30, 0.1)
	Global.tween.start()
	Input.vibrate_handheld(50)
