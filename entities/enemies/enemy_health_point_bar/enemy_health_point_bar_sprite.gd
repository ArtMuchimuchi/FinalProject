extends Sprite3D

@onready var enemy = $".."
@onready var healthPointBar = $SubViewport/HealthPointBar
@onready var enemySprite = $"../AnimatedSprite3D"

# Called when the node enters the scene tree for the first time.
func _ready():
	# If enmey sprite is floating reduce hp bar sprite height lower than ground enemy
	if enemySprite.position.y > 0.4:
		self.position = enemySprite.position + Vector3(0,0.4,0)
	else:
		self.position = enemySprite.position + Vector3(0,0.5,0)
	# Set default hp bar of enemy
	updateCurrentHPBar(enemy.healthPoint.currentHP,enemy.healthPoint.maxHP)
	enemy.connect("hpChanged",updateCurrentHPBar)


func updateCurrentHPBar(currentHP:int, maxHP:int):
	healthPointBar.updateCurrentHealth(currentHP, maxHP)
