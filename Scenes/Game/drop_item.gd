extends CharacterBody2D;
class_name DropItem;

@onready var shadow: Sprite2D = $Node/Shadow;
@onready var sprite_2d: Sprite2D = $Sprite2D;
@onready var check_box: Control = $Sprite2D/CheckBox;

var item_type : String = "" : 
	set(value) : 
		if (Global.item_dict.has(value)) : 
			$Sprite2D.texture = Global.item_dict[value]["texture"];
		else : $Sprite2D.texture = null;
		item_type = value;

var node_visible : bool = true : 
	set(value) : 
		self.visible = value;
		$Node/Shadow.visible = value;
		
var dragging : bool = false : 
	set(value) : 
		dragging = value;
		if (value) : 
			self.set_collision_layer(0);
			self.set_collision_mask(0);
		else : 
			self.set_collision_layer(1);
			self.set_collision_mask(1);
var z_pos : float = 640;
var gravity : float = 3000;
var resistance : float = 5000;

func _ready() -> void:
	z_pos += randf_range(-70, 80);
	DragManager.drag_endding.connect(func(success : bool) : 
		if (success && dragging) : 
			self.queue_free();
		dragging = false;
		node_visible = true;
	);

func _process(delta: float) -> void:
	shadow.global_position = Vector2(self.global_position.x, z_pos + 20);
	var distance = abs(z_pos - global_position.y)
	shadow.scale = sprite_2d.scale * max(1.0 - distance / z_pos, 0.0) * 0.8; 
	shadow.modulate.a = min(max(1.0 - distance / z_pos, 0.0) * 0.5, 1.0);

func _physics_process(delta: float) -> void:
	if (!dragging) : 
		move_and_slide();
		if (global_position.y < z_pos) : 
			velocity.y += gravity * delta;
		else : 
			velocity.y = 0.0;
			global_position.y = z_pos;
			velocity.x = move_toward(velocity.x, 0.0, delta * resistance);

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouse) : 
		if (event is InputEventMouseMotion && dragging) : 
			global_position = event.global_position;
			velocity = Vector2.ZERO;
		if (event is InputEventMouseButton && check_box.get_global_rect().has_point(event.position)) : 
			if (event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT && !DragManager.dragging) : 
				DragManager.drag_start(["IngredientsDrag", item_type]);
				var spr : Sprite2D = Sprite2D.new();
				spr.texture = Global.item_dict[item_type]["texture"];
				spr.scale = Vector2.ONE * 4;
				DragManager.set_drag_preview(spr);
				dragging = true;
				node_visible = false;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is DropItem) : 
		if !(abs(z_pos - body.z_pos) <= 10):
			add_collision_exception_with(body);
func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body is DropItem) : 
		remove_collision_exception_with(body);
