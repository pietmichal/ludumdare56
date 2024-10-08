class_name HitBox
extends Area2D

var isActive: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isActive:
		isActive = false
		for area in get_overlapping_areas(): 
			if area is HurtBox and area.get_parent() != get_parent():
					area.on_hit(1)
					get_parent().on_attack()
