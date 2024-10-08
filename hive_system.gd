class_name HiveSystem
extends Node2D

signal tc_bite()

var tinyCreatureScene = preload("res://tiny_creature.tscn")

var bitesLeft = 3
# Called when the node enters the scene tree for the first time.aa
func _ready() -> void:
	Hive.tc_bite.connect(on_bite)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var creatures = get_tree().get_nodes_in_group("TinyCreatures") as Array[TinyCreature]
	# debug stuff
	if Input.is_action_just_pressed("spawnTC"): 
		for i in range(0, 10):
			spawn_tiny_creature()

func on_bite() -> void:
	# play "nom" sound
		
	bitesLeft -= 1
	
	if bitesLeft <= 0: 
		spawn_tiny_creature()
		bitesLeft = 2
	
	
func spawn_tiny_creature() -> void:	
	var creatures = get_tree().get_nodes_in_group("TinyCreatures") as Array[TinyCreature]
	
	if creatures.size() > 500: return
	
	var instance = tinyCreatureScene.instantiate()
	
	if !creatures.is_empty(): instance.position = creatures.pick_random().position
	
	get_parent().get_node("Node2D").add_child(instance)
