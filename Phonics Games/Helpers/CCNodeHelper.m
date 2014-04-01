//
//  CCNodeHelper.m
//  Phonics Games
//
//  Created by yiplee on 14-4-1.
//  Copyright (c) 2014年 yiplee. All rights reserved.
//

#import "CCNodeHelper.h"
#import "UtilsMacro.h"

void placeNodeCenterOfParent(CCNode *node,CCNode *parent)
{
    CGPoint size_p = ccpFromSize(parent.boundingBox.size);
    node.position = ccpMult(size_p, 0.5);
}