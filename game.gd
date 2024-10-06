extends Node2D

var tinyCreatureScene = preload("res://tiny_creature.tscn")
var deadbodyScene = preload("res://deadbody.tscn")
var swordguyScene = preload("res://swordguy.tscn")
var bossScene = preload("res://boss.tscn")

var deadbodySpawnTimer: Timer = Timer.new()
var spawnTimer: Timer = Timer.new()
var wave: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("#161616"))
	add_child(spawnTimer)
	add_child(deadbodySpawnTimer)
	spawn_init_deadbodies()
	
	spawnTimer.timeout.connect(spawn)
	spawnTimer.start(10)
		
	deadbodySpawnTimer.timeout.connect(spawn_deadbody)
	deadbodySpawnTimer.start(10)

func spawn_deadbody() -> void:
	var player := get_node("Player") as Player
	var inst = deadbodyScene.instantiate()
	inst.position = player.position + Vector2(get_sign() * 700, get_sign() * 400)
	add_child(inst)
	
func spawn_init_deadbodies() -> void:
	var player := get_node("Player") as Player
	for i in range(0, 40):
		var inst = deadbodyScene.instantiate()
		inst.position = player.position + Vector2(get_sign() * (700 + randi_range(0, 600)), get_sign() * (400 + randi_range(0, 600)))
		add_child(inst)	

func get_sign() -> int:
	# im a sinner >:)
	var sign = randi_range(-1, 1)
	if sign == 0: return get_sign()
	return sign

func spawn() -> void:
	match wave:
		0: 
			spawn_swordguy()
		1: 
			for i in range(0, 3): spawn_swordguy()
		2: 
			for i in range(0, 4): spawn_swordguy()
			spawnTimer.set_wait_time(15)
		3:
			var position = get_random_spawn_position()
			for i in range(0, 4): 
				spawn_swordguy_in_position(position + Vector2(randi_range(0, 50), randi_range(0, 50)))
			spawnTimer.set_wait_time(15)
		4: 
			for i in range(0, 5): spawn_swordguy()
			spawnTimer.set_wait_time(15)
		5: 
			for i in range(0, 10): spawn_swordguy()
			spawnTimer.set_wait_time(30)
		6: 
			var position = get_random_spawn_position()
			for i in range(0, 10): 
				spawn_swordguy_in_position(position + Vector2(randi_range(0, 50), randi_range(0, 50)))
			spawnTimer.set_wait_time(30)	
		7: 
			for i in range(0, 20): spawn_swordguy()
			spawnTimer.set_wait_time(50)
		8: 
			var position = get_random_spawn_position()
			for i in range(0, 20): 
				spawn_swordguy_in_position(position + Vector2(randi_range(0, 50), randi_range(0, 50)))
			spawnTimer.set_wait_time(50)
		9: 
			var position = get_random_spawn_position()
			for i in range(0, 30): 
				spawn_swordguy_in_position(position + Vector2(randi_range(0, 50), randi_range(0, 50)))
			spawnTimer.set_wait_time(60)
		10: 
			for i in range(0, 30): spawn_swordguy()
			var inst = bossScene.instantiate()
			inst.position = get_random_spawn_position()
			add_child(inst)

	wave += 1			

func get_random_spawn_position() -> Vector2:
	var player := get_node("Player") as Player
	return player.position + Vector2(get_sign() * (700 + randi_range(0, 400)), get_sign() * (400 + randi_range(0, 400)))

func spawn_swordguy() -> void:
	var player := get_node("Player") as Player
	spawn_swordguy_in_position(get_random_spawn_position())

func spawn_swordguy_in_position(position: Vector2) -> void:
	var inst = swordguyScene.instantiate()
	inst.position = position
	add_child(inst)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var creatures = get_tree().get_nodes_in_group("TinyCreatures") as Array[TinyCreature]
	
	if creatures.is_empty(): get_tree().change_scene_to_file("res://title.tscn")
