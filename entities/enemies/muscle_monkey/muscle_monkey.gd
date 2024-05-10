extends Enemy

class_name MuscleMonkey

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
	triggerRange = ConstantNumber.enemyMeleeTriggerChase
	chaseRange = ConstantNumber.enemyMeleeStopChase
