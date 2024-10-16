extends CanvasLayer;

signal drag_starting();
signal drag_endding(success : bool);

@onready var drag_items: Node2D = $DragItems;

var drag_preview : CanvasItem = null;
var drag_data : Variant = null;
var dragging : bool = false;
var pressed : bool = false;
var drag_index : int = 0;

var register_list : Array[CanvasItem] = [];
const GET_DRAG_DATA_CALLBACK : String = "_dm_drag_data";
const CAN_DRAG_CALLBACK : String = "_dm_can_drag";
const DROP_DATA : String = "_dm_drop_data";

func _ready() -> void:
	layer = 10;

func set_drag_preview(preview : CanvasItem) : 
	if (drag_preview != null) : 
		drag_preview.queue_free();
	drag_preview = preview;
	drag_preview.visible = false;
	preview.scale = Vector2(64, 64) / preview.texture.get_size();
	if (!preview.is_inside_tree()) : 
		self.add_child(preview);

func register_object(obj : CanvasItem) : 
	if (obj is Control || obj is Sprite2D) : 
		register_list.append(obj);

func drag_start(_data : Variant) : 
	dragging = true;
	drag_data = _data;
	drag_starting.emit();

func drag_end() : 
	var success = false;
	for obj : CanvasItem in register_list : 
		if (obj != null && obj.can_process()) : 
			if (obj.has_method(CAN_DRAG_CALLBACK) && obj.callv(CAN_DRAG_CALLBACK, [obj.get_local_mouse_position(), drag_data])) : 
				#ar mouse_global_position : Vector2 = get_viewport().get_mouse_position(); 
				if (obj.has_method(DROP_DATA)) : 
					obj.callv(DROP_DATA, [drag_data]);
					success = true;
					break;
	drag_endding.emit(success);

func _input(event: InputEvent) -> void:
	if (event is InputEventFromWindow) : 
		if (!dragging) : 
			if (event is InputEventScreenDrag) : 
				var delete_list : Array[int] = [];
				var count : int = -1;
				for obj : CanvasItem in register_list : 
					count += 1;
					if (obj != null) : 
						if (obj.can_process()) : #####
							if (obj.get_global_rect().has_point(obj.get_global_mouse_position())) : 
								if (obj.has_method(GET_DRAG_DATA_CALLBACK)) : 
									drag_start(obj.callv(GET_DRAG_DATA_CALLBACK, [obj.get_local_mouse_position()]));
									drag_index = event.index;
									break;
					else : 
						delete_list.push_front(count);
				if (delete_list.size() > 0) : 
					for i : int in delete_list : 
						register_list.remove_at(i);
		if (dragging) : 
			if (drag_preview != null && (event is InputEventScreenDrag || event is InputEventScreenTouch)) : 
				drag_preview.global_position = event.position;
				drag_preview.visible = true;
			var is_released : bool = false;
			if (event is InputEventScreenTouch) : 
				if (event.is_released()) : 
					dragging = false;
					is_released = true;
					if (drag_preview != null) : 
						drag_preview.queue_free();
			if (is_released) : 
				drag_end();

const DROP_ITEM = preload("res://Scenes/Game/drop_item.tscn");
func create_drop_item(item_type : String) -> CharacterBody2D : 
	if ( Global.item_dict.has(item_type) ) : 
		var drop_item : Node = DROP_ITEM.instantiate();
		drop_item.item_type = item_type;
		drop_item.global_position = -Vector2(9999, 9999);
		drag_items.add_child(drop_item);
		return drop_item;
	return null;
func free_drag_item() : 
	dragging = false;
	if (drag_preview != null) : 
		drag_preview.queue_free();
	for node : Node in drag_items.get_children() : 
		node.queue_free();
