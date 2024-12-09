Shader"Custom/ColorCorrectionLUT"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LUT ("LUT Texture", 2D) = "black" {}
        _LUTSize ("LUT Size", Range(1, 64)) = 16
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
            LOD 200

                    Pass
                    {
                        CGPROGRAM
                        #pragma vertex vert
                        #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata_t
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _LUT;
            float _LUTSize;

            v2f vert(appdata_t v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                            // Sample the main texture
                float4 color = tex2D(_MainTex, i.uv);

                            // Calculate the position in the LUT
                float3 lutCoords = color.rgb * (_LUTSize - 1);
                int3 lutIndex = int3(lutCoords);
                float3 fracCoords = lutCoords - lutIndex;

                            // Sample the LUT texture
                float4 color1 = tex2D(_LUT, float2(lutIndex.r / _LUTSize, lutIndex.g / _LUTSize));
                float4 color2 = tex2D(_LUT, float2(lutIndex.r / _LUTSize, (lutIndex.g + 1) / _LUTSize));
                float4 color3 = tex2D(_LUT, float2((lutIndex.r + 1) / _LUTSize, lutIndex.g / _LUTSize));
                float4 color4 = tex2D(_LUT, float2((lutIndex.r + 1) / _LUTSize, (lutIndex.g + 1) / _LUTSize));

                            // Interpolate the colors
                float4 finalColor = lerp(lerp(color1, color2, fracCoords.g), lerp(color3, color4, fracCoords.g), fracCoords.r);
                
                return finalColor;
            }
            ENDCG
        }
    }
FallBack"Diffuse"
}
