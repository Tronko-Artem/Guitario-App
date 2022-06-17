extends Panel

var timer: Timer = Timer.new()

export var audio: AudioStream

var playing: bool = false

func _on_MoreBPMButton_pressed() -> void:
	Input.vibrate_handheld(50)
	$BPMSpinBox.value += 1
	if playing:
		create_Metronome_Sound()

func _on_LessBPMButton_pressed() -> void:
	Input.vibrate_handheld(50)
	$BPMSpinBox.value -= 1
	if playing:
		create_Metronome_Sound()

# Main function of metronome
func create_Metronome_Sound() -> void:
	var stream = audio.duplicate(true)
	var stream_data = stream.data
	var interval: int = 60.0 / $BPMSpinBox.value * stream.mix_rate * 4

	if interval % 2 != 0:
		interval += 1
	stream_data.resize(interval)

	for j in range(stream.data.size(), stream_data.size()):
		stream_data[j] = 0

	var new_data = stream_data
	for i in 8: #8 is the number of times the stream is gonna be copied into the file
		stream_data.append_array(new_data)

	stream.data = stream_data
	stream.loop_mode = 1
	stream.loop_end = stream_data.size() / 4
	$MetronomeSound.stream = stream
	$MetronomeSound.stop()
	$MetronomeSound.play()


func _on_PlayMetronomeButton_toggled(button_pressed: bool) -> void:
	playing = button_pressed
	Input.vibrate_handheld(50)
	if button_pressed:
		$PlayMetronomeButton/Play.visible = false
		$PlayMetronomeButton/Pause.visible = true
		create_Metronome_Sound()
	else:
		$PlayMetronomeButton/Play.visible = true
		$PlayMetronomeButton/Pause.visible = false
		$MetronomeSound.stop()
