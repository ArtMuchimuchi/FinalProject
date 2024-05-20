extends Node

const flipConstant : int = 15
const directionConstant : int = 1
const noMovementConstant : int = 0 

const playerSpeed : int = 7
const playerDashSpeed : int = 17
const playerDashDuration : float = 0.08
const playerHealthPoint : int = 100
const playerMeleeDamage : int = 30
const playerMeleeCooldown : float = 0.2
const playerRangeDamage : int = 10
const playerDefense : int = 10
const rebirthInvincibleDuration : float = 2.0
const healingPerLevelUp : float = 0.3
const defaultPlayerLevel : int = 0
const defaultPlayerExp : int = 0 

const enemyMeleeType : int = 0
const enemyRangeType : int = 1

const enemyHealthPoint : int = 10
const enemySpeed : int = 4
const enemyDashSpeed : int = 14
const enemyDashDuration : float = 0.3
const enemyMeleeDamage : int = 1
const enemyTriedDuration : float = 0.5
const enemyMeleeKnockbackSpeed : int = 14
const enemyMeleeKnockbackDuration : float = 0.3
const enemyRangeKnockbackSpeed : int = 7
const enemyRangeKnockbackDuration : float = 0.1
const enemyDefense : int = 1

const enemyMeleeTriggerChase : int = 3
const enemyMeleeStopChase : int = 7
const enemyRangeTriggerChase : int = 4
const enemyRangeStopChase : int = 9

const flyMonkeyAttackCooldown : int = 2

const defaultSlotDetailIndex : int = 0
const defaultTraitLevel : int = 0
const nextTraitLevel : int = 1

const defaultPercentage : float = 1.0
const defaultBuffLevel : int = 1
const emptyArray : int = 0
const emptyBuffIndex : int = -1

const minimalDamage : int = 1

const easyMode : int = 0
const normalMode : int = 1
const hardMode : int = 2

const minEnemiesNumber : Array[int] = [4,4,5]
const maxEnemiesNumber : Array[int] = [5,6,7]

const easyMinimumMultiply : float = 0.3
const easyMaximumMultiply : float = 0.5
const normalMinimumMultiply : float = 0.5
const normalMaximumMultiply : float = 0.7
const hardMinimumMultiply : float = 0.6
const hardMaximumMultiply : float = 0.8

const minDifficulty : Array[float] = [0, 4.1, 5.1]
const maxDifficulty : Array[float] = [4, 5.0, 5.5]
