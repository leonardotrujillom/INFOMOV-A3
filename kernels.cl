#define WIDTH 128
#define HEIGHT 48
#define N_FLAGS 1024

inline float sqrLength(const float2 v) { return dot(v, v); }
//inline float2 normalize(const float2 v) { float invLen = rsqrtf(dot(v, v)); return v * invLen; }
//// RNG - Marsaglia's xor32
//static uint seed = 0x12345678;
//uint RandomUInt()
//{
//	seed ^= seed << 13;
//	seed ^= seed >> 17;
//	seed ^= seed << 5;
//	return seed;
//}
//float RandomFloat() { return RandomUInt() * 2.3283064365387e-10f; }

__kernel void limitDistance(__global float2* pos) {
	int index = get_global_id( 0 );
	
	// move vertices
	//for (int x = 0; x < width; x++) for (int y = 0; y < height; y++)
	//{
	//	int index = x + y * width;
	//	float2 delta = pos[index] - prevPos[index];
	//	prevPos[index] = pos[index];
	//	pos[index] += delta;
	//}

	// apply forces
	//float windForce = 0.1f + 0.05f * RandomFloat();
	//float2 wind = windForce * normalize(make_float2(-1, (RandomFloat() * 0.5f) - 0.25f));
	////for (int x = 1; x < width; x++) for (int y = 0; y < height; y++)
	////{
	////	int index = x + y * width;
	//pos[index] += wind;
	//if ((RandomUInt() & 31) == 31)
	//{
	//	// small chance of a random nudge to add a bit of noise to the animation
	//	float2 nudge = make_float2(RandomFloat() - 0.5f, RandomFloat() - 0.5f);
	//	pos[index] += nudge;
	//}
	//}
	
	// constraints: limit distance
	//bool compact;
	for (int i = 0; i < 25; i++)
	{
		//compact = true;
		//for (int y = 0; y < height; y++)
		for (int x = 1; x < WIDTH; x++) 
		{
			if (index < x * N_FLAGS * HEIGHT || index >= (x + 1) * N_FLAGS * HEIGHT) return;

			float2 right = pos[index - N_FLAGS * HEIGHT] - pos[index];
			if (sqrLength(right) > 1.15f * 1.15f)
			{
				float2 excess = right - normalize(right) * 1.15f;
				pos[index] += excess * 0.5f;
				pos[index - 1] -= excess * 0.5f;
				//compact = false;
			}
		}

		//if (index >= N_FLAGS * HEIGHT) return;

		//int y = index % N_FLAGS;
		//pos[index] = polePos + make_float2(0, y * 1.2f);
		//if (compact) break;
	}
}