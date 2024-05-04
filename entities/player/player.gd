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

@onready var buffManager = BuffManager.new(self)
@onready var traitManager = TraitManager.new(self)
signal activeBuffsUpdated(activeBuffs:Array[BuffData])
signal modifyStatsFromActiveBuffs
signal playerDeath

var attackCountDown : float 
var isMeleeAttack : bool
var isRangeAttack : bool
var isRebirth : bool = false

func _init():
	initEntity()
	meleeAttackDamage = ConstantNumber.playerMeleeDamage
	rangeAttackDamage = ConstantNumber.playerRangeDamage
	healthPoint = HealthPoint.new(self, ConstantNumber.playerHealthPoint)
	movementSpeed = ConstantNumber.playerSpeed
	dashSpeed = ConstantNumber.playerDashSpeed
	movement = MovementHandler.new(self)
	attackCountDown = 0
	isMeleeAttack = false
	isRangeAttack = false
	defense = ConstantNumber.playerDefense

func _ready():
	connect("modifyStatsFromActiveBuffs",modifyStats)
	modifyStats()

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
	#if player dash or rebirth, be invisibility
	if(movementState!=EntityState.dash && !isRebirth):
		healthPoint.decreaseHP(damage)

func attack(delta : float):
	meleeAttack.updateHitbox()
	#if press Z
	if(Input.is_action_just_pressed("melee_attack") && movementState != EntityState.attacking):
		movement.setState(EntityState.attacking)
		isMeleeAttack = true
		meleeAttack.meleeAttack(meleeAttackDamage)
	elif (Input.is_action_just_pressed("range_attack")):
		movement.setState(EntityState.attacking)
		isRangeAttack = true
		rangeAttack.aoeAttack(rangeAttackDamage)
	if(movementState == EntityState.attacking && isMeleeAttack):
		if(attackCountDown >= ConstantNumber.playerMeleeCooldown):
			attackCountDown = 0
			movementState = EntityState.idle
			isMeleeAttack = false
		else:
			attackCountDown = delta + attackCountDown
			animationPlayer.play("MeleeAttack")
	elif(movementState == EntityState.attacking && isRangeAttack):
		if(attackCountDown >= 0.3):
			attackCountDown = 0
			movementState = EntityState.idle
			isRangeAttack = false
		else:
			attackCountDown = delta + attackCountDown
			animationPlayer.play("RangeAttack")

# Modify each player stat from buff percentage 
func modifyStats():
	meleeAttackDamage = calculateStatValue(ConstantNumber.playerMeleeDamage,DictionaryKey.meleeAttackDamage)
	rangeAttackDamage = calculateStatValue(ConstantNumber.playerRangeDamage,DictionaryKey.rangeAttackDamage)
	movementSpeed = calculateStatValue(ConstantNumber.playerSpeed,DictionaryKey.movementSpeed)
	var modifiedmaxHP = calculateStatValue(ConstantNumber.playerHealthPoint,DictionaryKey.maxHP)
	healthPoint.updateHPFromPercentage(modifiedmaxHP, ConstantNumber.playerHealthPoint)
	defense = calculateStatValue(ConstantNumber.playerDefense,DictionaryKey.defense)

# Calculate base stat with buff percentage
func calculateStatValue(baseStat,statType:String):
	var statPercentage = buffManager.getStatPercentage(statType) + traitManager.getStatPercentage(statType)
	return baseStat * (ConstantNumber.defaultPercentage + statPercentage)

# Make player invincible for period of time after rebirth
func setRebirthInvincible():
	isRebirth = true
	await get_tree().create_timer(ConstantNumber.rebirthInvincibleDuration).timeout
	isRebirth = false
