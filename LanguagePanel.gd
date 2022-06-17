extends Panel

func _ready():
	TranslationServer.set_locale("en")


func _on_LanguageButton_toggled(button_pressed):
	if button_pressed:
		TranslationServer.set_locale("ru")
	else:
		TranslationServer.set_locale("en")
