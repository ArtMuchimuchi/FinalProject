extends Entity

class_name Enemy

@onready var player = get_node("../../Player")
@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var hitboxAttack : Array[Node] = [get_node("HitBoxMeleeAttack"),get_node("HitBoxRangeAttack")]
@onready var audioStreamPlayer = get_node("AudioStreamPlayer")
@onready var nav : NavigationAgent3D = $NavigationAgent3D
@onready var rayCast : RayCastGroup = $RayCastGroup
@onready var chaser : Area3D = get_node("ChaseArea")
@onready var chaseArea : CylinderShape3D = get_node("ChaseArea/Hitbox").get_shape()
@onready var animationManager = AnimationManager.new()
var HP : HealthPoint
@onready var attackManager : Array[AttackHandler] = [
	AttackHandler.new(self, hitboxAttack[ConstantNumber.enemyMeleeType])
,AttackHandler.new(self, hitboxAttack[ConstantNumber.enemyRangeType])]
var isPlayerInAttackRange
var isPlayerInChaseRange

var isAttacking : bool
var enemyType : int

var triggerRange : int 
var chaseRange : int 
var isChase : bool = false

func _ready():
	add_to_group("enemies")
	animationPlayer.connect("animation_finished",shootProjectile)
	audioStreamPlayer.volume_db = -5

func _init():
	initEntity()
	meleeAttackDamage = ConstantNumber.enemyMeleeDamage
	rangeAttackDamage = 1
	healthPoint = HealthPoint.new(self, ConstantNumber.enemyHealthPoint)
	movementSpeed = ConstantNumber.enemySpeed
	dashSpeed = 0
	movement = MovementHandler.new(self)
	isAttacking = false
	enemyType = ConstantNumber.enemyMeleeType

func _physics_process(delta):
	isPlayerInAttackRange = hitboxAttack[enemyType].get_overlapping_bodies()
	#update hitbox attack
	attackManager[enemyType].updateHitbox()
	#if player in attack range
	if(isPlayerInAttackRange):
		if(movementState != EntityState.attacking && movementState != EntityState.knockBack):
			#set to attacking state
			movement.setState(EntityState.attacking)
			#deal damage
			if(enemyType == ConstantNumber.enemyMeleeType):
				attackManager[enemyType].meleeAttack(meleeAttackDamage)
				animationPlayer.play("MeleeAttack")
			elif(enemyType == ConstantNumber.enemyRangeType):
				rangeAttack()
	else:
		#if player in chase range then chase
		isPlayerInChaseRange = chaser.get_overlapping_bodies()
		if(isPlayerInChaseRange):
			isChase = true
			chaseArea.radius = chaseRange
			#set to moving State
			movement.setState(EntityState.moving)
		else:
			isChase = false
			chaseArea.radius = triggerRange
			movement.setState(EntityState.idle)
	movement.enemyMovement(delta, player, nav, rayCast)
	#attack
	if(movementState == EntityState.attacking):
		attackCooldown(delta)
	#play animation
	animation(delta)

func animation(delta: float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer, movementState)
	#Flip direction of player 
	animationManager.flipAnimation(lastDirection, animationSprite, delta)
	
		
func attackCooldown(delta : float):
	if(triedCountdown >= triedDuration):
		triedCountdown = 0
		movementState = EntityState.idle
	else:
		triedCountdown += delta
			
func rangeAttack():
	#create projectile and shoot in player current position
	animationPlayer.play("RangeAttack")
	

func shootProjectile(animName : String):
		if animName  == "RangeAttack":
			var projectile = preload("res://entities/projectile_attack.tscn").instantiate()
			projectile.position = position
			projectile.direction = (player.global_position - position).normalized()
			projectile.damage = rangeAttackDamage
			var parent = self.get_parent()
			parent.add_child(projectile)

#get damaged by entity
func damaged(direction: Vector3, damage: int, knockbackSpeed: int, knockbackDuration: float):
	#set to knockback state
	movement.setState(EntityState.knockBack)
	triedCountdown = 0
	#get knock back
	movement.knockBack(direction, knockbackSpeed, knockbackDuration)
	#deal damage to itself
	healthPoint.decreaseHP(damage)

