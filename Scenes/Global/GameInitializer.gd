extends RefCounted;
class_name GameInitializer;

static func init() -> void:
	
	## 基础配方
	Global.register_recipe("plank", ["log"], 4, false);
	# 原木 -> 木板
	Global.register_recipe("stick", ["plank", "", "", "plank", "", ""], 4, true);
	# 木板 -> 木棍
	Global.register_item("chest", preload("res://Graphics/Item/Block/chest.png"));
	# 箱子
	Global.register_item("boat", preload("res://Graphics/Item/oak_boat.png"));
	# 船
	Global.register_item("chest_boat", preload("res://Graphics/Item/oak_chest_boat.png"));
	# 船
	
	Global.register_recipe("chest", ["plank", "plank", "plank", "plank", "", "plank","plank", "plank", "plank"], 1, true);
	# 箱子合成配方
	Global.register_recipe("boat", ["plank", "", "plank","plank", "plank", "plank"], 1, true);
	# 箱子合成配方
	Global.register_recipe("chest_boat", ["boat", "chest"], 1, false);
	# 箱子合成配方
	
	## 原材料
	Global.register_item("raw_copper", preload("res://Graphics/Item/raw_copper.png"));
	Global.item_dict["raw_copper"]["can_gifted"] = false;
	Global.item_dict["raw_copper"]["can_smelt"] = true;
	Global.item_dict["raw_copper"]["smelt_products"] = "copper_ingot";
	# 粗铜
	Global.register_item("raw_iron", preload("res://Graphics/Item/Iron/raw_iron.png"));
	Global.item_dict["raw_iron"]["can_gifted"] = false;
	Global.item_dict["raw_iron"]["can_smelt"] = true;
	Global.item_dict["raw_iron"]["smelt_time"] = 3.0;
	Global.item_dict["raw_iron"]["smelt_products"] = "iron_ingot";
	# 粗铁
	Global.register_item("raw_gold", preload("res://Graphics/Item/Gold/raw_gold.png"));
	Global.item_dict["raw_gold"]["can_gifted"] = false;
	Global.item_dict["raw_gold"]["can_smelt"] = true;
	Global.item_dict["raw_gold"]["smelt_time"] = 4.0;
	Global.item_dict["raw_gold"]["smelt_products"] = "gold_ingot";
	# 粗金
	Global.register_item("diamond", preload("res://Graphics/Item/Diamond/diamond.png"));
	Global.item_dict["diamond"]["can_gifted"] = false;
	# 钻石
	
	Global.register_item("netherite_scrap", preload("res://Graphics/Item/Netherite/netherite_scrap.png"));
	Global.item_dict["netherite_scrap"]["can_gifted"] = false;
	# 下界合金碎片
	
	## 基础材料
	Global.register_item("copper_ingot", preload("res://Graphics/Item/copper_ingot.png"));
	Global.item_dict["copper_ingot"]["value"] = 1;
	# 铜锭
	Global.register_item("iron_ingot", preload("res://Graphics/Item/Iron/iron_ingot.png"));
	Global.item_dict["iron_ingot"]["value"] = 2;
	# 铁锭
	Global.register_item("gold_ingot", preload("res://Graphics/Item/Gold/gold_ingot.png"));
	Global.item_dict["gold_ingot"]["value"] = 3;
	# 金锭
	Global.register_item("log", preload("res://Graphics/Item/Block/log.png"));
	Global.item_dict["log"]["value"] = 1;
	# 木头
	Global.register_item("plank", preload("res://Graphics/Item/Block/plank.png"));
	Global.item_dict["plank"]["value"] = 1;
	# 木板
	Global.register_item("stick", preload("res://Graphics/Item/stick.png"));
	Global.item_dict["stick"]["value"] = 1;
	# 木棍	
	
	#region 工具装备
	Global.register_item("iron_block", preload("res://Graphics/Item/Block/iron_block.png"));
	Global.item_dict["iron_block"]["value"] = 20;
	# 铁块
	Global.register_item("bucket", preload("res://Graphics/Item/Iron/bucket.png"));
	Global.item_dict["bucket"]["value"] = 7;
	# 铁桶
	Global.register_item("anvil", preload("res://Graphics/Item/Block/anvil.png"));
	Global.item_dict["anvil"]["value"] = 68;
	# 铁砧
	
	Global.register_item("iron_sword", preload("res://Graphics/Item/Iron/iron_sword.png"));
	Global.item_dict["iron_sword"]["value"] = 8;
	# 铁剑
	Global.register_item("iron_pickaxe", preload("res://Graphics/Item/Iron/iron_pickaxe.png"));
	Global.item_dict["iron_pickaxe"]["value"] = 10;
	# 铁镐
	Global.register_item("iron_axe", preload("res://Graphics/Item/Iron/iron_axe.png"));
	Global.item_dict["iron_axe"]["value"] = 10;
	# 铁斧
	Global.register_item("iron_shovel", preload("res://Graphics/Item/Iron/iron_shovel.png"));
	Global.item_dict["iron_shovel"]["value"] = 8;
	# 铁铲
	Global.register_item("iron_hoe", preload("res://Graphics/Item/Iron/iron_hoe.png"));
	Global.item_dict["iron_hoe"]["value"] = 9;
	# 铁锄
	Global.register_item("iron_helmet", preload("res://Graphics/Item/Iron/iron_helmet.png"));
	Global.item_dict["iron_helmet"]["value"] = 11;
	# 铁头盔
	Global.register_item("iron_chestplate", preload("res://Graphics/Item/Iron/iron_chestplate.png"));
	Global.item_dict["iron_chestplate"]["value"] = 16;
	# 铁胸甲
	Global.register_item("iron_leggings", preload("res://Graphics/Item/Iron/iron_leggings.png"));
	Global.item_dict["iron_leggings"]["value"] = 14;
	# 铁护腿
	Global.register_item("iron_boots", preload("res://Graphics/Item/Iron/iron_boots.png"));
	Global.item_dict["iron_boots"]["value"] = 9;
	# 铁靴子
	
	Global.register_item("gold_block", preload("res://Graphics/Item/Block/glod_block.png"));
	Global.item_dict["gold_block"]["value"] = 30;
	# 金块
	Global.register_item("golden_sword", preload("res://Graphics/Item/Gold/golden_sword.png"));
	Global.item_dict["golden_sword"]["value"] = 12;
	# 金剑
	Global.register_item("golden_pickaxe", preload("res://Graphics/Item/Gold/golden_pickaxe.png"));
	Global.item_dict["golden_pickaxe"]["value"] = 14;
	# 金镐
	Global.register_item("golden_axe", preload("res://Graphics/Item/Gold/golden_axe.png"));
	Global.item_dict["golden_axe"]["value"] = 14;
	# 金斧
	Global.register_item("golden_shovel", preload("res://Graphics/Item/Gold/golden_shovel.png"));
	Global.item_dict["golden_shovel"]["value"] = 12;
	# 金铲
	Global.register_item("golden_hoe", preload("res://Graphics/Item/Gold/golden_hoe.png"));
	Global.item_dict["golden_hoe"]["value"] = 13;
	# 金锄
	Global.register_item("golden_helmet", preload("res://Graphics/Item/Gold/golden_helmet.png"));
	Global.item_dict["golden_helmet"]["value"] = 16;
	# 金头盔
	Global.register_item("golden_chestplate", preload("res://Graphics/Item/Gold/golden_chestplate.png"));
	Global.item_dict["golden_chestplate"]["value"] = 22;
	# 金胸甲
	Global.register_item("golden_leggings", preload("res://Graphics/Item/Gold/golden_leggings.png"));
	Global.item_dict["golden_leggings"]["value"] = 20;
	# 金护腿
	Global.register_item("golden_boots", preload("res://Graphics/Item/Gold/golden_boots.png"));
	Global.item_dict["golden_boots"]["value"] = 13;
	# 金靴子
	
	Global.register_item("diamond_sword", preload("res://Graphics/Item/Block/diamond_block.png"));
	Global.item_dict["diamond_sword"]["value"] = 40;
	# 钻石块
	Global.register_item("diamond_sword", preload("res://Graphics/Item/Diamond/diamond_sword.png"));
	Global.item_dict["diamond_sword"]["value"] = 20;
	# 钻石剑
	Global.register_item("diamond_pickaxe", preload("res://Graphics/Item/Diamond/diamond_pickaxe.png"));
	Global.item_dict["diamond_pickaxe"]["value"] = 25;
	# 钻石镐
	Global.register_item("diamond_axe", preload("res://Graphics/Item/Diamond/diamond_axe.png"));
	Global.item_dict["diamond_axe"]["value"] = 25;
	# 钻石斧
	Global.register_item("diamond_shovel", preload("res://Graphics/Item/Diamond/diamond_shovel.png"));
	Global.item_dict["diamond_shovel"]["value"] = 20;
	# 钻石铲
	Global.register_item("diamond_hoe", preload("res://Graphics/Item/Diamond/diamond_hoe.png"));
	Global.item_dict["diamond_hoe"]["value"] = 22;
	# 钻石锄
	Global.register_item("diamond_helmet", preload("res://Graphics/Item/Diamond/diamond_helmet.png"));
	Global.item_dict["diamond_helmet"]["value"] = 28;
	# 钻石头盔
	Global.register_item("diamond_chestplate", preload("res://Graphics/Item/Diamond/diamond_chestplate.png"));
	Global.item_dict["diamond_chestplate"]["value"] = 38;
	# 钻石胸甲
	Global.register_item("diamond_leggings", preload("res://Graphics/Item/Diamond/diamond_leggings.png"));
	Global.item_dict["diamond_leggings"]["value"] = 33;
	# 钻石护腿
	Global.register_item("diamond_boots", preload("res://Graphics/Item/Diamond/diamond_boots.png"));
	Global.item_dict["diamond_boots"]["value"] = 24;
	# 钻石靴子
	#endregion

static func append_iron_props_recipes() : 
	Global.register_recipe("iron_block", ["iron_ingot", "iron_ingot", "iron_ingot", "iron_ingot", "iron_ingot", "iron_ingot","iron_ingot", "iron_ingot", "iron_ingot"], 1, true);
	# 铁块合成配方
	Global.register_recipe("bucket", ["iron_ingot", "", "iron_ingot","", "iron_ingot", ""], 1, true);
	# 桶合成配方
	Global.register_recipe("anvil", ["iron_block", "iron_block", "iron_block","", "iron_ingot", "", "iron_ingot", "iron_ingot", "iron_ingot"], 1, true);
	# 铁砧合成配方
	
	Global.register_recipe("iron_sword", ["iron_ingot", "", "","iron_ingot", "", "","stick", "", ""], 1, true);
	# 铁剑合成配方
	Global.register_recipe("iron_pickaxe", ["iron_ingot", "iron_ingot", "iron_ingot","", "stick", "","", "stick", ""], 1, true);
	# 铁镐合成配方
	Global.register_recipe("iron_axe", ["iron_ingot", "iron_ingot", "","iron_ingot", "stick", "","", "stick", ""], 1, true);
	# 铁斧合成配方
	Global.register_recipe("iron_hoe", ["iron_ingot", "iron_ingot", "","", "stick", "","", "stick", ""], 1, true);
	# 铁锄合成配方
	Global.register_recipe("iron_shovel", ["iron_ingot", "", "","stick", "", "","stick", "", ""], 1, true);
	# 铁铲合成配方

static func append_iron_recipes() : 
	Global.register_recipe("iron_helmet", ["iron_ingot", "iron_ingot", "iron_ingot","iron_ingot", "", "iron_ingot"], 1, true);
	# 铁头盔合成配方
	Global.register_recipe("iron_chestplate", ["iron_ingot", "", "iron_ingot","iron_ingot", "iron_ingot", "iron_ingot","iron_ingot", "iron_ingot", "iron_ingot"], 1, true);
	# 铁胸甲合成配方
	Global.register_recipe("iron_leggings", ["iron_ingot", "iron_ingot", "iron_ingot","iron_ingot", "", "iron_ingot","iron_ingot", "", "iron_ingot"], 1, true);
	# 铁护腿合成配方
	Global.register_recipe("iron_boots", ["iron_ingot", "", "iron_ingot","iron_ingot", "", "iron_ingot"], 1, true);
	# 铁靴子合成配方

static func append_gold_props_recipes() : 
	Global.register_recipe("gold_block", ["gold_ingot", "gold_ingot", "gold_ingot", "gold_ingot", "gold_ingot", "gold_ingot","gold_ingot", "gold_ingot", "gold_ingot"], 1, true);
	# 铁块合成配方
	Global.register_recipe("golden_sword", ["gold_ingot", "", "","gold_ingot", "", "","stick", "", ""], 1, true);
	# 金剑合成配方
	Global.register_recipe("golden_pickaxe", ["gold_ingot", "gold_ingot", "gold_ingot","", "stick", "","", "stick", ""], 1, true);
	# 金镐合成配方
	Global.register_recipe("golden_axe", ["gold_ingot", "gold_ingot", "","gold_ingot", "stick", "","", "stick", ""], 1, true);
	# 金斧合成配方
	Global.register_recipe("golden_hoe", ["gold_ingot", "gold_ingot", "","", "stick", "","", "stick", ""], 1, true);
	# 金锄合成配方
	Global.register_recipe("golden_shovel", ["gold_ingot", "", "","stick", "", "","stick", "", ""], 1, true);

static func append_gold_recipes() : 
	Global.register_recipe("golden_shovel", ["gold_ingot", "", "","stick", "", "","stick", "", ""], 1, true);
	# 金铲合成配方
	Global.register_recipe("golden_helmet", ["gold_ingot", "gold_ingot", "gold_ingot","gold_ingot", "", "gold_ingot"], 1, true);
	# 金头盔合成配方
	Global.register_recipe("golden_chestplate", ["gold_ingot", "", "gold_ingot","gold_ingot", "gold_ingot", "gold_ingot","gold_ingot", "gold_ingot", "gold_ingot"], 1, true);
	# 金胸甲合成配方
	Global.register_recipe("golden_leggings", ["gold_ingot", "gold_ingot", "gold_ingot","gold_ingot", "", "gold_ingot","gold_ingot", "", "gold_ingot"], 1, true);
	# 金护腿合成配方
	Global.register_recipe("golden_boots", ["gold_ingot", "", "gold_ingot","gold_ingot", "", "gold_ingot"], 1, true);
	# 金靴子合成配方

static func append_diamond_props_recipes() : 
	Global.register_recipe("diamond_block", ["diamond", "diamond", "diamond","diamond", "diamond", "diamond","diamond", "diamond", "diamond"], 1, true);
	# 钻石头盔合成配方
	Global.register_recipe("diamond_sword", ["diamond", "", "","diamond", "", "","stick", "", ""], 1, true);
	# 钻石剑合成配方
	Global.register_recipe("diamond_pickaxe", ["diamond", "diamond", "diamond","", "stick", "","", "stick", ""], 1, true);
	# 钻石镐合成配方
	Global.register_recipe("diamond_axe", ["diamond", "diamond", "","diamond", "stick", "","", "stick", ""], 1, true);
	# 钻石斧合成配方
	Global.register_recipe("diamond_hoe", ["diamond", "diamond", "","", "stick", "","", "stick", ""], 1, true);
	# 钻石锄合成配方
	Global.register_recipe("diamond_shovel", ["diamond", "", "","stick", "", "","stick", "", ""], 1, true);
	# 钻石铲合成配方

static func append_diamond_recipes() : 
	Global.register_recipe("diamond_helmet", ["diamond", "diamond", "diamond","diamond", "", "diamond"], 1, true);
	# 钻石头盔合成配方
	Global.register_recipe("diamond_chestplate", ["diamond", "", "diamond","diamond", "diamond", "diamond","diamond", "diamond", "diamond"], 1, true);
	# 钻石胸甲合成配方
	Global.register_recipe("diamond_leggings", ["diamond", "diamond", "diamond","diamond", "", "diamond","diamond", "", "diamond"], 1, true);
	# 钻石护腿合成配方
	Global.register_recipe("diamond_boots", ["diamond", "", "diamond","diamond", "", "diamond"], 1, true);
	# 钻石靴子合成配方
