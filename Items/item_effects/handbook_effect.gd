class_name HandbookEffect extends ItemEffect

var document : Array[String] = ["This handbook is intended for lifeguards in AECC and provides a brief overview of duties and general guidelines to follow.", 
										"General rules\nAlways work in shifts\nMake sure one partner is always on deck\nImmediately aid anyone who requests assistance", 
										"In the case a swimmer requests for equipment, open the storage room. Make sure to log down which equipment is taken and the quantity. ALWAYS make sure to write down who has requested which items and see that they are all returned at the end of the day.\nKeep the storage room locked whenever not in use.",
										"In the case of emergencies, act accordingly:\nIf someone is drowning, immediately go to aid them.\nIn the case of a leak, tell your shift partner and go to investigate. Lock the door to the room if there is a burst pipe or worse and call maintenance.\nIn case of injury, aid them out of the pool (if they are swimming) and stay with them. If the first aid kit does not treat their injuries, call paramedics."]

func use() -> void:
	PauseMenu.hide_pause_menu()
	DocumentViewer.show_document(document)
