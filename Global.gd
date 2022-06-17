extends Node


const NOTES: Array = [["C", "Do"], ["C#", "Do#"], ["D", "Re"], ["D#", "Re#"], ["E", "Mi"], ["F", "Fa"],
					  ["F#", "Fa#"], ["G", "Sol"], ["G#", "Sol#"], ["A", "La"], ["A#", "La#"], ["B", "Si"]]

# Tuning variable shifts are starting from C2: C2 = 0, C#2 = 1, D2 = 2...
const TUNING = [4, 9, 14, 19, 23, 28]

# Shift for drawing note circles
var tuning = [4, 9, 14, 19, 23, 28]
const NOTEOFFSET = 304

var noteSounds: Dictionary
var noteTextures: Dictionary
var fretboardTextures: Array

var noteView: int = 0

var tween: Tween = Tween.new()


func _ready() -> void:
	# Adding tween node to the root
	add_child(tween)
	# Preload note sounds into a dictionry
	loadData("res://files/note_sounds/", noteSounds)
	# Preload note textures into a dictionry
	loadData("res://files/notes/", noteTextures)
	fretboardTextures.append(preload("res://files/fretboard_onesize_dark.svg"))
	fretboardTextures.append(preload("res://files/fretboard_onesize_light.svg"))

# Adding resources from the directory
func loadData(path: String, dict: Dictionary) -> void:
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var fileName = dir.get_next()
		while fileName != "":
			if !dir.current_is_dir():
				if fileName.ends_with(".import"):
					fileName = fileName.replace(".import", "")
					dict[fileName.get_basename()] = load(path.plus_file(fileName))
			fileName = dir.get_next()
