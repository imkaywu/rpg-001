extends Control

var hearts = 3 : set=_set_hearts
var max_hearts = 3 : set=_set_max_hearts

@onready var heart_ui_empty = $HeartUIEmpty
@onready var heart_ui_full = $HeartUIFull

const HeartWidth = 15


func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", Callable(self, "_set_hearts"))
	PlayerStats.connect("max_health_changed", Callable(self, "_set_max_hearts"))


func _set_hearts(val):
	hearts = clamp(val, 0, max_hearts)
	if heart_ui_full != null:
		heart_ui_full.size.x = hearts * HeartWidth


func _set_max_hearts(val):
	max_hearts = max(val, 1)
	self.hearts = min(hearts, max_hearts)
	if heart_ui_empty != null:
		heart_ui_empty.size.x = max_hearts * HeartWidth
