//
//  TOShaderTypes.h
//  MetalDemo
//
//  Created by 赵福成 on 2019/5/3.
//  Copyright © 2019 zhaofucheng. All rights reserved.
//

#ifndef TOShaderTypes_h
#define TOShaderTypes_h

#include <simd/simd.h>
typedef enum YLZVertexInputIndex
{
    YLZVertexInputIndexVertices = 0,
    YLZVertexInputIndexCount    = 1,
} YLZVertexInputIndex;

typedef struct
{
    vector_float2 position;
    vector_float4 color;
} YLZVertex;

#endif /* TOShaderTypes_h */
