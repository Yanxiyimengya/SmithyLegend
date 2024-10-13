extends Node;

# 音频管理器

var audio_tasks_map :Dictionary = {};
var audio_tasks_pool : Array[AudioTask] = [];
@onready var global_audio_player: AudioStreamPlayer = $GlobalAudioPlayer;

func play_suond(stream : AudioStream) -> AudioTask :
	var audio_task : AudioTask = null;
	if (audio_tasks_pool.is_empty()) :
		audio_task = AudioTask.new();
		audio_task.finished.connect(func():
			audio_tasks_map.erase(audio_task);
			audio_tasks_pool.push_back(audio_task);
		);
		self.add_child(audio_task.player_node);
	else :
		audio_task = audio_tasks_pool.pop_back();
	audio_tasks_map[audio_task] = audio_task;
	audio_task.stream = stream;
	audio_task.play();
	return audio_task;

func play_global_audio(stream: AudioStream, from_offset: float = 0, volume_db: float = 0, pitch_scale: float = 1.0, playback_type : int = 0, bus: StringName = &"Sound") : 
	if (!global_audio_player.playing) : 
		global_audio_player.play();
	var playback : AudioStreamPlayback = global_audio_player.get_stream_playback();
	playback.play_stream(stream, from_offset, volume_db, pitch_scale, playback_type, bus);

func stop_sound(task : AudioTask) -> void :
	if (audio_tasks_map.has(task)) :
		task.stop();
		audio_tasks_map.erase(task);
		audio_tasks_pool.push_back(task);

func stop_all_sound() : 
	for task : AudioTask in audio_tasks_map : 
		stop_sound(task);
