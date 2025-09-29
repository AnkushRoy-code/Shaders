// https://www.shadertoy.com/view/3cSBDh

// I with this shader am trying to get familiar with glsl and the maths behind 
// shaders.

// plotting function: spent the most time on it. What I came up
// with was computationally very fast but. It was not having a 
// uniform thickness for only having y-thickness and no x-thickness.
// Then I consulted GPT, it gave me shit. So I googled and found this:
// https://www.shadertoy.com/view/slX3W2, I changed it's usage a bit 
// so now it can be used with multiple functions.
// I really like it now :)

float lineWidth = 0.03;
float DELTA = 0.005;

float plot(vec2 uv, vec2 p, vec2 pDelta){
  vec2 delta = pDelta - p;
  float cosPhi = delta.x / length(delta); //cos(atan(delta.y, delta.x));
  float height = lineWidth / 2.0 / cosPhi;
  return abs(uv.y - p.y) - height;
}

float f1(float x) { return x * x; }
float f2(float x) { return x * x * x; }
float f3(float x) { return sin(x); }
float f4(float x) { return cos(sinh(x)); }

vec3 draw_grid(vec2 uv){
    // grid, I tried to make it work by seeing this shader: https://www.shadertoy.com/view/wdK3Dy.
    // Ultimately it was too much complicated for me and I 
    // decided to do it my own way. I just yanked the colours
    // from there.
    vec3 res = vec3(0.7);

    vec3 grid_colour = vec3(0.6);
    float grid_space = 0.5;
    float grid_thickness = 0.03;
    
    // the big grid
    if (mod(uv.y, grid_space) > grid_space - grid_thickness)
        res = grid_colour;
    else if (mod(uv.x, grid_space) > grid_space - grid_thickness)
        res = grid_colour;
    
    // the smol grid
    grid_space = 0.1;
    grid_thickness = 0.015;
    
    if (mod(uv.y, grid_space) > grid_space - grid_thickness)
        res = grid_colour;
    else if (mod(uv.x, grid_space) > grid_space - grid_thickness)
        res = grid_colour;

    return res;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // normalised from -1 to 1 in the y axis
    vec2 uv = (2.0 * fragCoord - iResolution.xy) / iResolution.y;
    uv *= 2.0;
    
    vec3 green = vec3(0, 1, 0);
    vec3 red = vec3(1, 0, 0);
    vec3 blue = vec3(0, 0, 1);
    vec3 pink = vec3(1, 0, 1);
    vec3 white = vec3(1);
    
    vec3 col = draw_grid(uv);
    
    // todo: understand how this shit works: https://www.shadertoy.com/view/wdK3Dy
    // vignette
    vec2 pk = fragCoord.xy;           // Point
	vec2 c = iResolution.xy / 2.0;   // Center
    col *= (1.0 - length(c - pk)/iResolution.x*0.7);

    // test normals
    //if(length(uv) < 1.0)
    //   col = white;
    

    // plotting the graphs
    vec2 p = vec2(uv.x, f1(uv.x));
    vec2 pDelta = vec2(uv.x + DELTA, f1(uv.x + DELTA));
    float v1 = plot(uv, p, pDelta);
    
    p = vec2(uv.x, f2(uv.x));
    pDelta = vec2(uv.x + DELTA, f2(uv.x + DELTA));
    float v2 = plot(uv, p, pDelta);
    
    p = vec2(uv.x, f3(uv.x));
    pDelta = vec2(uv.x + DELTA, f3(uv.x + DELTA));
    float v3 = plot(uv, p, pDelta);
    
    p = vec2(uv.x, f4(uv.x));
    pDelta = vec2(uv.x + DELTA, f4(uv.x + DELTA));
    float v4 = plot(uv, p, pDelta);

    p = vec2(uv.x, (uv.x));
    pDelta = vec2(uv.x + DELTA, (uv.x + DELTA));
    float v5 = plot(uv, p, pDelta);
    	
    float pixel_width = 8.0 / iResolution.y;
    /**
    col = mix(col, blue,  smoothstep(pixel_width, -pixel_width, v1));
    col = mix(col, red,   smoothstep(pixel_width, -pixel_width, v2));
    col = mix(col, green, smoothstep(pixel_width, -pixel_width, v3));
    col = mix(col, white, smoothstep(pixel_width, -pixel_width, v4));
    col = mix(col, pink,  smoothstep(pixel_width, -pixel_width, v5));
    **/ 
    
    float a = pixel_width, b = -pixel_width;
    col += smoothstep(a, b, v1) * blue;
    col += smoothstep(a, b, v2) * red;
    col += smoothstep(a, b, v3) * green;
    col += smoothstep(a, b, v4) * white;
    col += smoothstep(a, b, v5) * pink;
    
    fragColor = vec4(col, 1);
}
