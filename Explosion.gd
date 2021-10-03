extends CPUParticles2D
class_name Explosion

signal explosion_completed

func play() -> void:
	self.emitting = true
	$Debris.emitting = true
	$Explosion.play()

func _on_Explosion_finished() -> void:
	emit_signal("explosion_completed")
