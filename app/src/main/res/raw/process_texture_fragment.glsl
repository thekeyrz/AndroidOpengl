precision highp float;

varying vec2 v_TextureCoordinates;
uniform sampler2D u_TextureUnit;
varying vec3 objectCoord;

uniform float radianAngle;

vec4 getBrickColor(mat2 rotation, vec3 VertexCoord){ //铺砖效果

    vec2 RectangularSize = vec2(0.40, 0.10);
    vec2 BrickPercent = vec2(0.90, 0.85);
    vec3 color;
    vec2 position, useBrick;
    //fract(cueeentPoint / rectSize) 这是一种典型的取模的计算方式；得到的小数点会根据cueeentPoint是rectSize整数倍的时候相同，比如：fract(1／10) == fract(11／10) == fract(21／10) == fract(31／10)
    position = (rotation * VertexCoord.xy) / RectangularSize;
    if (fract(position.y * 0.5) > 0.5){//这样做是为了在Y轴以rectSize为单位，交替的时候，在x轴上增加0.5
        position.x += 0.5;
    }
    position = fract(position);
    useBrick = step(position, BrickPercent);
    vec4 tempColor = vec4(1.0, 0.0, 1.0, 1.0);
    vec4 baseColor = vec4(0.0, 1.0, 0.0, 0.0);

    return mix(baseColor, tempColor, useBrick.x * useBrick.y);
}

vec4 getHollowOutColor(mat3 testRotation, vec3 VertexCoord){ //镂空效果
    float side = 0.40;
    float dotSize = 0.2;
    vec3 cube = vec3(side, side, side);
    float insideSphere, length;
    vec3 position = mod(testRotation * VertexCoord, cube) - cube * 0.5;
    length = sqrt( (position.x*position.x) + (position.y*position.y) + (position.z*position.z) );
    insideSphere = step(length, dotSize);

    vec4 tempColor;
    vec4 baseColor;
    if (gl_FrontFacing){
//        vec4 tempColor = vec4(1.0, 0.0, 1.0, 1.0);
//        vec4 baseColor = vec4(0.0, 1.0, 0.0, 0.0);
//        gl_FragColor =  mix(baseColor, tempColor, insideSphere);
        if(insideSphere == 1.0){
                tempColor = vec4(1.0, 0.0, 1.0, 1.0);
                baseColor = vec4(0.0, 1.0, 0.0, 0.0);
        }else{
                discard;
        }
        return mix(baseColor, tempColor, insideSphere);
    }else{
        vec4 tempColor = vec4(1.0, 1.0, 1.0, 1.0);
        vec4 baseColor = vec4(0.5, 0.5, 0.0, 0.0);
        return mix(baseColor, tempColor, insideSphere);
    }
}

void main()
{
//	float RadianAngle = time/2.0; //90.0;
	float cosValue = cos(radianAngle/20.0); // Calculate Cos of Theta
    float sinValue = sin(radianAngle/10.0); // Calculate Sin of Theta

    vec3 VertexCoord = objectCoord;
    mat2 rotation = mat2(cosValue, sinValue, -sinValue, cosValue);
//    VertexCoord.xy = rotation * VertexCoord.xy;


    mat3 testRotation = mat3(
        cosValue, sinValue, 0,
         -sinValue, cosValue,0,
          0, 0, 1);
    gl_FragColor = getHollowOutColor(testRotation, VertexCoord); //过程纹理的镂空效果
//    gl_FragColor = getBrickColor(rotation, VertexCoord); //过程纹理的铺砖效果





//        float side = 50.0;
//        float dotSize = side * 0.25;
//        vec2 square = vec2(side, side);
//
//            vec2 position = mod(rotation * gl_FragCoord.xy, square) - square * 0.5;
//            float length = length(position);
//            float inside = step(length, dotSize);
//            vec4 tempColor = vec4(1,0,1,1);
//            vec4 baseColor = vec4(0,1,0,0);
//
//            gl_FragColor = mix(baseColor, tempColor, inside);




//	if (VertexCoord.x > 0.0 && VertexCoord.y > 0.0)
//		gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
//	else if (VertexCoord.x > 0.0 && VertexCoord.y < 0.0)
//		gl_FragColor = vec4(0.0, 01.0, 0.0, 1.0);
//	else if (VertexCoord.x < 0.0 && VertexCoord.y > 0.0)
//		gl_FragColor = vec4(0.0, 01.0, 1.0, 1.0);
//	else if (VertexCoord.x < 0.0 && VertexCoord.y < 0.0)
//		 gl_FragColor = vec4(1.0, 0.0, 1.0, 1.0);
}