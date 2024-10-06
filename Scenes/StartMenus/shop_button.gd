@tool
extends TextureButton;

signal signal_button_pressed(data : Variant);

@onready var label: Label = $Label;
@onready var mark: TextureRect = $TextureRect;
@export var texture : Texture2D = null;
@export var text : String = "";
var gama : float = 0.0 : 
	set(value) :
		self.material.set_shader_parameter("value", value);
		gama = value;
var item_upgrade_data : Variant = null;

func _process(delta: float) -> void :
	texture_normal = texture;
	label.text = text;
	mark.visible = disabled;
	self.self_modulate = Color.GRAY if(disabled)else Color.WHITE;

func _pressed() -> void:
	signal_button_pressed.emit(item_upgrade_data);

func _on_mouse_entered() -> void:
	get_tree().create_tween().tween_property(self, "gama", 0.2, 0.05);
func _on_mouse_exited() -> void:
	get_tree().create_tween().tween_property(self, "gama", 0.0, 0.05);
