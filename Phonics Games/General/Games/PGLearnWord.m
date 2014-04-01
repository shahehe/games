//
//  PGLearnWord.m
//  Phonics Games
//
//  Created by yiplee on 14-4-1.
//  Copyright 2014年 yiplee. All rights reserved.
//

enum Z_LAYERS {
	Z_BACKGROUND = -1,
	Z_BLOCKS,
	Z_PHYSICS_DEBUG,
	Z_MENU,
};

static const cpLayers PhysicsBlockBit = 1<<31;

// These are the layer bitmasks used for bubble and edges.
static const cpLayers PhysicsEdgeLayers = ~PhysicsBlockBit;
static const cpLayers PhysicsBlockLayers = CP_ALL_LAYERS;


#import "PGLearnWord.h"

#import "UtilsMacro.h"
#import "LetterBlock.h"

#import "chipmunk.h"

@interface PGLearnWord ()
{
    cpSpace *_space;
    cpShape *_walls[4];
}

@end

@implementation PGLearnWord

+ (CCScene *) scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [[self class] node];
    [scene addChild:layer];
    return scene;
}

- (id) init
{
    self = [super init];
    
    _space = cpSpaceNew();
    cpSpaceSetGravity(_space, cpv(0, -250.0f));

    //wall
    {
        cpFloat radius = 5.f;
        
        // four corner
        cpVect leftDown = cpv(0, 50);
        cpVect leftUp = cpv(0,SCREEN_SIZE.height + 100);
        cpVect rightDown = cpv(SCREEN_SIZE.width, 50);
        cpVect rightUp = cpv(SCREEN_SIZE.width, SCREEN_SIZE.height+100);
        
        cpBody *groundBody = cpBodyNewStatic();
        
        _walls[0] = cpSegmentShapeNew( groundBody, leftDown, leftUp, radius);
        _walls[1] = cpSegmentShapeNew( groundBody, leftUp, rightUp, radius);
        _walls[2] = cpSegmentShapeNew( groundBody, rightUp, rightDown, radius);
        _walls[3] = cpSegmentShapeNew( groundBody, rightDown,leftDown, radius);
        
        for( int i=0;i<4;i++) {
            cpShapeSetElasticity(_walls[i], 1.0f );
            cpShapeSetFriction(_walls[i], 1.0f );
            cpShapeSetLayers(_walls[i], PhysicsEdgeLayers);
            cpSpaceAddStaticShape(_space, _walls[i]);
        }
    }
    
    // set debug draw
    CCPhysicsDebugNode *debugNode = [CCPhysicsDebugNode debugNodeForCPSpace:_space];
//    debugNode.visible = NO;
    [self addChild:debugNode z:Z_PHYSICS_DEBUG];
    
    [self scheduleUpdate];
    
    return self;
}

- (void) dealloc
{
    for( int i=0;i<4;i++) {
		cpShapeFree( _walls[i] );
	}
    
    cpSpaceFree(_space);
    
    [super dealloc];
}

- (void) onEnter
{
    [super onEnter];
    
    LetterBlock *block = [LetterBlock blockWithSize:CGSizeMake(50, 50) letter:'A'];
    [self addChild:block z:Z_BLOCKS];
    cpShapeSetLayers(block.shape, PhysicsBlockLayers);
    [block addToSpace:_space];
    
    block.position = CCMP(0.5, 0.9);
    block.color = ccGREEN;
//    block.visible = NO;
}

- (void) update:(ccTime)delta
{
    int steps = 2;
	CGFloat dt = [[CCDirector sharedDirector] animationInterval]/(CGFloat)steps;
    
	for(int i=0; i<steps; i++){
		cpSpaceStep(_space, dt);
	}
}

@end
