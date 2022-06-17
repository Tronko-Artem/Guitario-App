extends Node

var DataCDB: File = File.new()
var chordsDict: Dictionary
var chordsList: Dictionary
var chordsData: Dictionary
var chordForms: Array

var scaleData: Dictionary
var scaleForms: Dictionary

var tuningData: Dictionary
var tuningList: Dictionary

var note: String = "A"
var form: String = "maj"
var scale: String = "none"

var chordNum: int = 0
var chordDrawable: bool = false
var chordZeroDrawable: bool = false
var scaleDrawable: bool = false
var scaleChords: bool = false

var chordNone: Array = [0, 0, 0, 0, 0, 0]

var favorite_Check: bool = false

var tuningChanged : bool = false
var tuningForm : String = "E A D G B E"
var tuningName : String = "Standard"

var favoriteSelected : bool = false

# Parsing all information from JSON files while app is loading
func _ready() -> void:
	chordsList[0] = chordNone
	DataCDB.open("res://ChordsData.cdb", File.READ)
	chordsData = parse_json(DataCDB.get_as_text())
	DataCDB.close()
	parse_Chord_Forms()
	DataCDB.open("res://ScaleData.cdb", File.READ)
	scaleData = parse_json(DataCDB.get_as_text())
	DataCDB.close()
	parse_Scale_Forms()
	DataCDB.open("res://TuningData_SixString.cdb", File.READ)
	scaleData = parse_json(DataCDB.get_as_text())
	DataCDB.close()
	parse_Tuning_Forms()

# Method for correct working with alternative note names
func note_Converter() -> String:
	var noteDB: String = note
	match noteDB:
		"Do":  noteDB = "C"
		"Do#": noteDB = "C#"
		"Re": noteDB = "D"
		"Re#": noteDB = "D#"
		"Mi": noteDB = "E"
		"Fa": noteDB = "F"
		"Fa#": noteDB = "F#"
		"Sol": noteDB = "G"
		"Sol#": noteDB = "G#"
		"La": noteDB = "A"
		"La#": noteDB = "A#"
		"Si": noteDB = "B"
	return noteDB

# Method for parsing scale forms
func parse_Scale_Forms() -> void:
	for sheet in scaleData["sheets"]:
		if sheet["name"] == "ScaleData":
			for scaleData in sheet["lines"]:
				var scaleForm: Array
				for i in scaleData["scaleForm"].length():
					scaleForm.append(int(scaleData["scaleForm"][i]))
				scaleForms[str(scaleData["scaleName"])] = scaleForm

# Method for parsing chord forms
func parse_Chord_Forms() -> void:
	for sheet in chordsData["sheets"]:
		if sheet["name"] == tuningName:
			for noteName in sheet["lines"]:
				if noteName["noteName"] == "A":
					for chordForm in noteName["chordForm"]:
						chordForms.append(chordForm["formName"])

# Method for parsing tuning forms
func parse_Tuning_Forms() -> void:
	for sheet in scaleData["sheets"]:
		if sheet["name"] == "TuningData":
			for tuningData in sheet["lines"]:
				var tuningOffset : Array
				var tuningNum : String = ""
				for tone in tuningData["tuningShift"]:
					if tone == ",":
						if tuningNum == "":
							continue
						else:
							tuningOffset.append(int(tuningNum))
							tuningNum = ""
							continue
					tuningNum += tone
				if tuningNum != "":
					tuningOffset.append(int(tuningNum))

				tuningList[tuningData["tuningName"]] = []
				tuningList[tuningData["tuningName"]].append(tuningOffset)
				tuningList[tuningData["tuningName"]].append(tuningData["tuningForm"])

# Method for parsing chord fingerings
func parse_Chords_Data():
	chordsList.clear()
	var noteDB: String = note_Converter()
	for sheet in chordsData["sheets"]:
		if sheet["name"] == tuningName:
			for noteName in sheet["lines"]:
				if noteName["noteName"] == noteDB:
					for chordForm in noteName["chordForm"]:
						if chordForm["formName"] == form:
							var chordCount: int = 0

							for formKinds in chordForm["formKinds"]:
								var chord: Array
								var new_chord = formKinds.duplicate()
								new_chord.erase("formShape")
								var fretNum: String = ""

								for fret in formKinds["formShape"]:
									if fret == "!":
										chord.append(99)
										continue
									if fret == ",":
										if fretNum == "":
											continue
										else:
											chord.append(int(fretNum))
											fretNum = ""
											continue
									fretNum += fret

								if fretNum != "":
									chord.append(int(fretNum))
								chordsList[chordCount] = chord
								chordCount += 1
	if chordsList.size() == 0:
		chordsList[0] = chordNone
