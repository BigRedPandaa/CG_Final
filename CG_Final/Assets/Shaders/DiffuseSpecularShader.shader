Shader"Custom/SpecularShader" {
    Properties {
        _Color ("Diffuse Color", Color) = (1,1,1,1)
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _Shininess ("Shininess", Range(0.1, 100)) = 20.0
        _MainTex ("Base Texture", 2D) = "white" {}
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 300

                CGPROGRAM
                #pragma surface surf BlinnPhong

        sampler2D _MainTex;
        float4 _Color;
        float4 _SpecColor2;
        float _Shininess;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            float4 tex = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = tex.rgb * _Color.rgb; // Diffuse base color
            o.Specular = _SpecColor2.a; // Specular color alpha
            o.Gloss = _Shininess; // Shininess controls gloss
        }
                ENDCG
    }
FallBack"Specular"
}