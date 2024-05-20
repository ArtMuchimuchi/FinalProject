class_name DifficultyEvaluator

var enemiesList : Array[Enemy]
var player : Entity

var difficulty : float = 0

func setEnemiesList(enemies: Array[Enemy]):
	enemiesList = enemies
	
func setPlayer(inputPlayer: Entity):
	player = inputPlayer

func calDifficulty() -> float:
	var enemiesNumber : float = enemiesList.size()
	var averageAttack : float = 0
	var averageDefense : float = 0
	var averageHealthPoint : float = 0
	var averageDifficultyConstant : float = 0
	#calculate sum stat
	for i in range(enemiesNumber):
		averageAttack += getAttackStack(enemiesList[i])
		averageDefense += enemiesList[i].defense
		averageHealthPoint += enemiesList[i].healthPoint.maxHP
		averageDifficultyConstant += getDifficultyConstant(enemiesList[i])
	averageAttack = averageAttack / enemiesNumber
	averageDefense = averageDefense / enemiesNumber
	averageHealthPoint = averageHealthPoint / enemiesNumber
	averageDifficultyConstant = averageDifficultyConstant / enemiesNumber
	difficulty = (averageAttack/player.meleeAttackDamage) + (averageDefense/player.defense) + (averageHealthPoint/player.healthPoint.maxHP) + averageDifficultyConstant
	var numberDifficulty : int = enemiesNumber / 4
	difficulty = difficulty + numberDifficulty
	return difficulty
	
#enemy have 2 type, if it's melee type get from melee attack damage
#if no get from range attack damage
func getAttackStack(enemy: Enemy) -> int:
	var enemyType : int = enemy.enemyType
	if(enemyType == ConstantNumber.enemyMeleeType):
		return enemy.meleeAttackDamage
	else:
		return enemy.rangeAttackDamage
		
func getDifficultyConstant(enemy: Enemy) -> float:
	if(enemy.enemyName == "generalMonkey"):
		return 1
	elif(enemy.enemyName == "flyMonkey"):
		return 6
	elif(enemy.enemyName == "muscleMonkey"):
		return 1.5
	else:
		return 1.3
