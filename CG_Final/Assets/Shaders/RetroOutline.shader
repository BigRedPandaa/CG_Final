Shader "Custom/RetroOutline"
{
   Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DarknessColor ("Darkness Color", Color) = (0,0,0.18,.24)
	}
  
	SubShader
	{
		Tags {"Queue"="Transparent" "RenderType"="Transparent"}
		ZWrite Off
		Cull Off
		Blend One OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
      			float4 _DarknessColor;

			fixed4 frag (v2f i) : SV_Target
			{
				float4 color = _DarknessColor;
				float4 textureColor = tex2D(_MainTex, i.uv);
				color.a = 1 - textureColor.r;
				color.rgb *= color.a;
				return color;
			}
			ENDCG
		}
	}
}
