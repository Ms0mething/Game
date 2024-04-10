class_name PlayerCharacter
extends CharacterBody3D

@onready var visual : Node3D = $VisualNode
@onready var animationPlayer: AnimationPlayer = $VisualNode/AnimationPlayer

@onready var footStepVFX: GPUParticles3D = $VisualNode/VFX/Footstep_GPUParticles3D 

const SPEED = 5.0

var direction : Vector3
var SlideKey_pressed : bool
var attackKey_pressed : bool

var maxHealth : int = 100
var currentHealth : int:
	set(new_value):
		currentHealth = new_value
		emit_signal("playerHealthUpdated", currentHealth, maxHealth)

var coinNumber: int:
	set(new_value):
		coinNumber = new_value
		emit_signal("coinNumberUpdated", coinNumber)

signal coinNumberUpdated(newValue)
signal playerHealthUpdated(newValue, maxValue)

var isDead : bool

func _ready():
	currentHealth = maxHealth

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	SlideKey_pressed = Input.is_action_just_pressed("slide")
	attackKey_pressed = Input.is_action_just_pressed("Attack")
	
	move_and_slide()

func Addcoin(value:int):
	coinNumber += value
	#print(coinNumber)
	
	
	
	
func takeDamage(damage: int, enemy_position : Vector3):
	currentHealth -= damage
	currentHealth = clamp(currentHealth, 0, maxHealth)
	print("The Player took damage : ", damage, " current health : ", currentHealth)
	
	get_node("StateMachine").switchTo("Hurt")
	
	if get_node("StateMachine").currectState.name == "Hurt":
		get_node("StateMachine").currectState.pushBackDir = (global_position - enemy_position).normalized()
	
func AddHealth(value: int):
	currentHealth += value
	currentHealth = clamp(currentHealth, 0, maxHealth)






















	
