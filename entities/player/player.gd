extends Entity

@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var hitboxMeleeAttack = get_node("HitBoxMeleeAttack")
@onready var hitboxRangeAttack = get_node("HitBoxRangeAttack")
@onready var playerHitbox = get_node("CollisionShape3D")

@onready var animationManager = AnimationManager.new() 
var HP : HealthPoint
@onready var meleeAttack = AttackHandler.new(self, hitboxMeleeAttack)
@onready var rangeAttack = AttackHandler.new(self, hitboxRangeAttack)
var attackCountDown : float 

func _init():
	initEntity()
	meleeAttackDamage = ConstantNumber.playerMeleeDamage
	rangeAttackDamage = ConstantNumber.playerRangeDamage
	healthPoint = HealthPoint.new(self, ConstantNumber.playerHealthPoint)
	movementSpeed = ConstantNumber.playerSpeed
	dashSpeed = ConstantNumber.playerDashSpeed
	movement = MovementHandler.new(self)
	attackCountDown = 0

func _physics_process(delta):
	move(delta)
	playerAnimation(delta)
	attack(delta)

func move(delta : float):
	#Check user input movement
	var justMove = movement.checkPlayerInput()
	if(justMove):
		movement.setState(EntityState.moving)
	else :
		movement.setState(EntityState.idle)
	#Update last direction of player facing
	movement.updateLastDirection()
	#Check is player dash or not
	if Input.is_action_just_pressed("dash"):
		movement.setState(EntityState.dash);
	#if player dash then do the dash thing, other wise do movement
	if(movementState == EntityState.dash):
		#then dash
		movement.moveImediately(delta,dashSpeed,ConstantNumber.playerDashDuration)
	elif(movementState == EntityState.moving):
		#move depend on direction
		movement.movementHandler()

func playerAnimation(delta : float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer,movementState)
	#Flip direction of player 
	animationManager.flipAnimation(lastDirection, animationSprite, delta)
	
func damaged(direction: Vector3, damage: int, knockbackSpeed: int, knockbackDuration: float):
	#if player dash, be invisibility
	if(movementState!=EntityState.dash):
		healthPoint.decreaseHP(damage)

func attack(delta : float):
	meleeAttack.updateHitbox()
	#if press Z
	if(Input.is_action_just_pressed("melee_attack") && movementState != EntityState.attacking):
		movement.setState(EntityState.attacking)
		meleeAttack.meleeAttack(meleeAttackDamage)
	elif (Input.is_action_just_pressed("range_attack")):
		rangeAttack.aoeAttack(rangeAttackDamage)
	if(movementState == EntityState.attacking):
		if(attackCountDown >= ConstantNumber.playerMeleeCooldown):
			attackCountDown = 0
			movementState = EntityState.idle
		else:
			attackCountDown = delta + attackCountDown
			animationPlayer.play("MeleeAttack")
