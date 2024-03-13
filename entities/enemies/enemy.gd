extends Entity

class_name Enemy

@onready var player = get_node("../Player")
@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var hitboxMeleeAttack = get_node("HitBoxMeleeAttack")
@onready var hitboxRangeAttack = get_node("HitBoxRangeAttack")

@onready var animationManager = AnimationManager.new()
var HP : HealthPoint
@onready var meleeAttackManager = AttackHandler.new(self, hitboxMeleeAttack)
@onready var rangeAttackManager = AttackHandler.new(self, hitboxRangeAttack)
var isPlayerInRange

var isAttacking : bool

func _init():
	initEntity()
	meleeAttackDamage = ConstantNumber.enemyMeleeDamage
	rangeAttackDamage = 1
	healthPoint = HealthPoint.new(self, ConstantNumber.enemyHealthPoint)
	movementSpeed = ConstantNumber.enemySpeed
	dashSpeed = 0
	movement = MovementHandler.new(self)
	isAttacking = false

func _physics_process(delta):
	isPlayerInRange = hitboxMeleeAttack.get_overlapping_bodies()
	#if player in attack range
	if(isPlayerInRange):
		#update melee attack hitbox
		meleeAttackManager.updateHitbox()
		if(movementState != EntityState.attacking):
			#set to attacking state
			movement.setState(EntityState.attacking)
			#deal damage
			meleeAttackManager.meleeAttack(meleeAttackDamage)
	else:
		#set to moving State
		movement.setState(EntityState.moving)
	movement.enemyMovement(delta, player)
	#attack
	if(movementState == EntityState.attacking):
		meleeAttack(delta)
	#play animation
	animation(delta)

func animation(delta: float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer, movementState)
	#Flip direction of player 
	animationManager.flipAnimation(lastDirection, animationSprite, delta)
		
func meleeAttack(delta : float):
	if(triedCountdown >= ConstantNumber.enemyTriedDuration):
		triedCountdown = 0
		movementState = EntityState.idle
	else:
		triedCountdown += delta
			
func rangeAttack():
	#create variable and check for player
	var isNearPlayer = hitboxRangeAttack.get_overlapping_bodies()
	if(!isNearPlayer.is_empty()):
		#if player found, attacking
		movement.setState(EntityState.attacking)
		if(movementState == EntityState.attacking):
			#create projectile and shoot in player current position
			var projectile = preload("res://entities/projectile_attack.tscn").instantiate()
			projectile.direction = (player.global_position - position).normalized()
			projectile.damage = rangeAttackDamage
			self.add_child(projectile)
			#tried after attack for delay
			movement.setState(EntityState.tried)
	
#get damaged by entity
func damaged(direction: Vector3, damage: int, knockbackSpeed: int, knockbackDuration: float):
	#set to knockback state
	movement.setState(EntityState.knockBack)
	triedCountdown = 0
	#get knock back
	movement.knockBack(direction, knockbackSpeed, knockbackDuration)
	#deal damage to itself
	healthPoint.decreaseHP(damage)
