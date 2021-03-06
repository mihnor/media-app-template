﻿// Copyright 2017 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

Shader "GoogleVR/Demos/Daydream Elements/Scrolling Vert Color Alpha Detail"
{
  Properties 
  {
    _MainTex ("Main Texture (A)", 2D) = "" {}
    _Noise ("Scrolling Noise (A)", 2D) = "" {}
    _ShimmerSpeed ("Scrolling Noise Speed", Float) = 0.025
  }
  SubShader 
  {
    Tags{ "RenderType" = "Opaque" }
    LOD 100
    Pass
    {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #include "UnityCG.cginc"

      struct appdata
      {
        float4 vertex : POSITION;
        half4 color : COLOR;
        float3 normal : NORMAL;
        float4 uv : TEXCOORD0;
      };

      struct v2f
      {
        float4 vertex : SV_POSITION;
        float4 uv : TEXCOORD0;
        half4 color : COLOR;
      };

      sampler2D _MainTex;
      float4 _MainTex_ST;
      sampler2D _Noise;
      float4 _Noise_ST;
      half _ShimmerSpeed;

      v2f vert(appdata v)
      {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);

        float2 noiseOffset = _Time.y * _ShimmerSpeed;

        o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
        o.uv.zw = TRANSFORM_TEX(v.uv, _Noise) + noiseOffset;

        o.color = v.color;

        return o;
      }

      half4 frag(v2f i) : SV_Target
      {
        half alpha = tex2D(_MainTex, i.uv.xy).a;
        half noise = tex2D(_Noise, i.uv.zw).a;
        half4 col = i.color + (alpha * noise);
        return col;
      }
    ENDCG
    }
  }
}
