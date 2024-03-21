extends Enemy

class_name ZombieMonkey

func _init():
	initEntity()
	meleeAttackDamage = ConstantNumber.enemyMeleeDamage
	healthPoint = HealthPoint.new(self, ConstantNumber.enemyHealthPoint)
	movementSpeed = ConstantNumber.enemySpeed - 3
	dashSpeed = 0
	movement = MovementHandler.new(self)
	isAttacking = false
	enemyType = ConstantNumber.enemyMeleeType
