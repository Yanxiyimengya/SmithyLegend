extends Object;
class_name AudioTask;

signal finished;

var looping : bool = false;					# 循环状态标志
var player_node : AudioStreamPlayer = null;
var stream : AudioStream = null :
	set(audio_stream) :
		stream = audio_stream;
		player_node.stream = audio_stream;
var pitch : float = 1.0 : 
	set(value) :
		pitch = value;
		player_node.pitch_scale = value;
var volume : float = 1.0 : 
	set(value) :
		volume = value;
		player_node.volume_db = value;
var bus : StringName = &"Master" :
	set(value) :
		bus = value;
		player_node.bus = value;
var playing : bool = false :
	get :
		return player_node.playing;

func _init() :
	player_node = AudioStreamPlayer.new();
	player_node.finished.connect(func() :
		if (looping) :
			player_node.play();
			return; # 循环播放音频
		self.stop();
	);
func _notification(what) -> void:
	if (what == Object.NOTIFICATION_PREDELETE) :
		player_node.free();
		pass; # 析构函数 : 释放Player节点

func play(from_pos : float = 0.0) -> void:
	if (player_node.playing) :
		return;
	player_node.play(from_pos);
	volume = 1.0;
	pitch = 1.0;
	looping = false;
	bus = &"Master";
	player_node.process_mode = Node.PROCESS_MODE_ALWAYS;

func stop() -> void :
	if (player_node.playing) :
		player_node.stop();
	player_node.process_mode = Node.PROCESS_MODE_DISABLED;
	finished.emit();

func pause() -> void :
	player_node.process_mode = Node.PROCESS_MODE_DISABLED;
	player_node.stream_paused = true;
func resume() -> void :
	player_node.process_mode = Node.PROCESS_MODE_ALWAYS;
	player_node.stream_paused = false;
