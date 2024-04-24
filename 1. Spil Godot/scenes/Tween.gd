extends Tween

var label: Label
var tween: Tween

func _ready():
	label = $Label  # Replace "Label" with the path to your Label node
	tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(label, Vector2(792, 118), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
