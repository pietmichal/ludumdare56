class_name TinyCreature
extends RigidBody2D

var baseSpeed = 100	
var maxSpeed = 300

var nomTimer: Timer = Timer.new()
var idleTimer: Timer = Timer.new()

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_scale = 0
	mass = 0
	add_to_group("TinyCreatures")
	add_child(nomTimer)
	add_child(idleTimer)
	nomTimer.start(1)
	nomTimer.timeout.connect(enable_hitbox)
	$PopSoundStream.play()
	idleTimer.start(10 + randi_range(0, 5))
	idleTimer.timeout.connect(idle_sound)
	
func idle_sound() -> void:
	var chance = randi_range(0, 100)
	match chance:
		0,1,2: $IdleSoundStream.play()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for collider in  get_colliding_bodies():
		if collider is TinyCreature:
			apply_force(Vector2(randi_range(-1, 1), randi_range(-1, 1)) * 50 * delta)	
			
			
func enable_hitbox():
	$HitBox.isActive = true
	
func on_attack() -> void:
	$NomSoundStream.play()
	Hive.tc_bite.emit()

func on_hit(damage: int) -> void:
	dead = true
	hide()
	$DeathSoundStream.play()
	$DeathSoundStream.finished.connect(queue_free)
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void: 
	if dead: return
	
	var step := state.get_step()
	var velocity := state.get_linear_velocity()
	var player := get_parent().get_node("Player")
	
	var distance = position.distance_to(player.position)
	var speedMult = 1 / (distance / 100)
	if speedMult > 1.5: speedMult = 1.5
	if speedMult < 0.3: speedMult = 4
	if speedMult < 1: speedMult = 1
	var speedToApply = baseSpeed * speedMult
	
	var speedVectorToApply = Vector2(0, 0)

	if player.position.x < position.x: speedVectorToApply.x -= speedToApply;
	elif player.position.x > position.x: speedVectorToApply.x += speedToApply;
		
	if player.position.y < position.y: speedVectorToApply.y -= speedToApply;
	elif player.position.y > position.y: speedVectorToApply.y += speedToApply;
	
	if speedVectorToApply.x == speedVectorToApply.y: speedVectorToApply /= sqrt(2)
		
	velocity += speedVectorToApply * step
		
	if velocity.x > maxSpeed: velocity.x = maxSpeed
	elif velocity.x < -maxSpeed: velocity.x = -maxSpeed
	
	if velocity.y > maxSpeed: velocity.y = maxSpeed
	elif velocity.y < -maxSpeed: velocity.y = -maxSpeed
	
	if distance < 50: state.set_linear_velocity(velocity/(100*step))
	else: state.set_linear_velocity(velocity)
	
	
