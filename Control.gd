extends Control

# Moving the menu bar up and down
func _on_PanelArrowButton_toggled(button_pressed: bool) -> void:
	var y = $Panel.rect_position.y
	var offset = 580 * (1 if button_pressed else -1)
	var start_angle = 180 * int(!button_pressed)
	var end_angle = 180 * int(button_pressed)
	Global.tween.stop_all()
	Global.tween.interpolate_property($Panel/PanelArrowButton, "rect_rotation", start_angle, end_angle, 0.2)
	Global.tween.interpolate_property($Panel, "rect_position:y", y, y + offset, 0.2)
	Global.tween.start()

var startClickPos: Vector2
var endClickPos: Vector2
var group: String

# Method for loading info to lists
func _ready() -> void:
	for form in Global.NOTES:
		var label: Label = Label.new()
		label.name = form[Global.noteView]
		label.text = form[Global.noteView]
		label.align = 1
		label.valign = 1
		label.focus_mode = 1
		label.mouse_filter = 0
		label.add_to_group("RootNote")
		label.connect("visibility_changed", self, "get_Data", [$Panel/RootNoteButton, $Panel/ChordTypeButton, $Panel/ScaleTypeButton])
		$Panel/RootNotePanel/ScrollContainer/VBoxContainer.add_child(label)
	for form in ChordsData.chordForms:
		var label: Label = Label.new()
		label.name = form
		label.text = form
		label.align = 1
		label.valign = 1
		label.focus_mode = 1
		label.mouse_filter = 0
		label.add_to_group("ChordType")
		label.connect("visibility_changed", self, "get_Data", [$Panel/RootNoteButton, $Panel/ChordTypeButton, $Panel/ScaleTypeButton])
		$Panel/ChordTypePanel/ScrollContainer/VBoxContainer.add_child(label)
	for form in ChordsData.scaleForms.keys():
		var label: Label = Label.new()
		label.name = form
		label.text = form
		label.align = 1
		label.valign = 1
		label.focus_mode = 1
		label.mouse_filter = 0
		label.add_to_group("ScaleType")
		label.connect("visibility_changed", self, "get_Data", [$Panel/RootNoteButton, $Panel/ChordTypeButton, $Panel/ScaleTypeButton])
		$Panel/ScaleTypePanel/ScrollContainer/VBoxContainer.add_child(label)
	$Panel/RootNoteButton.text = get_tree().get_nodes_in_group("RootNote")[0].text
	$Panel/ChordTypeButton.text = get_tree().get_nodes_in_group("ChordType")[0].text
	ChordsData.note = $Panel/RootNoteButton.text
	ChordsData.form = $Panel/ChordTypeButton.text
	$Panel/FavoritePanel.search_Data()

# Supporting method that loads data from databases to choice lists
func get_Data(root, type, scale) -> void:
	if !$Panel/RootNotePanel.visible:
		if !$Panel/ChordTypePanel.visible && type.visible:
			ChordsData.note = root.text
			ChordsData.form = type.text
			ChordsData.parse_Chords_Data()
			ChordsData.chordNum = 0
			ChordsData.chordDrawable = true
			ChordsData.chordZeroDrawable = true
			$Panel/FavoritePanel.search_Data()
		if !$Panel/ScaleTypePanel.visible && scale.visible:
			ChordsData.note = root.text
			ChordsData.scale = scale.text
			ChordsData.scaleDrawable = true
			get_tree().get_nodes_in_group("Drawer")[0].update()

# Method for correct choosing items from list on mobile devices
func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag && get_focus_owner() is Label:
		group = get_focus_owner().get_groups()[0]
		get_node("Panel/" + group + "Panel/ScrollContainer").grab_click_focus()
		get_focus_owner().release_focus()
	if event is InputEventScreenTouch:
		if event.is_pressed():
			startClickPos = event.position
		else:
			endClickPos = event.position
		if is_equal_approx(startClickPos.length(), endClickPos.length()) && get_focus_owner() is Label:
			group = get_focus_owner().get_groups()[0]
			get_node("Panel/" + group + "Button").text = (get_focus_owner().text)
			get_focus_owner().release_focus()
			get_node("Panel/" + group + "Panel").visible = false
			Input.vibrate_handheld(50)

func _on_RootNoteButton_pressed() -> void:
	$Panel/RootNotePanel.visible = true
	Input.vibrate_handheld(50)

func _on_ChordTypeButton_pressed() -> void:
	$Panel/ChordTypePanel.visible = true
	Input.vibrate_handheld(50)

func _on_ScaleTypeButton_pressed() -> void:
	$Panel/ScaleTypePanel.visible = true
	Input.vibrate_handheld(50)

# Method for switching between chords viewing and scales viewing
func _on_CheckButton_toggled(button_pressed: bool) -> void:
	if button_pressed:
		$Panel/ChordTypeButton.visible = false
		$Panel/ScaleTypeButton.visible = true
		$Panel/SoundButton.disabled = true
		$Panel/FavoriteButton.disabled = true
		$Panel/FavoritePanel.visible = false
		$Panel/UpButton.disabled = true
		$Panel/DownButton.disabled = true
		ChordsData.scaleDrawable = true
		ChordsData.chordsList.clear()
		ChordsData.chordDrawable = false
		ChordsData.chordZeroDrawable = true
		ChordsData.chordNum = 0
		ChordsData.scaleChords = button_pressed
		get_tree().get_nodes_in_group("Drawer")[0].update()
	else:
		get_tree().get_nodes_in_group("Drawer")[0].update()
		$Panel/ScaleTypeButton.visible = false
		$Panel/ChordTypeButton.visible = true
		$Panel/SoundButton.disabled = false
		$Panel/FavoriteButton.disabled = false
		$Panel/FavoritePanel.visible = true
		$Panel/UpButton.disabled = false
		$Panel/DownButton.disabled = false
		ChordsData.scaleDrawable = false
		ChordsData.chordDrawable = true
		ChordsData.chordZeroDrawable = true
		ChordsData.chordNum = 0
		ChordsData.scaleChords = button_pressed
		get_Data($Panel/RootNoteButton, $Panel/ChordTypeButton, $Panel/ScaleTypeButton)
	Input.vibrate_handheld(50)

# Method for opening a menu panel
func _on_MoreButton_pressed() -> void:
	var y = $MenuPanel.rect_position.y
	var offset = 2200
	Global.tween.stop_all()
	Global.tween.interpolate_property($MenuPanel, "rect_position:y", y, y - offset, 0.2)
	Global.tween.start()
	Input.vibrate_handheld(50)

# Method for closing a menu panel
func _on_ExitMenuButton_pressed() -> void:
	var y = $MenuPanel.rect_position.y
	var offset = 2200
	Global.tween.stop_all()
	Global.tween.interpolate_property($MenuPanel, "rect_position:y", y, y + offset, 0.2)
	Global.tween.start()
	Input.vibrate_handheld(50)

# Method for changing a note view type
func _on_NoteView_toggled(button_pressed: bool) -> void:
	var counter: int = 0
	get_node("Panel/RootNoteButton").text = Global.NOTES[0][Global.noteView]
	ChordsData.note = $Panel/RootNoteButton.text
	for rootNote in get_tree().get_nodes_in_group("RootNote"):
		rootNote.text = Global.NOTES[counter][Global.noteView]
		counter += 1
	Input.vibrate_handheld(50)

# Method for changing a fretboard color
func _on_FretboardColorButton_toggled(button_pressed: bool) -> void:
	get_tree().get_nodes_in_group("Fretboard")[0].texture = Global.fretboardTextures[int(button_pressed)]
	Input.vibrate_handheld(50)

# Method for flipping arrow in control panel
func _on_ClosePanelButton_toggled(button_pressed: bool) -> void:
	var y = $Panel/FavoritePanel.rect_position.y
	var offset = 775 * (-1 if button_pressed else 1)
	var start_angle = 180 * int(button_pressed)
	var end_angle = 180 * int(!button_pressed)
	Global.tween.stop_all()
	Global.tween.interpolate_property($Panel/FavoritePanel/ClosePanelButton/ArrowButton, "rotation_degrees", start_angle, end_angle, 0.2)
	Global.tween.interpolate_property($Panel/FavoritePanel, "rect_position:y", y, y + offset, 0.2)
	Global.tween.start()

