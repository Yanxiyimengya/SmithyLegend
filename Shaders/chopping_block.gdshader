shader_type canvas_item;



uniform float time_factor: hint_range(0.0, 2.0) = 0.0;

uniform float progress: hint_range(0.0, 10.0) = 0.0;

uniform bool oneshot = true;

uniform float init_size: hint_range(0.0, 1.0) = 0.1;

uniform float init_interval: hint_range(0.0, 1.0) = 0.2;

uniform float init_offset: hint_range(0.0, 1.0) = 0.1;

uniform float init_num = 5.0;

uniform vec2 init_direction = vec2(0.0, 0.0);

uniform vec2 rnd_direction_factor = vec2(1.0, 1.0);

uniform vec2 rnd_size_factor = vec2(1.0, 1.0);



uniform float rnd_rotate_factor : hint_range(0.0, 20.0, 0.1) = 0.0;

uniform float rnd_rotate_offset : hint_range(0.0, 10.0, 0.1) = 0.0;

uniform float angle_velocity_min : hint_range(-10.0, 10.0, 0.1) = 0.0;

uniform float angle_velocity_max : hint_range(-10.0, 10.0, 0.1) = 0.0;



uniform vec2 expand_factor = vec2(1.0, 1.0);

uniform vec2 expand_offset = vec2(0.0, 0.0);



//uniform float gravity: hint_range(0.0, 1.0) = 0.0;

uniform sampler2D life_rate_alpha_decay_curve: source_color;

uniform sampler2D life_rate_scale_decay_curve: source_color;

uniform float bounce_thresh: hint_range(0.0, 1.0) = 1.0;

uniform float bounce_factor: hint_range(0.0, 1.0) = 1.0;

uniform sampler2D noise : repeat_enable ;

//uniform area area_a;



void vertex() {

	// Called for every vertex the material is visible on.

		VERTEX = expand_factor*VERTEX;

}



vec2 noise_vec2(vec2 uv) {

	uv = vec2(dot(uv, vec2(127.1,311.7)), dot(uv, vec2(269.5,183.3)));

	return fract(sin(uv) * 43758.5453123) * 0.5;

}

vec2 pred_pos(vec2 uv, vec2 direction, float time){

	// 预测一段时间后的位置

	vec2 res = uv + direction * time;

	// 如果反弹地面, 在接触地面时改变y方向的速度

	if (uv.y <bounce_thresh && res .y >bounce_thresh){

		float passed_time = (bounce_thresh - uv.y)/direction.y;

		vec2 new_uv = vec2(res.x, bounce_thresh);

		vec2 new_direction = vec2(direction.x, -direction.y * bounce_factor);

		float new_time = time - passed_time;

		vec2 new_res = new_uv + new_direction * new_time;

		return new_res;

	}

	return res;

}

mat2 rotate2d(float _angle){

  return mat2( vec2(cos(_angle),-sin(_angle)),

        vec2(sin(_angle),cos(_angle)));

}



struct area{

	vec2 center;

	vec2 size;

	vec2 direction;

	float angle;

};

bool is_in_area(area a, vec2 uv){

	// 如何判断一个点在一个带角度的方形内部

	// 很简单, 反方向旋转点就行了

	vec2 angle_reversed_uv = uv - a.center;

	angle_reversed_uv *= rotate2d(-a.angle);

	angle_reversed_uv += a.center;

	// 旋转之后就只需比较轴向距离

	if(angle_reversed_uv.x > a.center.x - a.size.x &&

		angle_reversed_uv.x < a.center.x + a.size.x &&

		angle_reversed_uv.y > a.center.y - a.size.y &&

		angle_reversed_uv.y < a.center.y + a.size.y ){

			return true;

		}

	//if(uv.x > a.center.x - a.size.x &&

		//uv.x < a.center.x + a.size.x &&

		//uv.y > a.center.y - a.size.y &&

		//uv.y < a.center.y + a.size.y ){

			//return true;

		//}

	return false;

}



void fragment() {

	// Called for every pixel the material is visible on.

	vec2 uv = expand_factor * (UV) + expand_offset;

	area a ;

	COLOR = vec4(0.);



	for(float i = 0.0; i< init_num; i++){

		for(float j = 0.0; j< init_num; j++){



			vec2 ns_max_life = noise_vec2(vec2(0.1, 0.3) * (0.0+11.0*i + j));



			float progress_time;

			//如果一次性发射, 则不需要对时间取模, 但time_factor必须为0

			if (oneshot){

				 progress_time = TIME *time_factor + progress;

			}

			else{

				 progress_time = mod(TIME *time_factor + progress, 2.0 + ns_max_life.x);

			}

			float life_rate = progress_time/(2.0 + ns_max_life.x);



			vec2 org_center = init_offset + vec2( i * init_interval , j * init_interval);

			//随机速度两个(0,0.5)本身就是90度随机方向的

			vec2 rnd_direction = noise_vec2(vec2(0.1, 0.3) * (0.1+11.0*i +j));

			//只对随机速度部分进行旋转即随机旋转

			rnd_direction *= rotate2d(rnd_rotate_offset + ns_max_life.y * rnd_rotate_factor);



			//创建结构体 area a 方便存储区块信息

			a.center = org_center;

			//名为direction 实为速度

			a.direction = init_direction + rnd_direction * rnd_direction_factor;

			// 应用速度预测经过progress_time后粒子的中心位置

			a.center = pred_pos(a.center, a.direction, progress_time );

			//如果希望粒子表面不那么平滑可以使用下面的ns_size随机尺寸

			a.size = vec2(init_size, init_size);

			vec2 ns_size = texture(noise, uv -a.center + 0.2*i + 0.1*j).rg;

			a.size *= 1.0 + ns_size * rnd_size_factor;

			//根据curve曲线和当前生命周期 缩放粒子的大小

			a.size *= texture(life_rate_scale_decay_curve, vec2(life_rate)).r;

			//应用在(angle_velocity_min, angle_velocity_max)之间的随机角速度

			float angle_velocity = angle_velocity_min +

					noise_vec2(vec2(13.1, 12.1) * (11.0*i + j)).x * 2.0 *

					(angle_velocity_max - angle_velocity_min);

			a.angle = angle_velocity * progress_time;

			//判断当前点(即uv)是否在当前遍历的区域area内部

			//如果在区域外就不考虑了

			if(is_in_area(a, uv)){

				//如果在区域内则说明当前位置存在该粒子内部,进行处理

				// 修复bug 区块是旋转了但是图像没旋转, 因此旋转uv

				vec2 angle_reversed_uv = uv - a.center;

				angle_reversed_uv *= rotate2d(-a.angle);
				angle_reversed_uv += a.center;
				//计算当前uv 随着当前粒子(a)回溯到时间为0时的位置back_uv
				vec2 back_uv = angle_reversed_uv - a.center + org_center;
				//使用back_uv取样, 并应用透明度曲线
				float rate_alpha = texture(life_rate_alpha_decay_curve, vec2(life_rate)).r;

				COLOR = texture(TEXTURE, back_uv) *vec4(1.,1.,1., rate_alpha);
			}
		}
	}
}