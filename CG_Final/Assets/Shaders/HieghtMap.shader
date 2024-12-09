Shader "Custom/HieghtMap"
{
    Properties
    {
        _BottomColor ("Bottom Color", Color) = (0, 1, 0, 1) // Green
        _MiddleColor ("Middle Color", Color) = (1, 1, 0, 1) // Yellow
        _TopColor ("Top Color", Color) = (1, 0, 0, 1) // Red
        _MinHeight ("Minimum Height", Float) = 0.0 // The minimum world height
        _MaxHeight ("Maximum Height", Float) = 5.0 // The maximum world height
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

struct appdata
{
    float4 vertex : POSITION;
};

struct v2f
{
    float4 pos : SV_POSITION;
    float worldY : TEXCOORD0;
};

float _MinHeight;
float _MaxHeight;
float4 _BottomColor;
float4 _MiddleColor;
float4 _TopColor;

v2f vert(appdata v)
{
    v2f o;
    o.pos = UnityObjectToClipPos(v.vertex);
                
                // Get the world-space position of the vertex
    float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                
                // Store the world y-coordinate in the output
    o.worldY = worldPos.y;
                
    return o;
}

fixed4 frag(v2f i) : SV_Target
{
                // Normalize height between 0 and 1 based on the range [_MinHeight, _MaxHeight]
    float height = saturate((i.worldY - _MinHeight) / (_MaxHeight - _MinHeight));

                // Interpolate colors based on height
    fixed4 color;
    if (height < 0.5)
    {
                    // Blend from bottom to middle
        color = lerp(_BottomColor, _MiddleColor, height * 2.0);
    }
    else
    {
                    // Blend from middle to top
        color = lerp(_MiddleColor, _TopColor, (height - 0.5) * 2.0);
    }

    return color;
}
            ENDCG
        }
    }
FallBack"Diffuse"
}
