Lights1 za2_checkpoint_Fast3D_Material_003_lights = gdSPDefLights1(
	0x1F, 0x1F, 0x1F,
	0x47, 0x47, 0x47, 0x28, 0x28, 0x28);

Lights1 za2_checkpoint_Fast3D_Material_001_lights = gdSPDefLights1(
	0x44, 0x44, 0x44,
	0x8D, 0x8D, 0x8D, 0x28, 0x28, 0x28);

Lights1 za2_checkpoint_Fast3D_Material_002_lights = gdSPDefLights1(
	0x7F, 0x4, 0x0,
	0xFF, 0x10, 0x0, 0x28, 0x28, 0x28);

Lights1 za2_checkpoint_Fast3D_Material_lights = gdSPDefLights1(
	0x7F, 0x7E, 0x0,
	0xFF, 0xFD, 0x0, 0x28, 0x28, 0x28);

Vtx za2_checkpoint_Cylinder_mesh_layer_1_vtx_cull[8] = {
	{{ {-56, 0, 65}, 0, {0, 0}, {0, 0, 0, 0} }},
	{{ {-56, 232, 65}, 0, {0, 0}, {0, 0, 0, 0} }},
	{{ {-56, 232, -129}, 0, {0, 0}, {0, 0, 0, 0} }},
	{{ {-56, 0, -129}, 0, {0, 0}, {0, 0, 0, 0} }},
	{{ {56, 0, 65}, 0, {0, 0}, {0, 0, 0, 0} }},
	{{ {56, 232, 65}, 0, {0, 0}, {0, 0, 0, 0} }},
	{{ {56, 232, -129}, 0, {0, 0}, {0, 0, 0, 0} }},
	{{ {56, 0, -129}, 0, {0, 0}, {0, 0, 0, 0} }},
};

Vtx za2_checkpoint_Cylinder_mesh_layer_1_vtx_0[26] = {
	{{ {0, 0, -65}, 0, {1008, 496}, {0, 179, 155, 255} }},
	{{ {0, 28, -65}, 0, {1008, -16}, {0, 77, 155, 255} }},
	{{ {56, 28, -32}, 0, {837, -16}, {87, 77, 206, 255} }},
	{{ {56, 0, -32}, 0, {837, 496}, {87, 179, 206, 255} }},
	{{ {56, 28, 32}, 0, {667, -16}, {87, 77, 50, 255} }},
	{{ {56, 0, 32}, 0, {667, 496}, {87, 179, 50, 255} }},
	{{ {0, 28, 65}, 0, {496, -16}, {0, 77, 101, 255} }},
	{{ {0, 0, 65}, 0, {496, 496}, {0, 179, 101, 255} }},
	{{ {-56, 28, 32}, 0, {325, -16}, {169, 77, 50, 255} }},
	{{ {-56, 0, 32}, 0, {325, 496}, {169, 179, 50, 255} }},
	{{ {-56, 28, -32}, 0, {155, -16}, {169, 77, 206, 255} }},
	{{ {-56, 0, -32}, 0, {155, 496}, {169, 179, 206, 255} }},
	{{ {0, 28, -65}, 0, {-16, -16}, {0, 77, 155, 255} }},
	{{ {0, 0, -65}, 0, {-16, 496}, {0, 179, 155, 255} }},
	{{ {56, 28, 32}, 0, {453, 875}, {87, 77, 50, 255} }},
	{{ {56, 28, -32}, 0, {453, 629}, {87, 77, 206, 255} }},
	{{ {0, 28, -65}, 0, {240, 506}, {0, 77, 155, 255} }},
	{{ {-56, 28, 32}, 0, {27, 875}, {169, 77, 50, 255} }},
	{{ {-56, 28, -32}, 0, {27, 629}, {169, 77, 206, 255} }},
	{{ {0, 28, 65}, 0, {240, 998}, {0, 77, 101, 255} }},
	{{ {-56, 0, -32}, 0, {539, 629}, {169, 179, 206, 255} }},
	{{ {0, 0, -65}, 0, {752, 506}, {0, 179, 155, 255} }},
	{{ {56, 0, -32}, 0, {965, 629}, {87, 179, 206, 255} }},
	{{ {0, 0, 65}, 0, {752, 998}, {0, 179, 101, 255} }},
	{{ {56, 0, 32}, 0, {965, 875}, {87, 179, 50, 255} }},
	{{ {-56, 0, 32}, 0, {539, 875}, {169, 179, 50, 255} }},
};

Gfx za2_checkpoint_Cylinder_mesh_layer_1_tri_0[] = {
	gsSPVertex(za2_checkpoint_Cylinder_mesh_layer_1_vtx_0 + 0, 26, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(3, 2, 4, 0, 3, 4, 5, 0),
	gsSP2Triangles(5, 4, 6, 0, 5, 6, 7, 0),
	gsSP2Triangles(7, 6, 8, 0, 7, 8, 9, 0),
	gsSP2Triangles(9, 8, 10, 0, 9, 10, 11, 0),
	gsSP2Triangles(11, 10, 12, 0, 11, 12, 13, 0),
	gsSP2Triangles(14, 15, 16, 0, 16, 17, 14, 0),
	gsSP2Triangles(16, 18, 17, 0, 17, 19, 14, 0),
	gsSP2Triangles(20, 21, 22, 0, 22, 23, 20, 0),
	gsSP2Triangles(22, 24, 23, 0, 23, 25, 20, 0),
	gsSPEndDisplayList(),
};

Vtx za2_checkpoint_Cylinder_mesh_layer_1_vtx_1[26] = {
	{{ {0, 23, -9}, 0, {752, 506}, {0, 183, 152, 255} }},
	{{ {10, 23, 9}, 0, {965, 875}, {91, 187, 56, 255} }},
	{{ {-10, 23, 9}, 0, {539, 875}, {165, 187, 56, 255} }},
	{{ {10, 203, 43}, 0, {453, 875}, {92, 48, 74, 255} }},
	{{ {0, 209, 26}, 0, {240, 506}, {0, 103, 181, 255} }},
	{{ {-10, 203, 43}, 0, {27, 875}, {164, 48, 74, 255} }},
	{{ {-10, 23, 9}, 0, {325, 496}, {165, 187, 56, 255} }},
	{{ {0, 65, -11}, 0, {-16, -16}, {0, 6, 129, 255} }},
	{{ {0, 23, -9}, 0, {-16, 496}, {0, 183, 152, 255} }},
	{{ {-10, 65, 7}, 0, {325, -16}, {143, 253, 58, 255} }},
	{{ {10, 23, 9}, 0, {667, 496}, {91, 187, 56, 255} }},
	{{ {10, 65, 7}, 0, {667, -16}, {113, 253, 58, 255} }},
	{{ {0, 23, -9}, 0, {1008, 496}, {0, 183, 152, 255} }},
	{{ {0, 65, -11}, 0, {1008, -16}, {0, 6, 129, 255} }},
	{{ {0, 116, -3}, 0, {1008, -16}, {0, 26, 132, 255} }},
	{{ {10, 113, 14}, 0, {667, -16}, {112, 243, 59, 255} }},
	{{ {0, 165, 10}, 0, {1008, -16}, {0, 38, 135, 255} }},
	{{ {10, 159, 26}, 0, {667, -16}, {111, 238, 58, 255} }},
	{{ {0, 209, 26}, 0, {1008, -16}, {0, 103, 181, 255} }},
	{{ {10, 203, 43}, 0, {667, -16}, {92, 48, 74, 255} }},
	{{ {-10, 159, 26}, 0, {325, -16}, {145, 238, 58, 255} }},
	{{ {-10, 203, 43}, 0, {325, -16}, {164, 48, 74, 255} }},
	{{ {0, 165, 10}, 0, {-16, -16}, {0, 38, 135, 255} }},
	{{ {0, 209, 26}, 0, {-16, -16}, {0, 103, 181, 255} }},
	{{ {0, 116, -3}, 0, {-16, -16}, {0, 26, 132, 255} }},
	{{ {-10, 113, 14}, 0, {325, -16}, {144, 243, 59, 255} }},
};

Gfx za2_checkpoint_Cylinder_mesh_layer_1_tri_1[] = {
	gsSPVertex(za2_checkpoint_Cylinder_mesh_layer_1_vtx_1 + 0, 26, 0),
	gsSP2Triangles(0, 1, 2, 0, 3, 4, 5, 0),
	gsSP2Triangles(6, 7, 8, 0, 6, 9, 7, 0),
	gsSP2Triangles(10, 9, 6, 0, 10, 11, 9, 0),
	gsSP2Triangles(12, 11, 10, 0, 12, 13, 11, 0),
	gsSP2Triangles(11, 13, 14, 0, 11, 14, 15, 0),
	gsSP2Triangles(15, 14, 16, 0, 15, 16, 17, 0),
	gsSP2Triangles(17, 16, 18, 0, 17, 18, 19, 0),
	gsSP2Triangles(20, 17, 19, 0, 20, 19, 21, 0),
	gsSP2Triangles(22, 20, 21, 0, 22, 21, 23, 0),
	gsSP2Triangles(24, 20, 22, 0, 24, 25, 20, 0),
	gsSP2Triangles(7, 25, 24, 0, 7, 9, 25, 0),
	gsSP2Triangles(9, 15, 25, 0, 9, 11, 15, 0),
	gsSP2Triangles(25, 15, 17, 0, 25, 17, 20, 0),
	gsSPEndDisplayList(),
};

Vtx za2_checkpoint_Cylinder_mesh_layer_1_vtx_2[4] = {
	{{ {0, 202, 32}, 0, {-16, 1008}, {127, 0, 0, 255} }},
	{{ {0, 116, 10}, 0, {1008, 1008}, {127, 0, 0, 255} }},
	{{ {0, 144, -129}, 0, {1008, -16}, {127, 0, 0, 255} }},
	{{ {0, 232, -110}, 0, {-16, -16}, {127, 0, 0, 255} }},
};

Gfx za2_checkpoint_Cylinder_mesh_layer_1_tri_2[] = {
	gsSPVertex(za2_checkpoint_Cylinder_mesh_layer_1_vtx_2 + 0, 4, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSPEndDisplayList(),
};

Vtx za2_checkpoint_Cylinder_mesh_layer_1_vtx_3[22] = {
	{{ {0, 195, 38}, 0, {170, 1008}, {0, 129, 0, 255} }},
	{{ {11, 203, 46}, 0, {263, 847}, {92, 199, 67, 255} }},
	{{ {-4, 203, 51}, 0, {77, 847}, {221, 199, 108, 255} }},
	{{ {4, 217, 51}, 0, {170, 686}, {35, 57, 108, 255} }},
	{{ {14, 217, 38}, 0, {356, 686}, {114, 57, 0, 255} }},
	{{ {11, 203, 29}, 0, {449, 847}, {92, 199, 189, 255} }},
	{{ {0, 195, 38}, 0, {356, 1008}, {0, 129, 0, 255} }},
	{{ {4, 217, 24}, 0, {543, 686}, {35, 57, 148, 255} }},
	{{ {-4, 203, 24}, 0, {636, 847}, {221, 199, 148, 255} }},
	{{ {0, 195, 38}, 0, {543, 1008}, {0, 129, 0, 255} }},
	{{ {-11, 217, 29}, 0, {729, 686}, {164, 57, 189, 255} }},
	{{ {-14, 203, 38}, 0, {822, 847}, {142, 199, 0, 255} }},
	{{ {0, 195, 38}, 0, {729, 1008}, {0, 129, 0, 255} }},
	{{ {-11, 217, 46}, 0, {915, 686}, {164, 57, 67, 255} }},
	{{ {-4, 203, 51}, 0, {1008, 847}, {221, 199, 108, 255} }},
	{{ {0, 195, 38}, 0, {915, 1008}, {0, 129, 0, 255} }},
	{{ {0, 226, 38}, 0, {822, 524}, {0, 127, 0, 255} }},
	{{ {0, 226, 38}, 0, {263, 524}, {0, 127, 0, 255} }},
	{{ {0, 226, 38}, 0, {636, 524}, {0, 127, 0, 255} }},
	{{ {0, 226, 38}, 0, {449, 524}, {0, 127, 0, 255} }},
	{{ {-11, 217, 46}, 0, {-16, 686}, {164, 57, 67, 255} }},
	{{ {0, 226, 38}, 0, {77, 524}, {0, 127, 0, 255} }},
};

Gfx za2_checkpoint_Cylinder_mesh_layer_1_tri_3[] = {
	gsSPVertex(za2_checkpoint_Cylinder_mesh_layer_1_vtx_3 + 0, 22, 0),
	gsSP2Triangles(0, 1, 2, 0, 2, 1, 3, 0),
	gsSP2Triangles(1, 4, 3, 0, 1, 5, 4, 0),
	gsSP2Triangles(1, 6, 5, 0, 5, 7, 4, 0),
	gsSP2Triangles(5, 8, 7, 0, 9, 8, 5, 0),
	gsSP2Triangles(8, 10, 7, 0, 8, 11, 10, 0),
	gsSP2Triangles(12, 11, 8, 0, 11, 13, 10, 0),
	gsSP2Triangles(11, 14, 13, 0, 15, 14, 11, 0),
	gsSP2Triangles(10, 13, 16, 0, 3, 4, 17, 0),
	gsSP2Triangles(7, 10, 18, 0, 4, 7, 19, 0),
	gsSP2Triangles(2, 3, 20, 0, 20, 3, 21, 0),
	gsSPEndDisplayList(),
};


Gfx mat_za2_checkpoint_Fast3D_Material_003[] = {
	gsSPSetLights1(za2_checkpoint_Fast3D_Material_003_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsSPEndDisplayList(),
};

Gfx mat_revert_za2_checkpoint_Fast3D_Material_003[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_za2_checkpoint_Fast3D_Material_001[] = {
	gsSPSetLights1(za2_checkpoint_Fast3D_Material_001_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsSPEndDisplayList(),
};

Gfx mat_revert_za2_checkpoint_Fast3D_Material_001[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_za2_checkpoint_Fast3D_Material_002[] = {
	gsSPGeometryMode(G_CULL_BACK, 0),
	gsSPSetLights1(za2_checkpoint_Fast3D_Material_002_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsSPEndDisplayList(),
};

Gfx mat_revert_za2_checkpoint_Fast3D_Material_002[] = {
	gsSPGeometryMode(0, G_CULL_BACK),
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_za2_checkpoint_Fast3D_Material[] = {
	gsSPSetLights1(za2_checkpoint_Fast3D_Material_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsSPEndDisplayList(),
};

Gfx mat_revert_za2_checkpoint_Fast3D_Material[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx za2_checkpoint_Cylinder_mesh_layer_1[] = {
	gsSPClearGeometryMode(G_LIGHTING),
	gsSPVertex(za2_checkpoint_Cylinder_mesh_layer_1_vtx_cull + 0, 8, 0),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPCullDisplayList(0, 7),
	gsSPDisplayList(mat_za2_checkpoint_Fast3D_Material_003),
	gsSPDisplayList(za2_checkpoint_Cylinder_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_za2_checkpoint_Fast3D_Material_003),
	gsSPDisplayList(mat_za2_checkpoint_Fast3D_Material_001),
	gsSPDisplayList(za2_checkpoint_Cylinder_mesh_layer_1_tri_1),
	gsSPDisplayList(mat_revert_za2_checkpoint_Fast3D_Material_001),
	gsSPDisplayList(mat_za2_checkpoint_Fast3D_Material_002),
	gsSPDisplayList(za2_checkpoint_Cylinder_mesh_layer_1_tri_2),
	gsSPDisplayList(mat_revert_za2_checkpoint_Fast3D_Material_002),
	gsSPDisplayList(mat_za2_checkpoint_Fast3D_Material),
	gsSPDisplayList(za2_checkpoint_Cylinder_mesh_layer_1_tri_3),
	gsSPDisplayList(mat_revert_za2_checkpoint_Fast3D_Material),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

