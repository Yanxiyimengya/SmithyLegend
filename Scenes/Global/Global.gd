extends Node;
@onready var resource_preloader: ResourcePreloader = $ResourcePreloader;

var item_dict : Dictionary = {};
var recipe_dict : Dictionary = {};

var emerald_count : int = 0;
var day : int = 0;
var game_time : int = 0;
var bgm_volume : int = 0;
var sound_volume : int = 0;
var log_filling_time : float = 1.0;
var upgrade_list : Dictionary = {};
var value_multiplier : float = 1.0;
var game_progress : float = 0.0;

func _exit_tree() -> void:
	save_game();

func _ready() -> void:
	GameInitializer.init();
	load_game();
	for item : String in upgrade_list : 
		set_upgrade(item, upgrade_list[item]);
	
	## 基础配方
	register_recipe("plank", ["log"], 4, false);
	# 原木 -> 木板
	register_recipe("stick", ["plank", "", "", "plank", "", ""], 4, true);
	# 木板 -> 木棍


#region 工具装备合成配方


func set_upgrade(item:  String, level : int = 0) : 
	if (level <= 0) : return;
	if (upgrade_list.has(item) && level < upgrade_list[item]) : return;
	upgrade_list[item] = level;
	set_update_effect(item, level);

func set_update_effect(item:  String, level : int) : 
	game_progress += 4 * level;
	match (item) : 
		"iron_upgrade" : 
			if (level > 0) : GameInitializer.append_iron_props_recipes();
			if (level > 1) : GameInitializer.append_iron_recipes();
		"gold_upgrade" : 
			if (level > 0) : GameInitializer.append_gold_props_recipes();
			if (level > 1) : GameInitializer.append_gold_recipes();
		"diamond_upgrade" : 
			if (level > 0) : GameInitializer.append_diamond_props_recipes();
			if (level > 1) : GameInitializer.append_diamond_recipes();
		"log_quick_filling" : 
			log_filling_time *= 0.5;
		"value_upgrade" : 
			if (level == 0) :
				value_multiplier = 1.25;
			if (level == 1) :
				value_multiplier = 1.5;
			if (level == 2) :
				value_multiplier = 2.0;
			if (level == 3) :
				value_multiplier = 3.0;
			

#endregion
const save_path : String = "user://save.json";
func load_game() : 
	if (!FileAccess.file_exists(save_path)) : 
		return;
	var file : FileAccess = FileAccess.open(save_path, FileAccess.READ);
	if (file) : 
		var file_str : String = file.get_as_text();
		file.close();
		var json : Variant = JSON.parse_string(file_str);
		if (json == null) : 
			return;
		self.upgrade_list = json["upgrade_list"];
		self.day = json["day"];
		self.emerald_count = json["emerald_count"];
		if (json.has("game_time")) : 
			Global.game_time = json["game_time"];
		if (json.has("bgm_volume")) : 
			Global.bgm_volume = json["bgm_volume"];
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BGM"),bgm_volume);
		if (json.has("sound_volume")) : 
			Global.sound_volume = json["sound_volume"];
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"),sound_volume);

func save_game() : 
	var file : FileAccess = FileAccess.open(save_path, FileAccess.WRITE);
	if (file) : 
		var dict : Dictionary = {};
		dict["upgrade_list"] = upgrade_list;
		dict["emerald_count"] = emerald_count;
		dict["game_time"] = game_time;
		dict["bgm_volume"] = bgm_volume;
		dict["sound_volume"] = sound_volume;
		dict["day"] = day;
		file.store_string(JSON.stringify(dict));
		file.close();
	pass;

func register_recipe(target_item: String, recipe: Array, count : int, shape: bool = false):
	var item_recipe_list: Array = []
	if (recipe_dict.has(target_item)) :
		item_recipe_list = recipe_dict[target_item]
	
	var item_number : int = 0;
	for item : String in recipe : 
		if (item == "") : continue;
		item_number += 1;
	if (item_number == 0) : return;
	var recipe_dict_entry: Dictionary = {
		"item": target_item,	# 物品ID
		"shape": shape,			# 物品配方是否乱序
		"recipe": recipe,		# 数据
		"count": count,
		"item_number": item_number
	};
	item_recipe_list.append(recipe_dict_entry);
	recipe_dict[target_item] = item_recipe_list;

func search_recipe_target_item(recipe: Array[String]) -> Dictionary:
	var item_number : int = 0;
	for item : String in recipe : 
		if (item == "") : continue;
		item_number += 1;
	for item_key in recipe_dict.keys():
		var item_recipe_list: Array = recipe_dict[item_key];
		for recipe_dict_entry: Dictionary in item_recipe_list:
			if !recipe_dict_entry["shape"]:
				# 无序配方
				if (item_number != recipe_dict_entry["item_number"]) : break;
				var all_items_present: bool = true;
				var steck : Array = recipe.duplicate();
				for count : int in range(recipe.size()) : 
					var item : String = steck.pop_back();
					if (item == "") : continue;
					if (item not in recipe_dict_entry["recipe"]) :
						all_items_present = false;
				if all_items_present && steck.is_empty() :
					return recipe_dict_entry;
			else:
				# 有序配方
				if (recipe == recipe_dict_entry["recipe"]) : 
					return recipe_dict_entry;
	return {}  # 没有找到匹配的配方

func register_item(item_id : String, texture : Texture2D) : 
	item_dict[item_id] = {
		"texture" : texture, # 物品纹理
		"can_gifted" : true, # 可丢弃(划掉)赠送给铁匠村民
		"can_smelt" : false, # 可燃
		"smelt_products" : "", # 燃烧产物
		"smelt_time" : 3.0, # 燃烧时间
		"value" : 1.0, # 物品价值 
	};
