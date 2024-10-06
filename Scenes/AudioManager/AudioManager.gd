extends Node;

# 音频管理器

var audio_tasks_map :Dictionary = {};
var audio_tasks_pool : Array[AudioTask] = [];

func play_suond(stream : AudioStream) -> AudioTask :
	var audio_task : AudioTask = null;
	if (audio_tasks_pool.is_empty()) :
		audio_task = AudioTask.new();
		audio_task.finished.connect(func():
			audio_tasks_map.erase(audio_task);
			audio_tasks_pool.push_back(audio_task););
		self.add_child(audio_task.player_node);
	else :
		audio_task = audio_tasks_pool.pop_back();
	audio_task.stream = stream;
	audio_task.play();
	audio_tasks_map[audio_task] = audio_task;
	return audio_task;

func stop_sound(task : AudioTask) -> void :
	if (audio_tasks_map.has(task)) :
		task.stop();
		audio_tasks_map.erase(task);
		audio_tasks_pool.push_back(task);

func stop_all_sound() : 
	for task : AudioTask in audio_tasks_map : 
		stop_sound(task);
