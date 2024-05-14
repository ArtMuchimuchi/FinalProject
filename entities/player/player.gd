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
var enemiesPositionList : Array[Vector3] = []

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
	setTransferPlayerData()
	modifyStats()
	connect("modifyStatsFromActiveBuffs",modifyStats)

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
	#get enemies list
	getEnemiesList()
	#if have enemies on map, chase them
	if(enemiesPositionList):
		#check if enemies in attack range
		var isEnemyInRange = hitboxMeleeAttack.get_overlapping_bodies()
		#if yes attack them
		if(isEnemyInRange && movementState != EntityState.attacking):
			movement.setState(EntityState.idle)
			movement.setState(EntityState.attacking)
			isMeleeAttack = true
			meleeAttack.meleeAttack(meleeAttackDamage)
		#if not chase them
		else:
			movement.setState(EntityState.moving)
		#get closest enemies
		var closetEnemy : int = findClosetEnemy()
		#move close to enemy
		movement.aiMovement(enemiesPositionList[closetEnemy],
		nav,rayCast)
	else:
		#if no nemies
		#find exit
		movement.setState(EntityState.moving)
		findExit()
	
func getEnemiesList():
	var enemiesList = get_node("/root/MockRoom/Enemies").get_children()
	enemiesPositionList.clear()
	for i in range(enemiesList.size()):
		enemiesPositionList.append(enemiesList[i].position)
		
#find closet enemy and return it's index of enemiesPositionList
func findClosetEnemy() -> int:
	var minDistance : float = 1000
	var minEnemyIndex : int = -1
	for i in range(enemiesPositionList.size()):
		var distance = euclideanDistance(position.x, position.z,
		enemiesPositionList[i].x,enemiesPositionList[i].z)
		if(distance < minDistance):
			minDistance = distance
			minEnemyIndex = i
	return minEnemyIndex
	
func findExit():
	if(mapInfo):
		#get all exit
		var exitList : Array[int] = mapInfo.otherExit
		# find nearest exit
		var distance : float = 1000
		var desExit : int = -1
		for i in range(exitList.size()):
			var exitPos : Array[int] = mapInfo.indexToXZ(exitList[i])
			var disExit : float = euclideanDistance(position.x,position.z,exitPos[0],exitPos[1])
			if(disExit < distance):
				distance = disExit
				desExit = exitList[i]
		#move to that exit
		#find exit position
		var desirePos : Array[int] = mapInfo.indexToXZ(desExit)
		movement.aiMovement(Vector3(desirePos[0] + 0.5, position.y, desirePos[1] + 0.5)
		,nav,rayCast)

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
	healthPoint.updateHPFromPercentage(modifiedmaxHP, healthPoint.maxHP)
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
	
func euclideanDistance(x1:float,y1:float,x2:float,y2:float) -> float:
	return sqrt(pow((x1 - x2),2)+pow((y1 - y2),2))

# Set player transfer data such as buffs, healthpoint (current and max hp)
func setTransferPlayerData():
	var transferPlayerData : Dictionary = FloorManager.transferPlayerData
	if transferPlayerData.is_empty() == false:
		# Set current and max hp to transfer hp data 
		if transferPlayerData.has(DictionaryKey.currentHP) && transferPlayerData.has(DictionaryKey.maxHP):
			var currentHP = transferPlayerData[DictionaryKey.currentHP]
			var maxHP = transferPlayerData[DictionaryKey.maxHP]
			healthPoint.setTransferHP(currentHP,maxHP) 
		# Set active buff to transfer buff data
		if transferPlayerData.has(DictionaryKey.activeBuffs):
			buffManager.activeBuffs = transferPlayerData[DictionaryKey.activeBuffs]
			# Call signal to update buff data
			#activeBuffsUpdated.emit(buffManager.activeBuffs)

