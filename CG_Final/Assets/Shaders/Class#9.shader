Shader "Custom/Class#9"
{
    SubShader
    {
      Pass
      {
          CGPROGRAM
          #pragma vertex vert
          #pragma fragment frag

          #include "UnityCG.cginc"

          struct appdata
          {
              float4 vertex : POSITION;
          };

          struct v2f
          {
             float4 vertex : SV_POSITION;
              float4 color : COLOR;
          };

          v2f vert (appdata v)
          {
               v2f o;
              UNITY_INITIALIZE_OUTPUT(v2f,o)
              o.vertex = UnityObjectToClipPos(v.vertex);

              //color effecting each vertex
             o.color.r = (v.vertex.y + 5)/10;
             o.color.g = (v.vertex.y + 5)/10;
             o.color.g = (v.vertex.x + 5)/10;
              return o;
          }
          fixed4 frag (v2f i) : SV_Target
          {
              
              fixed4 col = i.color;

              //this effects each pixel and will change with movement
              //col.r = i.vertex.x/1000
              
              return col;
          }
        ENDCG
     }
    }
    FallBack "Diffuse"
}
