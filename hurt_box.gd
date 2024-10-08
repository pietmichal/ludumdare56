class_name HurtBox
extends Area2D

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_hit(damage: int) -> void:
	get_parent().on_hit(damage)
	
