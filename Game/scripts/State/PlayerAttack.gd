extends StateBase

@export var hitBoxCollisionShape : CollisionShape3D

@export var bladeMaterialEffectAnimationPlayer: AnimationPlayer
@export var VFX_Blade : Node3D
@export var VFX_Hit : GPUParticles3D

var damage: int = 25

var slideSpeed: float = 500
var remainSlideDuration: float
var facingDir: Vector3

@export var nextAttackState: String
var can_attack_again: bool

var mousePosition : Vector2

func _input(event):
	if event is InputEventMouse:
		mousePosition = event.position
		

func rotateToMouseCursor():
	var space_state = get_world_3d().direct_space_state
	var camera = get_tree().root.get_camera_3d()
	
	var rayOrigin = camera.project_ray_origin(mousePosition)
	var rayEnd = rayOrigin + camera.project_position(mousePosition,1000)
	var query = PhysicsRayQueryParameters3D.create(rayOrigin,rayEnd)
	var result = space_state.intersect_ray(query)
	
	if result.has("position"):
		var lookPos = result["position"]
		lookPos.y = global_position.y
		var lookDir = lookPos - global_position
		var lookDir2D = Vector2(lookDir.z, lookDir.x)
		character.visual.rotation.y = lookDir2D.angle()

func enableHitBox():
	hitBoxCollisionShape.disabled = false
	#print("hit box disable *", hitBoxCollisionShape.disabled)
	
func disableHitBox():
	hitBoxCollisionShape.disabled = true
	#print("hit box disable *", hitBoxCollisionShape.disabled)

func enter():
	super.enter()
	
	can_attack_again = false
	
	character.velocity.x = 0 
	character.velocity.z = 0
	
	VFX_Blade.visible = true
	bladeMaterialEffectAnimationPlayer.stop()
	bladeMaterialEffectAnimationPlayer.play("PlayBladeVFX")
	
	remainSlideDuration = animationPlayer.current_animation_length * 0.3
	
	rotateToMouseCursor()
	
func exit():
	super.exit()
	disableHitBox()
	VFX_Blade.visible = false

func state_update(_delta:float):
	
	remainSlideDuration -= _delta
	
	facingDir = character.visual.transform.basis.z
	
	if remainSlideDuration > 0:
		character.velocity.x = facingDir.x * slideSpeed * _delta
		character.velocity.z = facingDir.z * slideSpeed * _delta
	else :
		character.velocity.x = move_toward(character.velocity.x, 0, character.SPEED)
		character.velocity.z = move_toward(character.velocity.z, 0, character.SPEED)
	
	if animationPlayer.is_playing() == false:
		state_machine.switchTo("Idle")
	
	if nextAttackState != '' && can_attack_again && character.attackKey_pressed:
		state_machine.switchTo(nextAttackState)


func _on_hit_box_body_entered(body):
	if body.is_in_group("Enemy"):
		body.applyDamage(damage)
		
		var position = body.global_position
		position.y = 1.5
		VFX_Hit.global_position = position
		VFX_Hit.restart()
		
		remainSlideDuration = 0

func set_canAttackAgain():
	can_attack_again = true
