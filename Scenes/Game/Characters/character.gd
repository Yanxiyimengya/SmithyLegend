extends Control;
class_name Character;

signal exited();
signal payed();

@export var check_box: Control;
@export var gpu_particles_2d: GPUParticles2D
@export var animation_player: AnimationPlayer;
@export var ui: Control;

var SOUND_YES : Array[AudioStream] = [
	preload("res://Audio/VilligerSound/Villager_yes1.ogg"),
	preload("res://Audio/VilligerSound/Villager_yes2.ogg"),
	preload("res://Audio/VilligerSound/Villager_yes3.ogg")
];
var SOUND_NO : Array[AudioStream] = [
	preload("res://Audio/VilligerSound/Villager_no1.ogg"),
	preload("res://Audio/VilligerSound/Villager_no2.ogg"),
	preload("res://Audio/VilligerSound/Villager_no3.ogg")
];

var can_be_provided : bool = false : 
	set(value) : 
		can_be_provided = value;
		ui.visible = true;
		var tween : Tween = create_tween(); 
		if (value) : 
			ui.modulate.a = 0.0;
			tween.tween_property(ui, "modulate:a", 1.0, 0.1);
		else : 
			ui.modulate.a = 1.0;
			tween.tween_property(ui, "modulate:a", 0.0, 0.1);
		await tween.finished;
		ui.visible = value;
var mood : float = 0.0 : 
	set(value) : 
		mood = value;
		ui.mood = value;
		if (value >= 100.0) : 
			can_be_provided = false;
			gpu_particles_2d.restart();
			exited.emit();
			AudioManager.play_global_audio(SOUND_NO[randi()%SOUND_NO.size()]);
var mood_speed : float = 1.0;
var result : Array[String] = [] : 
	set(value) : 
		result = value;
		carry_emeralds_count = 0;
		for item : String in result : 
			carry_emeralds_count += Global.item_dict[item]["value"];
		ui.set_result(value);
#var texture : Texture2D = null : 
	#set(value) : 
		#$Sprite2D.texture = value;
		#$Sprite2D.scale.x = 290 / $Sprite2D.get_rect().size.y;
		#$Sprite2D.scale.y = $Sprite2D.scale.x;
		#$Sprite2D.offset.y = -$Sprite2D.scale.y/2;
		#texture = value;
var carry_emeralds_count : int = 0;

func _ready() -> void : 
	DragManager.register_object(self);

func _process(delta: float) -> void : 
	if (can_be_provided) : 
		mood += delta * mood_speed;

func _dm_can_drag(as_position : Vector2, data : Variant) : 
	if (can_be_provided) :
		if (data && data is Array && data.size() > 0 && data[0] == "IngredientsDrag") : 
			if (check_box.get_global_rect().has_point(check_box.get_global_mouse_position())) : 
				if (data[1] in result) : 
					return true;
	return false;

func _dm_drop_data(data : Variant) : 
	ui.complate_item(data[1]);
	result.erase(data[1]);
	if (SOUND_YES.size() > 0) : 
		AudioManager.play_global_audio(SOUND_YES[randi() % SOUND_YES.size()]);
	if (ui.result_count <= 0) : 
		exited.emit();
		payed.emit();

var moveing_tween : Tween;
func walk_to(pos : Vector2) : 
	animation_player.play(&"Walk");
	await get_tree().process_frame;
	moveing_tween = create_tween().set_parallel();
	moveing_tween.tween_property(self, "global_position:y", pos.y-30, abs(global_position.y - pos.y) / 40);
	moveing_tween.tween_property(self, "scale", -Vector2(0.1, 0.1), 1).as_relative();
	moveing_tween.chain();
	moveing_tween.tween_property(self, "global_position:x", pos.x, abs(global_position.x - pos.x) / 80);
	moveing_tween.chain();
	moveing_tween.tween_property(self, "global_position:y", pos.y+30,  abs(global_position.y - pos.y) / 40);
	moveing_tween.tween_property(self, "scale", Vector2(0.1, 0.1), 1).as_relative();
	moveing_tween.chain();
	await moveing_tween.finished;
	animation_player.stop();
