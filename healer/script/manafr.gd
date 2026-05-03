extends ProgressBar

@export var player : Player

func _ready():
	player.manaChanged.connect(update)
	update()
	
func update():
	value=player.currentMana*100/player.maxMana
