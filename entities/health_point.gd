extends Node

class_name HealthPoint

var ownerNode : Entity
var currentHP : int
var maxHP : int

func _init(targetNode: Entity, setHP: int):
	ownerNode = targetNode
	currentHP = setHP
	maxHP = setHP
	
func  increaseHP(increaseAmount: int):
	# Make sure current hp won't exceed max hp when heal
	if increaseAmount + currentHP <= maxHP: 
		currentHP += increaseAmount
	else:
		currentHP = maxHP
	ownerNode.emit_signal("hpChanged",currentHP,maxHP)

func decreaseHP(decreaseAmount: int):
	if(decreaseAmount >= currentHP):
		ownerNode.emit_signal("hpChanged",0,maxHP)
		die()
	else:
		# Reduce damage recieved with defense value
		var defense = ownerNode.defense
		if defense < decreaseAmount:
			currentHP -= decreaseAmount - defense 
		# If defense value is greater than damage, reduce damage to 1 
		elif defense >= decreaseAmount:
			currentHP -= ConstantNumber.minimalDamage 
		ownerNode.emit_signal("hpChanged",currentHP,maxHP)

func die():
	if(ownerNode.name == "Player"):
		# Check if player have enough rebirth point to rebirth.     
		var traitManager : TraitManager = ownerNode.traitManager
		# If player have heal hp for percentage and gain invincible for short duration, reduced rebirth point per usage
		if traitManager.rebirthPoint > 0:
			var rebirthHP = maxHP * traitManager.rebirthTrait.getTraitPropertyValue(DictionaryKey.rebirthHP) 
			increaseHP(rebirthHP)
			ownerNode.setRebirthInvincible()
			traitManager.rebirthPoint =- 1
		# If player don't have enough rebirth point, trigger death signal
		else: 
			ownerNode.emit_signal("playerDeath")
	else:
		# Play enemy deatj sound effect before it queued free
		var enemyDeathSFX = preload("res://audio/sound_effect/enemies/death_sfx.wav") 
		SoundEffectManager.playSoundEffect(ownerNode,enemyDeathSFX)
		# Random enmey exp from 3-5 gain from killed 
		var rng = RandomNumberGenerator.new()
		var randomEnemyExp = rng.randi_range(3, 6)
		var randomEnemyCoin = rng.randi_range(1,3) * 10 
		RewardManager.increaseExp(randomEnemyExp)
		RewardManager.increaseCoin(randomEnemyCoin)
		# Create time delay so that death sound effect can play properly
		await ownerNode.get_tree().create_timer(0.1).timeout
		ownerNode.queue_free()

func updateHPFromPercentage(modifiedHP:int, baseHP: int):
	var currentHPRatio  = float(currentHP) / baseHP
	var newCurrentHP : int = modifiedHP * currentHPRatio
	maxHP = modifiedHP
	currentHP = newCurrentHP
	ownerNode.emit_signal("hpChanged",currentHP,maxHP)
	

