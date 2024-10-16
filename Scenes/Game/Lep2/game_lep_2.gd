extends Node2D;
@onready var game_scene: Node2D = $GameScene;
@onready var iron_worker_soundplayer : AudioStreamPlayer = $GameScene/SmithyHouse/IronWorkerSoundPlayer;
@onready var smithy_house : Node2D = $GameScene/SmithyHouse;
@onready var iron_worker_villager : Sprite2D = $GameScene/SmithyHouse/Marker2D/IronWorkerVillager;
@onready var crafting_table_canvas_layer: CanvasLayer = $CraftingTableCanvasLayer;
@onready var item_bar: Control = $GameScene/SmithyHouse/ItemBar;
@onready var mine_list: Node2D = $GameScene/WorkSpace/GirndstonePlantform/MineList;
@onready var game_timer: Timer = %GameTimer;
@onready var timeout_ui: CanvasLayer = $TimeoutUI;
@onready var gui_layer: CanvasLayer = $GUILayer;

const START_MENU_BGM = preload("res://Audio/MenuBGM.MP3");

var ingredient_list : Array[String] = ["raw_copper", "raw_iron"];
var bgm_audio_task : AudioTask = null;
var make_emerald_count : int = 0;
var auto_smelt : bool = true;

var global_list : Array[String] = ["copper_ingot", "iron_ingot", "stick", "plank"];
func _enter_tree() -> void : 
	await get_tree().process_frame;
	if ("iron_upgrade" in Global.upgrade_list) : 
		global_list.append("iron_sword"); 
		global_list.append("iron_shovel"); 
		global_list.append("iron_pickaxe"); 
		global_list.append("iron_hoe");
		global_list.append("iron_axe");
		if (Global.upgrade_list["iron_upgrade"] > 1) : 
			global_list.append("iron_boots");
			global_list.append("iron_leggings");
			global_list.append("iron_chestplate");
			global_list.append("iron_helmet");
	if ("gold_upgrade" in Global.upgrade_list) : 
		global_list.append("gold_ingot"); 
		global_list.append("golden_sword"); 
		global_list.append("golden_shovel"); 
		global_list.append("golden_pickaxe"); 
		global_list.append("golden_hoe");
		global_list.append("golden_axe");
		if (Global.upgrade_list["gold_upgrade"] > 1) : 
			global_list.append("golden_boots");
			global_list.append("golden_leggings");
			global_list.append("golden_chestplate");
			global_list.append("golden_helmet");
	if ("diamond_upgrade" in Global.upgrade_list) : 
		global_list.append("diamond_sword"); 
		global_list.append("diamond_shovel"); 
		global_list.append("diamond_pickaxe"); 
		global_list.append("diamond_hoe");
		global_list.append("diamond_axe");
		if (Global.upgrade_list["diamond_upgrade"] > 1) : 
			global_list.append("diamond_boots");
			global_list.append("diamond_leggings");
			global_list.append("diamond_chestplate");
			global_list.append("diamond_helmet");
	# 全局物品配方列表

func _ready() -> void : 
	item_bar.add_item_bar("raw_copper", "粗铜");
	item_bar.add_item_bar("raw_iron", "粗铁");
	if ("gold_upgrade" in Global.upgrade_list) : 
		ingredient_list.append("raw_gold");
		item_bar.add_item_bar("raw_gold", "粗金");
	if ("diamond_upgrade" in Global.upgrade_list) : 
		ingredient_list.append("diamond");
		item_bar.add_item_bar("diamond", "钻石");
	ingredient_list.append("netherite_scrap");
	item_bar.add_item_bar("netherite_scrap", "下界合金");
	
	mine_list.create_mine();
	auto_smelt = ("auto_smelt" in Global.upgrade_list);
	
	bgm_audio_task = AudioManager.play_suond(START_MENU_BGM);
	bgm_audio_task.volume = -5;
	bgm_audio_task.looping = true;
	
	if (Global.day >= 10) : 
		game_timer.wait_time = 210;
		if (Global.day >= 20) : 
			game_timer.wait_time = 240;
			if (Global.day >= 30) : 
				game_timer.wait_time = 270;
	
	if (Global.day == 0) : 
		game_scene.process_mode = Node.PROCESS_MODE_DISABLED;
		await get_tree().create_timer(1).timeout;
		smithy_house.villiger_speaking = true;
		iron_worker_soundplayer.stream = preload("res://Audio/Sound/Villiger/day1_voice1.MP3");
		iron_worker_soundplayer.play();
		await iron_worker_soundplayer.finished;
		smithy_house.villiger_speaking = false;
		
		await get_tree().create_timer(0.25).timeout;
		smithy_house.villiger_speaking = true;
		iron_worker_soundplayer.stream = preload("res://Audio/Sound/Villiger/day1_voice2.MP3");
		iron_worker_soundplayer.play();
		await iron_worker_soundplayer.finished;
		smithy_house.villiger_speaking = false;
		game_scene.process_mode = Node.PROCESS_MODE_INHERIT;
	
	game_timer.start();
	

func pause_game() : 
	get_tree().paused = true;
	gui_layer.process_mode = Node.PROCESS_MODE_DISABLED;
	game_scene.process_mode = Node.PROCESS_MODE_DISABLED;
	var tween : Tween = get_tree().create_tween();
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS);
	tween.tween_property(bgm_audio_task, "volume", -80, 0.1);
	await tween.finished;
	bgm_audio_task.pause();

func resume_game() : 
	get_tree().paused = false;
	game_scene.process_mode = Node.PROCESS_MODE_INHERIT;
	gui_layer.process_mode = Node.PROCESS_MODE_INHERIT;
	var tween : Tween = get_tree().create_tween();
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS);
	tween.tween_property(bgm_audio_task, "volume", -5, 0.1);
	await tween.finished;
	bgm_audio_task.resume();

func exit_game() : 
	get_tree().paused = false;
	SceneManager.change_scene_form_file("res://Scenes/StartMenus/main_menu.tscn");
	AudioManager.stop_all_sound();
	DragManager.free_drag_item();
	Global.save_game();

func _on_game_timer_timeout() -> void:
	pause_game();
	timeout_ui.open();
	Global.day += 1;
	Global.emerald_count += make_emerald_count;
	Global.game_time += game_timer.wait_time;
