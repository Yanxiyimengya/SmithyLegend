extends Control;
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D;
@onready var animation_player: AnimationPlayer = $"../../../AnimationPlayer";

var VILLIGER_SOUND_YES : Array[AudioStream] = [
	preload("res://Audio/VilligerSound/Villager_yes1.ogg"),
	preload("res://Audio/VilligerSound/Villager_yes2.ogg"),
	preload("res://Audio/VilligerSound/Villager_yes3.ogg")
];

func _ready() -> void:
	DragManager.register_object(self);

func _dm_can_drag(as_position : Vector2, data : Variant) : 
	if (data && data is Array && data.size() > 0) : 
		if (data[0] == "IngredientsDrag" &&  Rect2(Vector2.ZERO, size).has_point(as_position)) : 
			if (Global.item_dict[data[1]]["can_gifted"]) : 
				return true;
	return false;

func _dm_drop_data(data : Variant) : 
	gpu_particles_2d.restart();
	animation_player.play(&"VillagerHappy");
	AudioManager.play_suond(VILLIGER_SOUND_YES[randi() % 3]);
