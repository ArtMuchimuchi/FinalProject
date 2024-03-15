extends Entity

@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var hitboxMeleeAttack = get_node("HitBoxMeleeAttack")
@onready var hitboxRangeAttack = get_node("HitBoxRangeAttack")
@onready var playerHitbox = get_node("CollisionShape3D")

@onready var animationManager = AnimationManager.new()
@onready var movement = MovementHandler.new(self)
var HP : HealthPoint
@onready var meleeAttack = AttackHandler.new(self, hitboxMeleeAttack)
@onready var rangeAttack = AttackHandler.new(self, hitboxRangeAttack)
@onready var buffManager = BuffManager.new(self)
signal activeBuffsUpdated(activeBuffs:Array[BuffData])
signal modifyStatsFromActiveBuffs

func _init():
	initEntity()
	meleeAttackDamage = ConstantNumber.playerMeleeDamage
	rangeAttackDamage = ConstantNumber.playerRangeDamage
	healthPoint = HealthPoint.new(self, ConstantNumber.playerHealthPoint)
	movementSpeed = ConstantNumber.playerSpeed
	dashSpeed = ConstantNumber.playerDashSpeed

func _ready():
	connect("modifyStatsFromActiveBuffs",modifyStats)

func _physics_process(delta):
	move(delta)
	playerAnimation(delta)
	attack()

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
		#then dash
		movement.moveImediately(delta,dashSpeed,ConstantNumber.playerDashDuration)
	else :
		#Calculate player movement in 4 directional
		movement.movementHandler()

func playerAnimation(delta : float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer,velocity)
	#Flip direction of player 
	animationManager.flipAnimation(lastDirection, animationSprite, delta)
	
func damaged(direction: Vector3, damage: int, knockbackSpeed: int, knockbackDuration: float):
	#if player dash, be invisibility
	if(movementState!=EntityState.dash):
		healthPoint.decreaseHP(damage)

func attack():
	meleeAttack.updateHitbox()
	if(Input.is_action_just_pressed("melee_attack")):
		meleeAttack.meleeAttack(meleeAttackDamage)
	elif (Input.is_action_just_pressed("range_attack")):
		rangeAttack.aoeAttack(rangeAttackDamage)

# Modify each player stat from buff percentage 
func modifyStats():
	meleeAttackDamage = calculateStatValue(ConstantNumber.playerMeleeDamage,DictionaryKey.meleeAttackDamage)
	rangeAttackDamage = calculateStatValue(ConstantNumber.playerRangeDamage,DictionaryKey.rangeAttackDamage)
	movementSpeed = calculateStatValue(ConstantNumber.playerSpeed,DictionaryKey.movementSpeed)
	var modifiedmaxHP = calculateStatValue(ConstantNumber.playerHealthPoint,DictionaryKey.maxHP)
	healthPoint.updateHPFromPercentage(modifiedmaxHP, ConstantNumber.playerHealthPoint)

# Calculate base stat with buff percentage
func calculateStatValue(baseStat,statType:String):
	var statPercentage = buffManager.getStatPercentage(statType)
	return baseStat * (ConstantNumber.defaultPercentage + statPercentage)
