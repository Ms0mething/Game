extends StateBase

@export var collisionShape3D : CollisionShape3D
@export var materialEffectAnimationPlayer : AnimationPlayer

func enter():
	super.enter()
	
	character.velocity = Vector3.ZERO
	collisionShape3D.disabled = true
	
	await get_tree().create_timer(1).timeout
	materialEffectAnimationPlayer.play("Dead")
	
	await get_tree().create_timer(3).timeout
	
	var dropItem = preload("res://Game/Scene/collectable_healing_orb.tscn")
	var dropItemInstance = dropItem.instantiate()
	get_tree().get_root().get_node("Node3D").add_child(dropItemInstance)
	dropItemInstance.global_position = character.global_position
	
	character.queue_free()
