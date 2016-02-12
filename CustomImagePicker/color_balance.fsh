precision highp float;

varying highp vec2 textureCoordinate;
uniform sampler2D inputImageTexture;

uniform lowp float redBalance;
uniform lowp float greenBalance;
uniform lowp float blueBalance;
uniform lowp int option;

void main() {
    lowp vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
    lowp vec3 multiplier = (vec3(redBalance, greenBalance, blueBalance) * 2.0);
    
    lowp vec3 color;
    if (option != 0) {
        color = (1.0 - textureColor.rgb);
    } else {
        color = textureColor.rgb;
    }
    
    gl_FragColor.rgb = color * multiplier;
    gl_FragColor.a = textureColor.a;
}