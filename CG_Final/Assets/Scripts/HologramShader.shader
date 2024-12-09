Shader "Custom/HologramShader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Color ("Tint Color", Color) = (0.1, 0.6, 1, 1)
        _RimColor ("Rim Color", Color) = (0.2, 0.7, 1, 1)
        _RimPower ("Rim Power", Range(1, 10)) = 3
        _ScanlineSpeed ("Scanline Speed", Float) = 1.0
        _DissolveThreshold ("Dissolve Threshold", Range(0,1)) = 0.5
        _NoiseTex ("Noise Texture", 2D) = "white" {}
        _Emission ("Emission", Float) = 1.0
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            sampler2D _NoiseTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _RimColor;
            float _RimPower;
            float _ScanlineSpeed;
            float _DissolveThreshold;
            float _Emission;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // Base texture
                half4 texColor = tex2D(_MainTex, i.uv) * _Color;

                // Scanline effect
                float scanline = sin((i.worldPos.y + _Time.y * _ScanlineSpeed) * 10.0);
                texColor.rgb += scanline * 0.1;

                // Rim lighting
                float rim = 1.0 - saturate(dot(i.worldNormal, normalize(i.worldPos)));
                half4 rimColor = _RimColor * pow(rim, _RimPower);

                // Dissolve effect
                float noise = tex2D(_NoiseTex, i.uv * 5.0).r;
                if (noise < _DissolveThreshold)
                {
                    discard;
                }

                // Combine effects
                texColor += rimColor;
                texColor *= _Emission;
                texColor.a = 0.5; // Semi-transparent

                return texColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
