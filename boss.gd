class_name Boss
extends RigidBody2D

var health: int = 5000

var deadbodyScene = preload("res://deadbody.tscn")

var maxSpeed = 20
var attackTimer: Timer = Timer.new()
var animTimer: Timer = Timer.new()
var tintTimer: Timer = Timer.new()
var endTimer: Timer = Timer.new()

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(attackTimer)
	add_child(animTimer)
	add_child(tintTimer)
	add_child(endTimer)
	endTimer.timeout.connect(endgame)
	endTimer.set_one_shot(true)
	attackTimer.timeout.connect(enable_attack)
	animTimer.timeout.connect(reset_anim)
	animTimer.set_one_shot(true)
	attackTimer.start(2)
	tintTimer.set_one_shot(true)
	tintTimer.timeout.connect(reset_tint)
	
func endgame() -> void:
	get_tree().change_scene_to_file("res://title.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if dead: return
	
	if $HitBox.isActive:
		$Boss2.show()
		$Boss1.hide()

		
	if health <= 0:
		hide()
		dead = true
		endTimer.start(5)
		attackTimer.stop()
	
func enable_attack() -> void:
	$HitBox.isActive = true
	$Boss2.show()
	$Boss1.hide()
	animTimer.start(0.3)

func reset_anim() -> void:
	$Boss2.hide()
	$Boss1.show()
	
func on_hit(damage: int) -> void:
	health -= damage
	$Boss2.modulate = Color(255, 0, 0)
	$Boss1.modulate = Color(255, 0, 0)
	tintTimer.start(0.05)
	
func reset_tint() -> void:
	$Boss2.modulate = Color(255, 255, 255)
	$Boss1.modulate = Color(255, 255, 255)	
	
func on_attack() -> void:
	pass	

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void: 
	if dead: return
	
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
