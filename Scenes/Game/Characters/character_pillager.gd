extends Character;

var escaping : bool = false;

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
	if (SOUND_YES.size() > 0) : 
		AudioManager.play_global_audio(SOUND_YES[randi() % SOUND_YES.size()]);
	if (ui.result_count <= 0) : 
		escaping = true;
		exited.emit();
		payed.emit();
