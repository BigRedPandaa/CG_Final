Shader "Custom/WaterShader"
{
    Properties
    {
        _MainTex("Albedo (RGB)", 2D) = "white" {}
        _Tint("Colour Tint", Color) = (1,1,1,1)
        _Freq("Frequency", Range(0,5)) = 3
        _Speed("Speed", Range(0,100)) = 10
        _Amp("Amplitude", Range(0,1)) = 0.5
        
        _ScrollX ("Scroll x", Range(-5,5)) = 1
        _ScrollY ("Scroll Y", Range(-5,5)) = 1
        
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _BumpScale("Normal Map Intensity", Float) = 1.0
        _Color ("Base Color", Color) = (0.5,0.5,0.5,1)
    }
    SubShader
    {
        
            CGPROGRAM
            #pragma surface surf Lambert vertex:vert
            #pragma vertex vert
            
            #include "UnityCG.cginc"
            #include <Lighting.cginc>
            
            float _ScrollX;
            float _ScrollY;

            sampler2D _MainTex;
            
            struct Input
            {
              float2 uv_MainTex;
              float3 vertColor;  
            };

            float4 _Tint;
            float _Freq;
            float _Speed;
            float _Amp;

            struct appdata
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float4 texcoord: TEXCOORD0;
                float4 texcoord1: TEXCOORD1;
                float4 texcoord2: TEXCOORD2;
            };

            struct v2f
            {
                float4 pos : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            void vert (inout appdata v, out Input o)
            {
                UNITY_INITIALIZE_OUTPUT(Input,o);
                float t = _Time * _Speed;
                float waveHeight = sin(t + v.vertex.x * _Freq) * _Amp + sin (t*2 + v.vertex.x * _Freq *2) * _Amp;
                v.vertex.y = v.vertex.y + waveHeight;
                v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
                o.vertColor = waveHeight + 2;
            }
            
            sampler2D _MainTexWater;
     
            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = v.normal;
                o.uv = v.texcoord;
                return o;
            }
            
            
            void surf (Input IN, inout SurfaceOutput o)
            {
                _ScrollX *= _Time;
                _ScrollY *= _Time;
                
                float4 c = tex2D(_MainTexWater, IN.uv_MainTex);
                float2 newuv = IN.uv_MainTex + float2(_ScrollX,_ScrollY);
                o.Albedo = c * IN.vertColor.rgb;
                o.Albedo = tex2D (_MainTex, newuv);
            }
            ENDCG 
        
    }
      FallBack "Diffuse"
}


