extends Node2D;
@onready var game: Node2D = $"../..";

var max_value : int = 10;

@onready var slot_marker : Array[Node] = [$Slot1, $Slot2, $Slot3];
@onready var timer: Timer = $Timer;

var character_list : Array[Node] = [null, null, null];
const CHARACTER_LIST : Array[PackedScene] = [
	preload("res://Scenes/Game/Characters/character_pillager.tscn")
];

func summon_diff_character(count : int) : 
	var result_list : Array[String] = [];
	var slot : int = 0;
	for n : Node in character_list : 
		if (n == null) : 
			var item_id : String;
			var value : int = 0;
			var i : int = 0;
			while (i < count && value < max_value) : 
				item_id = game.global_list[randi() % game.global_list.size()];
				value += Global.item_dict[item_id]["value"];
				result_list.append(item_id);
				i+=1;
			
			if(randi()%12==0 && Global.day > 10):
				summon_character(1 ,result_list, slot);
			else :
				summon_character(0 ,result_list, slot);
			break;
		slot += 1;

@onready var gui_layer: CanvasLayer = $"../../GUILayer";
func summon_character(type : int, result : Array[String], slot : int) : 
	if (result.is_empty()) : return;
	if (character_list[slot] != null) : return;
	await get_tree().process_frame;
	var character_node : Node = CHARACTER_LIST[type % CHARACTER_LIST.size()].instantiate();
	add_child(character_node);
	character_list[slot] = character_node;
	character_node.result = result;
	character_node.global_position = Vector2([300, 1280 + 90].pick_random(),540);
	await character_node.walk_to(slot_marker[slot].global_position);
	character_node.can_be_provided = true;
	character_node.payed.connect(func() : 
		gui_layer.create_emerald_effect(character_node.global_position-Vector2(0, 200), Vector2(38, 39), character_node.carry_emeralds_count * Global.value_multiplier);
	);
	character_node.exited.connect(func() : 
		character_node.can_be_provided = false;
		character_list[slot] = null;
		await character_node.walk_to(Vector2([300, 1280 + 80].pick_random(),520));
		character_node.queue_free();
	);

func _on_timer_timeout() -> void : 
	if (%GameTimer.time_left < 10) : return;
	summon_diff_character(randi() % 3 + 1);
	timer.start(randf_range(4, 8));
	pass;
