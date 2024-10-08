class_name TinyCreature
extends Node2D

var baseSpeed = 100	
var maxSpeed = 300

var nomTimer: Timer = Timer.new()
var idleTimer: Timer = Timer.new()

var dead = false

var body: RID
var shape: RID
var ci_rid: RID
var texture

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PopSoundStream.play()

	add_to_group("TinyCreatures")
	add_child(nomTimer)
	add_child(idleTimer)

	nomTimer.start(1)
	nomTimer.timeout.connect(enable_hitbox)

	idleTimer.start(10 + randi_range(0, 5))
	idleTimer.timeout.connect(idle_sound)
	
	body = PhysicsServer2D.body_create()
	shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(shape, 3)
	PhysicsServer2D.body_set_mode(body, PhysicsServer2D.BODY_MODE_RIGID)
	PhysicsServer2D.body_add_shape(body, shape)
	PhysicsServer2D.body_set_space(body, get_world_2d().space)
	PhysicsServer2D.body_set_param(body, PhysicsServer2D.BODY_PARAM_GRAVITY_SCALE, 0)	
	PhysicsServer2D.body_set_param(body, PhysicsServer2D.BODY_PARAM_MASS, 0.001)
	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(0, position))
	PhysicsServer2D.body_set_collision_layer(body, 0b1)
	PhysicsServer2D.body_set_collision_mask(body, 0b1)
	PhysicsServer2D.body_set_max_contacts_reported(body, 1)
	PhysicsServer2D.body_set_force_integration_callback(body, _integrate_forces)
	PhysicsServer2D.body_set_state_sync_callback(body, _state_sync)
	
	ci_rid = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(ci_rid, get_canvas_item())
	texture = load("res://tc1.png")
	RenderingServer.canvas_item_add_texture_rect(ci_rid, Rect2(-texture.get_size() / 2, texture.get_size()), texture)
	RenderingServer.canvas_item_set_transform(ci_rid, Transform2D(0, position))

func _state_sync(state: PhysicsDirectBodyState2D) -> void:
	position = state.transform.origin
	RenderingServer.canvas_item_set_transform(ci_rid, state.transform)
	
func idle_sound() -> void:
	var chance = randi_range(0, 100)
	match chance:
		0,1,2: $IdleSoundStream.play()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#for collider in get_colliding_bodies():
		#if collider is TinyCreature:
			#PhysicsServer2D.body_apply_force(body, Vector2(randi_range(-1, 1), randi_range(-1, 1)) * 50 * delta)
	pass
			
			
func enable_hitbox():
	$HitBox.isActive = true
	
func on_attack() -> void:
	$NomSoundStream.play()
	Hive.tc_bite.emit()

func on_hit(damage: int) -> void:
	dead = true
	hide()
	$DeathSoundStream.play()
	$DeathSoundStream.finished.connect(die)
	
func die() -> void:
	PhysicsServer2D.body_clear_shapes(body)
	PhysicsServer2D.free_rid(body)
	queue_free()
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void: 
	if dead: return
			
	var step := state.get_step()
	var velocity := state.get_linear_velocity()
	var playerPosition = Hive.playerPosition
	
	# variable shadowing
	var position = state.transform.origin
			
	var distance = position.distance_to(playerPosition)
	var speedMult = 1 / (distance / 100)
	if speedMult > 1.5: speedMult = 1.5
	if speedMult < 0.3: speedMult = 4
	if speedMult < 1: speedMult = 1
	var speedToApply = baseSpeed * speedMult
	
	var speedVectorToApply = Vector2(0, 0)

	if playerPosition.x < position.x: speedVectorToApply.x -= speedToApply;
	elif playerPosition.x > position.x: speedVectorToApply.x += speedToApply;
		
	if playerPosition.y < position.y: speedVectorToApply.y -= speedToApply;
	elif playerPosition.y > position.y: speedVectorToApply.y += speedToApply;
	
	if speedVectorToApply.x == speedVectorToApply.y: speedVectorToApply /= 1.41421356
		
	velocity += speedVectorToApply * step
		
	if velocity.x > maxSpeed: velocity.x = maxSpeed
	elif velocity.x < -maxSpeed: velocity.x = -maxSpeed
	
	if velocity.y > maxSpeed: velocity.y = maxSpeed
	elif velocity.y < -maxSpeed: velocity.y = -maxSpeed
	
	if distance < 50: state.set_linear_velocity(velocity/(100*step))
	else: state.set_linear_velocity(velocity)
	
	
