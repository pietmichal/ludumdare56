class_name Enemy
extends RigidBody2D

var health = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0: queue_free()
	
func on_hit(damage: int) -> void:
	health -= damage	

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var step := state.get_step()
	var velocity := state.get_linear_velocity()
	
	velocity.x += 1 * step
	
	state.set_linear_velocity(velocity)
