extends Enemy

class_name FlyMonkey

func _init():
	initEntity()
	rangeAttackDamage = 2
	healthPoint = HealthPoint.new(self, ConstantNumber.enemyHealthPoint)
	movementSpeed = ConstantNumber.enemySpeed
	dashSpeed = 0
	movement = MovementHandler.new(self)
	isAttacking = false
	enemyType = ConstantNumber.enemyRangeType
	triedDuration = ConstantNumber.flyMonkeyAttackCooldown
