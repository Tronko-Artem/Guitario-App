extends Panel
onready var root: Tree = $TuningList

var itemList: Array = []

func _ready() -> void:
	add_Items_In_List()

# Method for adding tunings to list from database
func add_Items_In_List() -> void:
	root.clear()
	for i in ChordsData.tuningList:
		var item: TreeItem = $TuningList.create_item(root)
		item.set_text(0, i)
		var meta = ChordsData.tuningList[i]
		var tuningName : String = i
		tuningName.erase(tuningName.find(" "), 1)
		meta.append(tuningName)
		meta.append(item)
		item.set_metadata(0, meta)
		item.set_text_align(0, TreeItem.ALIGN_CENTER)
		itemList.append(item)


func _process(delta: float) -> void:
	if ChordsData.favoriteSelected:
		$TuningButton.text = ChordsData.tuningForm
		for item in itemList:
			if item.get_metadata(0)[2] == ChordsData.tuningName:
				item.select(0)
		ChordsData.favoriteSelected = false

# Method that displaying a list of tunings 
func _on_TuningButton_pressed():
	Input.vibrate_handheld(50)
	root.visible = true
	root.scroll_to_item(root.get_selected())

# Method that works when an item was selected from list
func _on_TuningList_item_activated() -> void:
	Input.vibrate_handheld(50)
	if ChordsData.scaleChords:
		ChordsData.scaleDrawable = true
		get_tree().get_nodes_in_group("Drawer")[0].update()
	var data = root.get_selected().get_metadata(0)
	ChordsData.tuningForm = data[1]
	$TuningButton.text = ChordsData.tuningForm
	Global.tuning = data[0]
	ChordsData.tuningName = data[2]
	ChordsData.parse_Chords_Data()
	ChordsData.tuningChanged = true
	get_tree().get_nodes_in_group("Favorite")[0].search_Data()
	root.visible = false

var last_scroll: Vector2
var startClickPos: Vector2
var endClickPos: Vector2

# Method for correct input from mobile device
func _on_TuningList_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			var item := root.get_item_at_position(event.position)
			if item:
				if event.pressed:
					startClickPos = event.position
					item.select(0)
					last_scroll = root.get_scroll()
				else:
					endClickPos = event.position
					if last_scroll == root.get_scroll() && is_equal_approx(startClickPos.length(), endClickPos.length()):
						item.select(0)
						_on_TuningList_item_activated()
					else:
						last_scroll = root.get_scroll()
