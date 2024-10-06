extends Node;

signal change_scene_finished;

# 主场景

# Insert Shots
var in_shot : PackedScene = null;
var out_shot : PackedScene = null;

func change_scene_form_file(file_path : String) -> Error:
	var shot : Node;
	if (in_shot != null) :
		shot = in_shot.instantiate();
		self.add_child(shot);
		await shot.shot_finished;
		shot.queue_free();
	get_tree().change_scene_to_file(file_path);
	if (out_shot != null) :
		shot = out_shot.instantiate();
		self.add_child(shot);
		await shot.shot_finished;
		shot.queue_free();
	return Error.OK; # 跳转场景
