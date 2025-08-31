extends TextureRect

var defenseValue: String
var attackValue: String

@onready var defense: Label = $Defense
@onready var attack: Label = $Attack

func _ready() -> void:
	defense.visible = false
	attack.visible = false
	#mouse_entered.connect("mouse_entered")
	self.connect("mouse_entered", Callable(self, "mouse_entered"))
	self.connect("mouse_exited", Callable(self, "mouse_exited"))
	
func mouse_entered():
	defense.text = defenseValue
	attack.text = attackValue
	
	defense.visible = true
	attack.visible = true

func mouse_exited():
	defense.visible = false
	attack.visible = false
