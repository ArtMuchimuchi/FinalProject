extends Entity

class_name Enemy

@onready var player = get_node("../Player")
@onready var animationSprite = get_node("AnimatedSprite3D")
@onready var animationPlayer = get_node("AnimationPlayer")
@onready var hitboxMeleeAttack = get_node("HitBoxMeleeAttack")

@onready var movement = MovementHandler.new(self)
@onready var animationManager = AnimationManager.new()
var HP : HealthPoint
@onready var meleeAttack = AttackHandler.new(self, hitboxMeleeAttack)

func _init():
	initEntity()
	meleeAttackDamage = ConstantNumber.enemyMeleeDamage
	healthPoint = ConstantNumber.enemyHealthPoint
	movementSpeed = ConstantNumber.enemySpeed
	dashSpeed = 0
	HP = HealthPoint.new(self)

func _physics_process(delta):
	#follow player
	movement.enemyMovement(delta, player)
	#play animation
	animation(delta)
	#about attacking
	attack()
	
func move():
	#calculate direction for chasing player
	movement.getDirection(player.global_position)
	#Update last direction of player facing
	movement.updateLastDirection()
	#Calculate player movement in 4 directional
	movement.movementHandler()

func animation(delta: float):
	#Play animation of player by the movement of player
	animationManager.movementAnimation(animationPlayer, velocity)
	#Flip direction of player 
	animationManager.flipAnimation(lastDirection, animationSprite, delta)
	
func attack():
	#update melee attack hitbox
	meleeAttack.updateHitbox()
	#create variable and check for player
	var isNearPlayer = hitboxMeleeAttack.get_overlapping_bodies()
	if(isNearPlayer.is_empty()):
		pass
	else:
		#if player found, attacking
		movement.setState(EntityState.attacking)
		if(movementState == EntityState.attacking):
			#deal damage
			meleeAttack.meleeAttack(meleeAttackDamage)
			#tried after attack for delay
			movement.setState(EntityState.tried)
	
#get damaged by entity
func damaged(direction: Vector3, damage: int, knockbackSpeed: int, knockbackDuration: float):
	#get knock back
	movement.knockBack(direction, knockbackSpeed, knockbackDuration)
	#deal damage to itself
	HP.updateHP(healthPoint - damage);
