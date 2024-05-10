extends Entity

@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var hitboxMeleeAttack = get_node("HitBoxMeleeAttack")
@onready var hitboxRangeAttack = get_node("HitBoxRangeAttack")
@onready var playerHitbox = get_node("CollisionShape3D")

@onready var nav : NavigationAgent3D = $NavigationAgent3D
@onready var rayCast : RayCastGroup = $RayCastGroup

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

var aiMode : bool = false
var mapInfo : MapGenerator

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

func triggerAI(map:MapGenerator):
	mapInfo = map
	aiMode = true

func move(delta : float):
	if(aiMode):
		aiMove(delta)
	else:
		manualMove(delta)
		
func manualMove(delta: float):
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
		
func aiMove(delta: float):
	#kill enemies
	#find exit
	findExit()
	pass
	
func findExit():
	if(mapInfo):
		#get all exit
		var exitList : Array[int] = mapInfo.otherExit
		# find nearest exit
		var distance : float = 1000
		var desExit : int = -1
		for i in range(exitList.size()):
			var exitPos : Array[int] = mapInfo.indexToXZ(exitList[i])
			var disExit : float = sqrt(pow((position.x - exitPos[0]),2)+pow((position.z - exitPos[1]),2))
			if(disExit < distance):
				distance = disExit
				desExit = exitList[i]
		#move to that exit
		#find exit position
		var desirePos : Array[int] = mapInfo.indexToXZ(desExit)
		nav.target_position = Vector3(desirePos[0] + 0.5, position.y, desirePos[1] + 0.5)
		print(nav.get_path())
		#set path for exit
		var desiredDirection = (nav.get_next_path_position() - position).normalized()
		#when no obstacles
		if(rayCast.collideVector == rayCast.noCollitionVector):
			direction = desiredDirection
		else:
			var direc2D = Vector2(desiredDirection.x,desiredDirection.z)
			rayCast.calInterest(direc2D)
			rayCast.calContext()
			direc2D = rayCast.directionVector[rayCast.getDirection()]
			direction.x = direc2D.x
			direction.z = direc2D.y
		print(nav.get_current_navigation_result().path)
		movement.setState(EntityState.moving)
		movement.updateLastDirection()
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
