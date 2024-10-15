extends RefCounted;
class_name MeshMaker;

@warning_ignore("integer_division")
static func build(image : Image) -> ArrayMesh : 
	if (image.get_size() <= Vector2i.ZERO) : 
		return
	var surface_tool : SurfaceTool = SurfaceTool.new();
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES);
	
	var image_size : Vector2i = image.get_size();
	var pixel_array : Array[Vector3i] = [];
	var color_array : Array[Color] = [];
	var pixel_color : Color;
	
	for img_x in image_size.x : 
		for img_y in image_size.y : 
			pixel_color = image.get_pixel(img_x, img_y);
			if (pixel_color.a > 0) : 
				pixel_array.append(Vector3i(img_x, -img_y, 0)); 
				color_array.append(pixel_color);
	# 遍历图片全部的像素
	# 提取出有效像素
	
	var pos : Vector3;
	var end : Vector3;
	
	var count : int = 0;
	for pixel in pixel_array : 
		pos = pixel;
		end = pos + Vector3.ONE;
		# 获取位置 颜色信息
		var vertexs : Array[Vector3] = [
			pos,
			end, # 对边顶点
			Vector3(pos.x,pos.y,end.z),
			Vector3(pos.x,end.y,pos.z),
			Vector3(end.x,pos.y,pos.z), # Start点相邻边顶点
			Vector3(pos.x,end.y,end.z),
			Vector3(end.x,pos.y,end.z),
			Vector3(end.x,end.y,pos.z)  # End点相邻的顶点
		]; # 立方体八个顶点数组
		var faces : Array[Array] = [
			[[vertexs[6], vertexs[1], vertexs[7], vertexs[4]] # Vertexs
					,Vector3.RIGHT # Normal 法线
					,Vector2.DOWN ], # UV
			[[vertexs[1], vertexs[5], vertexs[3], vertexs[7]] # Vertexs
					,Vector3.UP # Normal 法线
					,Vector2.ZERO ], # UV
			[[vertexs[0], vertexs[3], vertexs[5], vertexs[2]] # Vertexs
					,Vector3.LEFT # Normal 法线
					,Vector2.RIGHT ], # UV
			[[vertexs[2], vertexs[6], vertexs[4], vertexs[0]] # Vertexs
					,Vector3.DOWN # Normal 法线
					,Vector2.RIGHT ], # UV
			[[vertexs[4], vertexs[7], vertexs[3], vertexs[0]] # Vertexs
					,Vector3.FORWARD # Normal 法线
					,Vector2.ONE ], # UV
			[[vertexs[2], vertexs[5], vertexs[1], vertexs[6]] # Vertexs
					,Vector3.BACK # Normal 法线
					,Vector2.DOWN ], # UV
		]; # 立方体的六个面的数据数组
		
		for face in faces : 
			if (Vector3i(pos + face[1]) in pixel_array) : 
				continue;
			for i in [0,1,2,2,3,0] : 
				surface_tool.set_color(color_array[count]);
				surface_tool.set_normal(face[1]);
				surface_tool.set_uv(face[2]);
				
				var new_vertex : Vector3 = face[0][i];
				new_vertex.x -= image_size.x / 2;
				surface_tool.add_vertex(new_vertex);
		count += 1;
		# 构建网格顶点
	return surface_tool.commit();
