extends Node2D

onready var startingNotePos = get_parent().get_node("String0").position.y
var note: String
var rootNote: String

func _draw() -> void:
	if ChordsData.scaleDrawable && ChordsData.scale != "":
		scale_Drawer()

# Guitar scale drawing funtion
func scale_Drawer() -> void:
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(0.2, 0.2))
		for stringNum in Global.tuning.size():
			var curStringNum = abs(stringNum - get_parent().curHand)
			var notePos: Vector2 = Vector2(get_parent().get_node("String%d" % curStringNum).position.x * 5 - 250, startingNotePos - 50)
			var noteOffset: int = 0
			var rootNoteChecked = false
			var stringOffset: int = 0
			var rootNotePos: Vector2 = Vector2.ZERO
			# Checking notes on the frets
			for fret in 25:
				note = Global.NOTES[(Global.tuning[stringNum] + fret) % 12][Global.noteView]
				# Cheking if a note equal to the root note
				if note == ChordsData.note && !rootNoteChecked:
					rootNoteChecked = true
					rootNotePos = Vector2(notePos.x, notePos.y - Global.NOTEOFFSET)
				# Drawing notes if the root note was found
				if rootNoteChecked:
					if stringOffset > 11:
						stringOffset = 0
					if ChordsData.scaleForms[ChordsData.scale][stringOffset] == 1:
						draw_texture(Global.noteTextures[note], Vector2(notePos.x, notePos.y * 5), Color(1, 1, 1, 0.8))
						notePos.y += Global.NOTEOFFSET
					else:
						notePos.y += Global.NOTEOFFSET
					stringOffset += 1
				# Adding an offset if the root note isn't found
				else:
					noteOffset += 1
					notePos.y += Global.NOTEOFFSET
			# Drawing the missing notes in the guitar scale
			for offset in noteOffset:
				note = Global.NOTES[(Global.tuning[stringNum] + noteOffset - offset - 1) % 12][Global.noteView]
				if ChordsData.scaleForms[ChordsData.scale][-(offset +1)] == 1:
					draw_texture(Global.noteTextures[note], Vector2(rootNotePos.x, rootNotePos.y * 5), Color(1, 1, 1, 0.8))
					rootNotePos.y -= Global.NOTEOFFSET
				else:
					rootNotePos.y -= Global.NOTEOFFSET
		return
