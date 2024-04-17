extends CanvasLayer


var Kinesere_skudt = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreCount.text = "Kineser drabt: " + str(Kinesere_skudt)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
