extends Control;
class_name TextTyper;
# 打字机组件

signal call_command(cmd : String, args : Array[String]);
signal finshed();

@export var text : String = "";
@export var typer_speed : float = 0.3;				# 打字机速度
@export var auto_start : bool = false;			

@export_group("text_attribute")
@export var char_color : Color = Color.WHITE;
@export var char_scale : Vector2 = Vector2.ONE;
@export var char_space : Vector2 = Vector2.ONE;
@export var char_font_assst : Font = null;
@export var char_font_size : int = 16;
@export var char_voice : AudioStream = null;
@export_group("text_attribute/outline")
@export var char_outline_color : Color = Color.WHITE;
@export var char_outline_size : int = 0;
@export_group("text_attribute/shadow")
@export var char_shadow_color : Color = Color(0, 0, 0, 1);
@export var char_shadow_offset : Vector2i = Vector2i.ZERO;
@export_group("", "")

enum STATE {
	PAUSED,		# 停止
	WAIT,		# 等待
	PROCESS,	# 运行
	INSTANT		# 瞬间显示
}; # 打字机状态

var char_node_list : Array[Control] = [];		# 字符节点列表
var char_node_pool : Array[Control] = [];		# 字符节点池
var typer_process : int = 0;					# 打字机文本进度
var typer_state : STATE = STATE.PROCESS;
var typer_timer : float = 0;
var wait_timer : float = 0;
var typer_cursor_position : Vector2 = Vector2.ZERO;
var max_size : Vector2 = Vector2.ZERO;
var target_object : Object = null;

@onready var audio_player := $VoicePlayer;

func _ready() -> void : 
	if (auto_start) : 
		start(text);

func start(_text : String) : 
	for n : Node in char_node_list : 
		var char_node : CanvasItem = char_node_list.pop_back();
		char_node.visible = false;
		char_node_pool.append(char_node);
	
	typer_process = 0; 
	max_size = Vector2.ZERO;
	typer_cursor_position = Vector2.ZERO;
	typer_state = STATE.PROCESS;
	self.text = _text;

func new_char(charactor : String) -> Label:
	var char_node : Label = null;
	if (char_node_pool.is_empty()) :
		char_node = Label.new();				# 构造字符节点
		self.add_child(char_node);				# 添加入树
	else :
		char_node = char_node_pool.pop_back();	# 出栈
		char_node.visible = true;
	char_node_list.push_back(char_node);	# 压入字符列表
	char_node.text = charactor[0];
	char_node.scale = char_scale;
	char_node.self_modulate = char_color;
	if (char_font_assst) :
		char_node.add_theme_font_override("font", char_font_assst);
	char_node.add_theme_font_size_override("font_size", char_font_size);
	char_node.add_theme_color_override("font_outline_color", char_outline_color);
	char_node.add_theme_constant_override("outline_size", char_outline_size);
	char_node.add_theme_color_override("font_shadow_color", char_shadow_color);
	char_node.add_theme_constant_override("shadow_offset_x", char_shadow_offset.x);
	char_node.add_theme_constant_override("shadow_offset_y", char_shadow_offset.y);
	if (char_voice) :
		audio_player.stream = char_voice;
		audio_player.play();
		pass;
	char_node.position = typer_cursor_position;
	typer_cursor_position.x += char_node.get_rect().size.x + char_space.x;
	if (max_size.x < typer_cursor_position.x) :
		max_size.x = typer_cursor_position.x;
	if (max_size.y < typer_cursor_position.y + char_node.get_rect().size.y) :
		max_size.y = typer_cursor_position.y + char_node.get_rect().size.y;
	return char_node; # 在末尾创建一个新的字符节点实例
func delete_char() -> void :
	if (char_node_list.size() > 0) :
		var end_node = char_node_list.pop_back();	# 获取末尾节点
		end_node.visible = false;
		char_node_pool.push_back(end_node);
		typer_process -= 1;
	pass; # 在末尾移除一个字符节点实例
func new_line() -> void :
	typer_cursor_position.x = 0;
	typer_cursor_position.y = max_size.y + char_space.y;
	if (max_size.y < typer_cursor_position.y) :
		max_size.y = typer_cursor_position.y;

func wait(timer: float) -> void:
	wait_timer = timer;
	typer_state = self.STATE.WAIT; 
	pass;

func llex() -> Array[String] : 
	var this_char : String = text[typer_process]; # 获取当前打字的字符
	if( this_char != "{") : return [];
	var cmds : Array[String] = [];
	var cmd_text : String = "";
	while (true) :
		typer_process += 1;
		if (typer_process >= text.length()) :
			break;
		this_char = text[typer_process]; # 更新字符
		if (this_char == " ") :
			if (cmd_text != "") :
				cmds.push_back(cmd_text);
			cmd_text = "";
			continue;
		elif (this_char == "}") :
			typer_process += 1;
			cmds.push_back(cmd_text);
			break;
		cmd_text += this_char;
	return cmds; # 对接下来的一段文本进行词法拆分

func update() : 
	var current_char : String = text[typer_process];
	if (current_char == "{") :
		var cmd_array : Array[String] = llex();
		var cmd_text : String = cmd_array[0];
		var args : Array[String] = cmd_array.slice(1);
		call_command.emit(cmd_text, args);
		return;
	elif (current_char == "&" || current_char == "\r") :
		typer_process += 1;
		new_line();
		return;
	new_char(text[typer_process]);
	typer_process += 1;
	pass;

func _process(_delta : float) :
	if (typer_process >= text.length()) :
		if (typer_state != TextTyper.STATE.PAUSED) : 
			finshed.emit();
			typer_state = TextTyper.STATE.PAUSED;
		return;
	while (true) :
		match (typer_state) :
			TextTyper.STATE.PAUSED :
				break;
			TextTyper.STATE.WAIT :
				if (wait_timer > 0) :
					wait_timer -= _delta;
					break;
				else :
					wait_timer = 0;
					typer_state = TextTyper.STATE.PROCESS;
			TextTyper.STATE.PROCESS :
				if (typer_timer <= 0) :
					typer_timer = typer_speed;
					self.update();
				else :
					typer_timer -= _delta;
					break;
			TextTyper.STATE.INSTANT :
				update();
				pass;


func _on_call_command(cmd, args):
	match (cmd) :
		"instant" :
			if (args.size() > 0) :
				if (args[0] == "true") :	typer_state = STATE.INSTANT;
				else :	typer_state = STATE.PROCESS;
			typer_state = STATE.PROCESS if (typer_state==STATE.INSTANT) else STATE.INSTANT;
		"wait" : 
			wait(float(args[0]));
		"speed" : 
			typer_speed = float(args[0]);
		"scale" :
			char_scale.x = float(args[0]);
			char_scale.y = float(args[1]);
		"space" :
			char_space.x = float(args[0]);
			char_space.y = float(args[1]);
		"outline_size" :
			char_outline_size = int(args[0]);
		"shadow_offset" :
			char_shadow_offset = Vector2(int(args[0]), int(args[1]));
		"color" :
			char_color = change_color(char_color, args);
		"outline_color" :
			char_outline_color = change_color(char_outline_color, args);
		"shadow_color" :
			char_outline_color = change_color(char_shadow_color, args);
		"font" :
			char_font_assst = load(args[0]);
		"font_size" :
			char_font_size = int(args[0]);
		"call" :
			if (target_object.get(args[0]) is Callable) :
				target_object.get(args[0]).callv(args.slice(1));
		_:
			pass;

func change_color(color : Color, args_array : Array[String]) -> Color :
	if (args_array[0][0] == "#") :
			color = Color.html(args_array[0]);
			return color;
	match args_array[0] :
		"r" :
			color.r = float(args_array[1]);
		"g" :
			color.g = float(args_array[1]);
		"b" :
			color.b = float(args_array[1]);
		"a" :
			color.a = float(args_array[1]);
		"rgb" :
			color = Color(float(args_array[1]), float(args_array[2]), float(args_array[3]));
		"rgba" :
			color = Color(float(args_array[1]), float(args_array[2]), float(args_array[3]), float(args_array[4]));
		"hsv" :
			color = Color.from_hsv(float(args_array[1]), float(args_array[2]), float(args_array[3]));
	return color;
