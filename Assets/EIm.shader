Shader "Custom/EIm"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _RimColor ("Rim Color", Color) = (1,1,1,1) // Warna Rim
        _RimPower ("Rim Power", Range(1.0, 8.0)) = 3.0 // Intensitas Rim
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;
        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        fixed4 _RimColor; // Warna Rim
        float _RimPower; // Intensitas Rim

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir; // Arah pandang dari kamera
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;

            // Rim Lighting Effect
            float rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal)); // Hitung rim effect berdasarkan arah pandang
            o.Emission = _RimColor.rgb * pow(rim, _RimPower); // Menerapkan efek rim dengan warna dan intensitas
        }
        ENDCG
    }
    FallBack "Diffuse"
}
