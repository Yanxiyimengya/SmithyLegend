extends Control
class_name Shot;

signal shot_finished;

func _process(delta):
	$AnimationPlayer.play("new_animation");
	await $AnimationPlayer.animation_finished;
	shot_finished.emit();
