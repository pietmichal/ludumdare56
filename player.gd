class_name Player
extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speedVectorToApply = Vector2(0,0)
	
	if Input.is_action_pressed("up"): 
		speedVectorToApply.y -= 100;
	
	if Input.is_action_pressed("down"): 
		speedVectorToApply.y += 100;
		
	
	if Input.is_action_pressed("left"): 
		speedVectorToApply.x -= 100;
	
	if Input.is_action_pressed("right"): 
		speedVectorToApply.x += 100;
	
	if speedVectorToApply.x == speedVectorToApply.y: speedVectorToApply /= sqrt(2)
	
	position += speedVectorToApply * delta;
