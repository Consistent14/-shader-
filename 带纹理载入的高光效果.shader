Shader"Custom/带纹理载入的高光效果"
{
	Properties
	{
		_MainTex("Base(RGB)" , 2D) = "white" {}

		_Color("Main Color" , Color) =  (1, 1, 1, 1)

		_SpecColor("Specular Color", Color) = (1, 1, 1, 1)

		_SpecShininess("Specular Shininess", Range(1.0, 100.0)) = 10.0
	}
	SubShader
	{
		Tags{"RenderType"="Opaque"}
		Pass
		{
			Tags {"LIGHTMODE"="ForwardBase"}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			//#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _Color;
			float4 _SpecColor;
			float _SpecShininess;
			float4 _LightColor0;

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normalWorld : NORMAL;
				float2 texcoord :TEXCOORD0;
				float4 posWorld : TEXCOORD1;
			};

			v2f vert(appdata t) 
			{
				v2f o;
				o.pos = UnityObjectToClipPos(t.vertex);
				o.normalWorld = mul(float4(t.normal, 0.0), unity_WorldToObject).xyz;
				o.texcoord = t.texcoord;
				o.posWorld = mul(unity_ObjectToWorld,t.vertex);
				return o;
			}

			float4 frag(v2f v) : COLOR
			{
				//纹理采样
				float4 texColor = tex2D(_MainTex, v.texcoord);
				//法线方向
				float3 normalDirection = normalize(v.normalWorld);
				//入射光线方向
				float3 lightDirection = normalize(-_WorldSpaceLightPos0.xyz);
				//视角方向
				float3 viewDirection = normalize(_WorldSpaceCameraPos - v.posWorld.xyz);

				float3 diffuse = _LightColor0.rgb * _Color.rgb * max(0,dot(normalDirection,lightDirection));

				float3 specular;
				if(dot(normalDirection,lightDirection) < 0.0)
				{
					specular = float3(0.0, 0.0, 0.0);
				}
				else
				{
					float3 reflectDirection = reflect(normalDirection,lightDirection);
					specular = _LightColor0.rgb * _SpecColor.rgb * pow(max(0, dot(viewDirection, reflectDirection)), _SpecShininess);
				}
				float4 diffuseSpecularAmbient = float4(diffuse, 1.0) + float4(specular, 1.0) + UNITY_LIGHTMODEL_AMBIENT;

				return diffuseSpecularAmbient * texColor;
			}
			ENDCG
		}
	}
}