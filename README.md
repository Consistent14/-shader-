# -shader-
//1、一个是模拟入射光，在模型上观察入射光角度对光照效果的影响；
Shader"Custom/简单模拟光照"
{
	Properties
	{
		_Color ("Light Color", Color) = (1, 1, 1, 1)
		_Dir ("Light Dir", Vector) = (0, 0, 1, 0)
		_Intensity("Instensity", float) = 1.0
	}
	SubShader
	{
		Tags {"RenderType"="Opaque"}
		LOD 100
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			fixed4 _Color;
			fixed4 _Dir;
			float _Intensity;

			v2f vert(appdata_base v)
			{
				v2f o;
				o.vertex =UnityObjectToClipPos(v.vertex);
				o.normal = v.normal;
				return o;
			}

			fixed4 frag(v2f v) : COLOR
			{
				fixed3 dir = (_Dir).xyz;
				dir = normalize(dir);
				fixed3 nrm = normalize(v.normal);
				float bis = dot(dir, nrm);
				if(bis <= 0)
				{
					bis = 0;
				}
				fixed4 col = _Color * bis * _Intensity;
				return col;
			}
			ENDCG
		}
	}
}
