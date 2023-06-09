Shader "Fractal/Mandelbrot"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Zoom ("Zoom", Vector) = (1, 1, 1, 1)
        _Pan("Pan", Vector) = (1, 1, 1, 1)
        _Aspect("Aspect", Float) = 1
        _Iterations("Iterations", Range(1, 64)) = 32
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

       
        fixed4 _Color;
        float _Iterations;
        float _Aspect;
        float4 _Zoom;
        float4 _Pan;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            //fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            float2 c = (IN.uv_MainTex - 0.5) * _Zoom.xy * float2(1, _Aspect) - _Pan.xy;

            float2 v = 0;
            float m = 0;

            const float r = 5;
            float4 color;

            for (int n = 0; n < _Iterations; n++)
            {
                v = float2(v.x * v.x - v.y * v.y, v.x * v.y * 2) + c;

                if (dot(v, v) < (r * r - 1))
                    m++;

                v = clamp(v, -r, r);
                
                if (m == floor(_Iterations))
                    color = float4(0, 0, 0, 1);
                else
                    color = float4(sin(m / 4), sin(m / 5), sin(m / 7), 1) / 4 + 0.75;
            
            }
            o.Albedo = color;
            //o.Emission = color;
            // Metallic and smoothness come from slider variables
          
            o.Alpha = color.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
