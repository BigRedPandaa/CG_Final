Shader "Custom/Ambient"
{
        Properties
    {
        _Color ("Base Color", Color) = (1, 1, 1, 1)
        _AmbientColor ("Ambient Color", Color) = (0.5, 0.5, 0.5, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // Include necessary libraries
#include "UnityCG.cginc"

            // Properties from Unity editor
float4 _Color;
float4 _AmbientColor;

struct appdata
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
};

struct v2f
{
    float4 pos : SV_POSITION;
    float3 worldNormal : TEXCOORD0;
};

            // Vertex Shader
v2f vert(appdata v)
{
    v2f o;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.worldNormal = UnityObjectToWorldNormal(v.normal);
    return o;
}

            // Fragment Shader
fixed4 frag(v2f i) : SV_Target
{
                // Normalize the world normal
    float3 normal = normalize(i.worldNormal);

                // Calculate ambient lighting
    float3 ambient = _AmbientColor.rgb;

                // Combine base color with ambient lighting
    float3 finalColor = _Color.rgb * ambient;

    return float4(finalColor, _Color.a);
}
            ENDCG
        }
    }
FallBack"Diffuse"
}
