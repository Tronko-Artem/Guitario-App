extends Panel

func _on_ContactSupportButton_pressed():
	Input.vibrate_handheld(50)
	OS.shell_open("mailto:guitario.help@gmail.com?subject=Guitario%20Support&body=How%20can%20we%20help%20you?%0A")


func _on_BugReportButton_pressed():
	Input.vibrate_handheld(50)
	OS.shell_open("mailto:guitario.help@gmail.com?subject=Guitario%20Bug%20Report&body=What%20seems%20to%20be%20a%20problem?%0A")


func _on_FeatureRequestButton_pressed():
	Input.vibrate_handheld(50)
	OS.shell_open("mailto:guitario.help@gmail.com?subject=Guitario%20Feature%20Request&body=How%20can%20we%20make%20Guitario%20more%20useful%20for%20you?%0A")


func _on_FeedbackButton_pressed():
	Input.vibrate_handheld(50)
	OS.shell_open("https://play.google.com")


func _on_DonateButton_pressed():
	Input.vibrate_handheld(50)
	OS.shell_open("http://qiwi.com/n/BYOLE433")
