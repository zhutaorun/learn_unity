﻿Shader "Custom/cg_mirror" {
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_ReflectionTex ("", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
 
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 refl : TEXCOORD1;
				float4 pos : SV_POSITION;
			};
			float4 _MainTex_ST;
			v2f vert(float4 pos : POSITION, float2 uv : TEXCOORD0)
			{
				v2f o;
				o.pos = mul (UNITY_MATRIX_MVP, pos);
				o.uv = TRANSFORM_TEX(uv, _MainTex);
				o.refl = ComputeScreenPos (o.pos);
				return o;
			}
			sampler2D _MainTex;
			sampler2D _ReflectionTex;
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 tex = tex2D(_MainTex, i.uv);
				fixed4 refl = tex2Dproj(_ReflectionTex, UNITY_PROJ_COORD(i.refl));
				return tex * .4 + refl * .6;
			}
			ENDCG
	    }
	}
}
