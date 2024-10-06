class_name Swordguy
extends RigidBody2D

var health: int = 10

var deadbodyScene = preload("res://deadbody.tscn")

var maxSpeed = 20
var attackTimer: Timer = Timer.new()
var animTimer: Timer = Timer.new()
var tintTimer: Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(attackTimer)
	add_child(animTimer)
	add_child(tintTimer)
	attackTimer.timeout.connect(enable_attack)
	animTimer.timeout.connect(reset_anim)
	animTimer.set_one_shot(true)
	var chance = randi_range(0, 100)
	match chance:
		30,31,32,33,34,35: 
			# berserker
			attackTimer.start(1)
			maxSpeed = 200
			health = 20
		_: 
			# normal boi
			attackTimer.start(8 + randi_range(0, 4))
	tintTimer.set_one_shot(true)
	tintTimer.timeout.connect(reset_tint)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if $HitBox.isActive:
		$"Swordguy-attack".show()
		$Swordguy.hide()

		
	if health <= 0:
		var inst = deadbodyScene.instantiate()
		inst.position = position
		get_parent().add_child(inst)
		queue_free()
	
func enable_attack() -> void:
	$HitBox.isActive = true
	$"Swordguy-attack".show()
	$Swordguy.hide()
	animTimer.start(0.3)

func reset_anim() -> void:
	$"Swordguy-attack".hide()
	$Swordguy.show()
	
func on_hit(damage: int) -> void:
	health -= damage
	$"Swordguy-attack".modulate = Color(255, 0, 0)
	$Swordguy.modulate = Color(255, 0, 0)
	tintTimer.start(0.05)
	
func reset_tint() -> void:
	$"Swordguy-attack".modulate = Color(255, 255, 255)
	$Swordguy.modulate = Color(255, 255, 255)	
	
func on_attack() -> void:
	pass	

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void: 
	var step := state.get_step()
	var velocity := state.get_linear_velocity()
	var player := get_parent().get_node("Player")
	
	var speedToApply = 5
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
	
	state.set_linear_velocity(velocity)
