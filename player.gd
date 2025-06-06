extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var hp = 100
var open_bugs = 7
var closed_bugs = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	if(hp<=0 || position.y>650):
		anim.play("Death")
		var tree= get_tree()
		await anim.animation_finished
		tree.change_scene_to_file("res://menu.tscn")  
		# Add the gravity.
		
	if(open_bugs<=0):
		anim.play("Win")
		var tree= get_tree()
		await anim.animation_finished
		tree.change_scene_to_file("res://menu.tscn")  
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")
	if direction!=0:
		anim.flip_h = direction<0 
	if velocity.y > 0:
		anim.play("Fall")
	
	
	move_and_slide()
