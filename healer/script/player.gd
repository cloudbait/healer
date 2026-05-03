extends CharacterBody2D

class_name Player

signal healthChanged
signal manaChanged

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

@export var maxHealth=30
@onready var currentHealth=30
@export var maxMana=30
@onready var currentMana=30
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer=$Timer
@onready var mtimer=$manatimer

var poisond=false



	
func _on_manatimer_timeout() -> void:
	if currentMana<maxMana:
		currentMana+=1
		manaChanged.emit()


func heal():
	if Input.is_action_just_pressed("selfheal"):
		if (currentMana-5)>=0 and (currentHealth!=maxHealth):
			currentHealth+=10
			healthChanged.emit()
			currentMana-=5
			manaChanged.emit()
			if currentHealth>maxHealth:
				currentHealth=maxHealth
				healthChanged.emit()
	
	#aif Input.is_action_just_pressed("healpulse"):
		
		
		
		
#DEATH
func death():
	if currentHealth<=0 or Input.is_action_just_pressed("giveup"):
		currentHealth=maxHealth
		healthChanged.emit()
		get_tree().reload_current_scene()	
	
		
		
		
		
func poison():
	poisond=true
	timer.start()
func _on_timer_timeout() -> void:
	if poisond==true:
		currentHealth-=2
		healthChanged.emit()
		animated_sprite_2d.play()

		
		
func _ready():
	var poisone=get_node("../poison")
	poisone.poisoned.connect(poison)
	mtimer.start()
	
	
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move left", "move right")
	#input direction --> -1 0 1
	#flip
	if direction>0:
		animated_sprite_2d.flip_h=false
	elif direction<0:
		animated_sprite_2d.flip_h=true
	if is_on_floor():
		if direction==0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
	if direction:
		velocity.x = direction * SPEED
	else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("selfcure"):
			if poisond==true:
				if currentMana-20>=0:
					poisond=false
					currentMana-=20
					manaChanged.emit()
			
			
		
	move_and_slide()
	heal()
	death()
	
