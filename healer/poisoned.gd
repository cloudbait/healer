extends Area2D
signal poisoned

	
	
func _on_body_entered(body: Node2D) -> void:
	poisoned.emit()
