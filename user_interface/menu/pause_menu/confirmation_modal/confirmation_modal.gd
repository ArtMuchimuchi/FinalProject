extends Control

@export_multiline var modalTitle : String = "Title" 
@export var acceptButtonName : String = "Yes"
@export var declineButtonName : String = "No"
@onready var titleLabel = %TitleLabel
@onready var acceptButton = %AcceptButton
@onready var declineButton = %DeclineButton

signal modalClosed
signal modalAccepted

# Called when the node enters the scene tree for the first time.
func _ready():
	titleLabel.text = modalTitle
	acceptButton.text = acceptButtonName
	declineButton.text = declineButtonName

func onPressedAcceptButton():
	modalAccepted.emit()

func onPressedDeclineButton():
	print("modalClosed Decline button %s" %titleLabel)
	modalClosed.emit()

func onPressedClosedButton():
	print("modalClosed Closed button %s" %titleLabel)
	modalClosed.emit()

