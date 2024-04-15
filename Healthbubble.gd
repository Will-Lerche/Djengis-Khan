extends Node2D


func _on_VSlider_value_changed(value:float) -> void:
	$TextureProgress.value = value 
	
