class_name HiveSystem
extends Node2D

signal tc_bite()

var tinyCreatureScene = preload("res://tiny_creature.tscn")

var playerPosition: Vector2 = Vector2(0,0)

var bitesLeft = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Hive.tc_bite.connect(on_bite)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var creatures = get_tree().get_nodes_in_group("TinyCreatures") as Array[TinyCreature]
	print(creatures.size(), " fps:", Engine.get_frames_per_second())
	# debug stuff
	if Input.is_action_just_pressed("spawnTC"): 
		for i in range(0, 100):
			spawn_tiny_creature()

func on_bite() -> void:
	# play "nom" sound
		
	bitesLeft -= 1
	
	if bitesLeft <= 0: 
		spawn_tiny_creature()
		bitesLeft = 2
	
	
func spawn_tiny_creature() -> void:	
	var creatures = get_tree().get_nodes_in_group("TinyCreatures") as Array[TinyCreature]
	
	var instance = tinyCreatureScene.instantiate()
	
	if !creatures.is_empty(): instance.position = creatures.pick_random().position
	
	get_parent().get_node("Node2D").add_child(instance)
