extends Sprite

onready var startingNotePos = $String0.position.y

var chord: Array
var note: Array
var octave: int
var visibility: bool = true
var curHand: int = 0

var timer: Timer = Timer.new()
var soundNum: int = 0


func _ready() -> void:
	timer.wait_time = 0.05
	timer.connect("timeout", self, "play_String")
	add_child(timer)
	chord_Drawer(ChordsData.chordNone)

# Chord Drawer Function
func chord_Drawer(chord: Array):
	var stringSound: AudioStreamSample
	# Moving and changing the texture and sound of a string
	for stringNum in Global.tuning.size():
		var curStringNum = abs(stringNum - curHand)
		var curString = get_node("String%d" % curStringNum)
		var curStringSound = get_node("String%d/StringSound" % curStringNum)
		# Moving and changing the string texture to "X" if the note isn't playing in the chord
		if chord[stringNum] == 99:
			curString.position.y = startingNotePos + Global.NOTEOFFSET * chord.min()
			curString.texture = Global.noteTextures["Cross"]
			curString.visible = visibility
		else:
			# Moving and changing the texture of a string
			note = Global.NOTES[(chord[stringNum] + Global.tuning[stringNum]) % 12]
			octave = (chord[stringNum] + Global.tuning[stringNum]) / 12
			curString.texture = Global.noteTextures[note[Global.noteView]]
			curString.position.y = startingNotePos + Global.NOTEOFFSET * chord[stringNum]
			# Changing sound of a string
			curStringSound.stream = Global.noteSounds[note[0] + str(octave)]
			curString.visible = visibility
	# Moving the camera position to the lowest fret in a chord
	get_parent().get_node("Camera").position.y = abs(Global.NOTEOFFSET * (chord.min() - 1) if chord.min() > 0 else 0)
	ChordsData.chordZeroDrawable = false

# Method for correct reacting of fretboard to changing some parameters
func _process(delta: float) -> void:
	if ChordsData.chordNum == 0 && !ChordsData.chordsList.empty() && ChordsData.chordZeroDrawable:
		visibility = true
		chord_Drawer(ChordsData.chordsList[0])

	if ChordsData.chordsList.empty() && !ChordsData.scaleDrawable && ChordsData.chordZeroDrawable:
		visibility = true
		chord_Drawer(ChordsData.chordsList[ChordsData.chordNum])

	if ChordsData.scaleDrawable:
		visibility = false
		chord_Drawer(ChordsData.chordNone)
		ChordsData.scaleDrawable = false

	if ChordsData.tuningChanged:
		chord_Drawer(ChordsData.chordsList[ChordsData.chordNum])
		ChordsData.tuningChanged = false

	if ChordsData.favoriteSelected:
		draw_Favorite_Chord()

# Scrolling up the chord dictionary
func _on_UpButton_pressed():
	if !ChordsData.chordsList.empty() && ChordsData.chordDrawable:
		ChordsData.chordNum += 1 if (ChordsData.chordNum < ChordsData.chordsList.keys().size() - 1) else - ChordsData.chordsList.keys().size() + 1
		chord = ChordsData.chordsList[ChordsData.chordNum]
		chord_Drawer(chord)
		Input.vibrate_handheld(50)

# Scrolling down the chord dictionary
func _on_DownButton_pressed():
	if !ChordsData.chordsList.empty() && ChordsData.chordDrawable:
		ChordsData.chordNum -= 1 if (ChordsData.chordNum > 0) else - ChordsData.chordsList.keys().size() + 1
		chord = ChordsData.chordsList[ChordsData.chordNum]
		chord_Drawer(chord)
		Input.vibrate_handheld(50)

# Playing sound of a string
func _on_SoundButton_pressed() -> void:
	soundNum = 0
	timer.start()
	Input.vibrate_handheld(50)

func play_String() -> void:
	if soundNum < 5:
		var curStringSound = get_node("String%d/StringSound" % abs(soundNum - curHand))
		if curStringSound.get_stream() != null:
			curStringSound.play()
		soundNum += 1
	else:
		timer.stop()

# Method for left-handed mode notes displaying
func _on_HandSelector_toggled(button_pressed: bool) -> void:
	curHand =  5 * int(button_pressed)
	self.flip_h = button_pressed
	if ChordsData.scaleChords:
		ChordsData.scaleDrawable = true
		$Drawer.update()
	else:
		if ChordsData.chordsList.empty():
			chord_Drawer(ChordsData.chordNone)
		else:
			chord_Drawer(ChordsData.chordsList[ChordsData.chordNum])
	Input.vibrate_handheld(50)

# Method for alternative note view displaying
func _on_NoteView_toggled(button_pressed: bool) -> void:
	Global.noteView = int(button_pressed)
	if ChordsData.scaleChords:
		ChordsData.scaleDrawable = true
		$Drawer.update()

# Method for drawing chords from favorite list
func draw_Favorite_Chord() -> void:
	ChordsData.chordDrawable = true
	ChordsData.chordZeroDrawable = true
	chord_Drawer(ChordsData.chordsList[ChordsData.chordNum])
