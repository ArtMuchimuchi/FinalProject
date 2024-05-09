extends PanelContainer

var isSelected :bool = false
var isEmpty : bool = true
var buffIndex : int

@onready var buffIcon = %BuffIcon
@onready var buffNameLabel = %BuffNameLabel
@onready var buffLevelLabel = %BuffLevelLabel
@onready var buffDescriptionLabel = %BuffDescriptionLabel
@onready var emptyLabel = %EmptyLabel

signal buffCardSelected(buffCardIndex :int)

func _ready():
	setEmptyCard(true)

func setBuffCardData(buffData:BuffData,hasBuff: bool,index : int):
	if buffData:
		isEmpty = false
		buffIndex = index
		var currentLevel = buffData.currentLevel
		var maxLevel = buffData.maxLevel
		if currentLevel < maxLevel:
			# If it's default level or max level show level
			if hasBuff:
				buffLevelLabel.text = "LV. %s -> %s " %[buffData.currentLevel,buffData.currentLevel + 1]
				buffDescriptionLabel.text = buffData.getNextLevelBuffDescription()
			else:
				buffLevelLabel.text = "LV. %s" %[buffData.currentLevel]
				buffDescriptionLabel.text = buffData.getBuffPropertyValue(DictionaryKey.description)
		buffIcon.texture = buffData.buffTexture
		buffNameLabel.text = buffData.buffName
		

	setEmptyCard(isEmpty)
	
func _on_gui_input(event):
	if !isEmpty:
		if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed():
					var buffCardIndex = get_index()
					buffCardSelected.emit(buffCardIndex)
					var buffClickedSFX = preload("res://audio/sound_effect/user_interface/click_sfx.wav")
					SoundEffectManager.playSoundEffect(self,buffClickedSFX)

# Set buff card border to yellow when selected
func showSelectedBorder():
	var defaultStyleBox =  StyleBoxFlat.new()
	defaultStyleBox.bg_color = Color.from_string("#656565",Color.DIM_GRAY)
	defaultStyleBox.set_corner_radius_all(10)
	
	if isSelected:
		var newStyleBox = defaultStyleBox.duplicate()
		newStyleBox.border_color = Color.from_string("#e8d652",Color.YELLOW)
		newStyleBox.set_border_width_all(2)
		newStyleBox.set_corner_radius_all(10)
		self.add_theme_stylebox_override("panel",newStyleBox)
		
	else: 
		self.remove_theme_stylebox_override("panel")
		self.add_theme_stylebox_override("panel",defaultStyleBox)
		
func setEmptyCard(isBuffEmpty:bool):
	emptyLabel.visible = isBuffEmpty
	buffIcon.visible =  !isBuffEmpty
	buffNameLabel.visible =  !isBuffEmpty
	buffLevelLabel.visible = !isBuffEmpty
	buffDescriptionLabel.visible = !isBuffEmpty
