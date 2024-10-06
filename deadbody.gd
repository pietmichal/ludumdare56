class_name Deadbody
extends RigidBody2D

var health: int = 10

var puddleScene = preload("res://puddle.tscn")
var tintTimer: Timer = Timer.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(tintTimer)
	tintTimer.set_one_shot(true)
	tintTimer.timeout.connect(reset_tint)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if health <= 0:
		var inst = puddleScene.instantiate()
		inst.position = position
		get_parent().add_child(inst)
		queue_free()

func on_hit(damage: int) -> void:
	health -= damage
	$Deadbody.modulate = Color(255, 0, 0)
	tintTimer.start(0.05)

func reset_tint() -> void:
	$Deadbody.modulate = Color(255, 255, 255)
