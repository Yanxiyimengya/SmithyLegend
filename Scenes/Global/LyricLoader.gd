extends Object;
class_name LyricLoader;

static func load_lyric(str : String) -> Lyric : 
	var l : Lyric = Lyric.new();
	var word : String = "";
	var time : float = 0.0;
	var time_scale : float = 60.0;
	for char : String in str : 
		if (char == "\r" || char == "\n") :
			if (!word.is_empty()) : 
				l.lyric_list.append(word);
				word = "";
				continue;
		elif (char == "[") :
			time = 0.0;
			time_scale = 60.0;
			word = "";
			continue;
		elif (char == ":") :
			time += word.to_float() * time_scale;
			time_scale *= 60;
			word = "";
			continue;
		elif (char == "]") : 
			time += word.to_float();
			l.lyric_time.append(time);
			word = "";
			continue;
		word += char;
	return l;

class Lyric : 
	var lyric_list : PackedStringArray = [];
	var lyric_time : PackedFloat32Array = [];
