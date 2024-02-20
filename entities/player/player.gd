extends Entity

@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var hitboxMeleeAttack = get_node("HitBoxMeleeAttack")

@onready var animationManager = AnimationManager.new()
@onready var movement = MovementHandler.new(self)
var HP : HealthPoint
@onready var meleeAttack = AttackHandler.new(self, hitboxMeleeAttack)

func _init():
	initEntity()
	meleeAttackDamage = ConstantNumber.playerMeleeDamage
	healthPoint = ConstantNumber.playerHealthPoint
	movementSpeed = ConstantNumber.playerSpeed
	dashSpeed = ConstantNumber.playerDashSpeed
	HP = HealthPoint.new(self)

func _physics_process(delta):
	move(delta)
	playerAnimation(delta)
	meleeAttack.updateHitbox()
	if(Input.is_action_just_pressed("melee_attack")):
		meleeAttack.attack(meleeAttackDamage)

func move(delta : float):
	#Check user input movement
	movement.checkPlayerInput()
	#Update last direction of player facing
	movement.updateLastDirection()
	#Check is player dash or not
	if Input.is_action_just_pressed("dash"):
		movement.setState(EntityState.dash);
	#if player dash then do the dash thing, other wise do movement
	if(movementState == EntityState.dash):
		movement.moveImediately(delta,dashSpeed,ConstantNumber.playerDashDuration)
	else :
		#Calculate player movement in 4 directional
		movement.movementHandler()

func playerAnimation(delta : float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer,velocity)
	#Flip direction of player 
	animationManager.flipAnimation(lastDirection, animationSprite, delta)
	
func damaged(direction: int, damage: int):
	HP.updateHP(healthPoint - 1)


