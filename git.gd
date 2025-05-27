extends CharacterBody2D
const SPEED = 4000.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0;
var player = null;
var alive = true;
@onready var anim = $Body/AnimatedSprite2D
func _physics_process(delta):
	if position.y>650:
		alive = false;
		queue_free()
	if(!alive):
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.x = direction * SPEED * delta
	if player!=null:
		direction = (player.position - self.position).normalized().x 
		anim.flip_h = direction<0
		
	move_and_slide()

func _on_area_2d_body_entered(body):
	if(!alive):
		return
	if body.name == "Player":
		direction = (body.position - self.position).normalized().x 
		player = body
		
	anim.flip_h = direction<0
	anim.play("Walk")


func _on_area_2d_body_exited(body):
	if(!alive):
		return
	anim.flip_h = direction<0
	anim.play("Idle")
	if body.name == "Player":
		direction = 0
		player = null


func _on_death_body_entered(body):
	if body.name == "Player":
		body.velocity.y =  -300
		anim.play("Hurt")
		await anim.animation_finished
		death()

func death():
	alive = false
	anim.play("Death")
	await anim.animation_finished
	queue_free()


func _on_death_2_body_entered(body):
	if body.name == "Player" && alive:
		body.hp -= 60
		alive = false
		anim.play("Attack")
		await anim.animation_finished
		death()
