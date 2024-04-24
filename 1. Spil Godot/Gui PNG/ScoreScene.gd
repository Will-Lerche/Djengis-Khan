extends CanvasLayer

func _process(_delta):
	$ScoreCount.text = "Fjender dræbt: " + str(Global.Kill_count)

