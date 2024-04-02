extends Enemy

class_name GeneralMonkey

func _init():
	initEntity()
	meleeAttackDamage = ConstantNumber.enemyMeleeDamage
	healthPoint = HealthPoint.new(self, ConstantNumber.enemyHealthPoint)
	movementSpeed = ConstantNumber.enemySpeed
	dashSpeed = 0
	movement = MovementHandler.new(self)
	isAttacking = false
	enemyType = ConstantNumber.enemyMeleeType
	defense = ConstantNumber.enemyDefense
