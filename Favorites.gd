extends Panel

onready var favorites_Data: File = File.new()

onready var fav_Texture_Off: Texture = preload("res://files/favorite.svg")
onready var fav_Texture_On: Texture = preload("res://files/favorite_selected.svg")
onready var del_Texture: Texture = preload("res://files/less.svg")

var favorite: Dictionary = {
	"Note": "",
	"Form": "",
	"Chord": [],
	"Tuning": [],
	"TuningForm": "",
	"TuningName": ""
	}
var fav: bool = false
var sv: Save = Save.new()
onready var root: Tree = $FavoriteList

# Method for loading data to favorites list
func _ready() -> void:
	if ResourceLoader.exists("user://FavoriteChords.tres"):
		sv = ResourceLoader.load("user://FavoriteChords.tres")
		add_Items_In_List()

# Method for reacting to pressing "favorite" button
func _on_FavoriteButton_pressed() -> void:
	Input.vibrate_handheld(50)
	search_Data()
	if !fav:
		add_To_Favorite()
#		prints("Favorite added", favorite)
	else:
		delete_From_Favorite()
#		print("Favorite deleted")

# Method that getting current settings of app to display a chord correctly
func get_Current_Data() -> Dictionary:
	var current: Dictionary = {}
	if ChordsData.chordsList[0] == ChordsData.chordNone:
		ChordsData.chordNum = 0
	current["Note"] = ChordsData.note_Converter()
	current["Form"] = ChordsData.form
	current["Chord"] = ChordsData.chordsList[ChordsData.chordNum]
	current["Tuning"] = Global.tuning
	current["TuningForm"] = ChordsData.tuningForm
	current["TuningName"] = ChordsData.tuningName
	return current

# Method for adding to favorite
func add_To_Favorite() -> void:
	sv.data.push_back(get_Current_Data())
	get_parent().get_node("FavoriteButton").icon = fav_Texture_On
	fav = true
	add_Items_In_List()
	ResourceSaver.save("user://FavoriteChords.tres", sv)

# Deleting from favorite
func delete_From_Favorite() -> void:
	sv.data.remove(search_Data())
	get_parent().get_node("FavoriteButton").icon = fav_Texture_Off
	fav = false
	add_Items_In_List()
	ResourceSaver.save("user://FavoriteChords.tres", sv)

# Scanning if this chord in favorite list or not
func search_Data() -> int:
	var current:= get_Current_Data()
	for i in sv.data.size():
		var data = sv.data[i]
		if is_equal(data, current):
#			print("Favorite")
			get_parent().get_node("FavoriteButton").icon = fav_Texture_On
			fav = true
			return i
		else:
#			print("Not Favorite")
			get_parent().get_node("FavoriteButton").icon = fav_Texture_Off
			fav = false
	return -1

# Method for comparsion current chord form with favorites
func is_equal(dict1: Dictionary, dict2: Dictionary) -> bool:
	if dict1["Note"] != dict2["Note"]:
		return false
	if dict1["Form"] != dict2["Form"]:
		return false
	if dict1["TuningName"] != dict2["TuningName"]:
		return false
	return dict1["Chord"] == dict2["Chord"]

# Method for adding chord form to favorite lists
func add_Items_In_List() -> void:
	root.clear()
	for i in sv.data:
		var item: TreeItem = $FavoriteList.create_item(root)
		item.set_text(0, i["Note"] + " " + i["Form"] + " (" + str(i["Chord"].min()) +  " fret)")
		item.set_metadata(0, i)
		item.set_text_align(0, TreeItem.ALIGN_CENTER)
		item.add_button(0, del_Texture)


func _on_Changes() -> void:
	search_Data()


# Deleting from list with '-' button
func _on_FavoriteList_button_pressed(item: TreeItem, column: int, id: int) -> void:
	if deletable:
		sv.data.remove(sv.data.find(item.get_metadata(column)))
		add_Items_In_List()
		ResourceSaver.save("user://FavoriteChords.tres", sv)
		deletable = false
	if sv.data.empty():
		get_parent().get_node("FavoriteButton").icon = fav_Texture_Off
		fav = false
	search_Data()

var last_scroll: Vector2
var startClickPos: Vector2
var endClickPos: Vector2
var deletable: bool = false

# Method for correct input from mobile devices for favorites list
func _on_FavoriteList_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			var item := root.get_item_at_position(event.position)
			if item:
				var button := item.get_button(0, 0)
				if event.pressed:
					startClickPos = event.position
					item.select(0)
					last_scroll = root.get_scroll()
				else:
					endClickPos = event.position
					if last_scroll == root.get_scroll() && is_equal_approx(startClickPos.length(), endClickPos.length()):
						item.select(0)
						_on_FavoriteList_item_activated()
						if button:
							deletable = true
					else:
						last_scroll = root.get_scroll()


func _on_FavoriteList_item_activated() -> void:
	var data = root.get_selected().get_metadata(0)
	get_parent().get_node("RootNoteButton").text = data["Note"]
	get_parent().get_node("ChordTypeButton").text = data["Form"]
	ChordsData.tuningName = data["TuningName"]
	Global.tuning = data["Tuning"]
	ChordsData.tuningForm = data["TuningForm"]
	ChordsData.note = data["Note"]
	ChordsData.form = data["Form"]
	ChordsData.parse_Chords_Data()
	ChordsData.chordNum = ChordsData.chordsList.values().find(data["Chord"])
	ChordsData.favoriteSelected = true
	search_Data()
