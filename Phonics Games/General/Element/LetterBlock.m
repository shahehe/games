//
//  LetterBlock.m
//  Phonics Games
//
//  Created by yiplee on 14-4-1.
//  Copyright 2014年 yiplee. All rights reserved.
//

static char* fontFile = "Arial-Black.fnt";

#import "LetterBlock.h"
#import "CCNodeHelper.h"

#import "UtilsMacro.h"

@interface LetterBlock ()
{
    CCLabelBMFont *letterLabel;
}

@end

@implementation LetterBlock

+ (instancetype) blockWithSize:(CGSize)size letter:(char)letter
{
    return [[[self alloc] initWithSize:size letter:letter] autorelease];
}

+ (instancetype) blockWithFile:(NSString *)file letter:(char)letter
{
    return [[[self alloc] initWithFile:file letter:letter] autorelease];
}

- (id) initWithSize:(CGSize)size letter:(char)letter
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    self = [super initWithFile:@"blockTexture.png" rect:rect];
    
    ccTexParams params =
    {
        GL_LINEAR,
        GL_LINEAR,
        GL_REPEAT,
        GL_REPEAT
    };
    [self.texture setTexParameters:&params];
    
    [self setPhysics];
    [self setLetter:letter];
    
    return self;
}

- (id) initWithFile:(NSString *)file letter:(char)letter
{
    self = [super initWithFile:file];
    
    [self setPhysics];
    [self setLetter:letter];
    
    return self;
}

- (void) dealloc
{
    cpShapeFree(self.shape);
    cpBodyFree(self.CPBody);
    
    [super dealloc];
    
    SLLog(@"letterBlock:dealloc");
}

- (void) setLetter:(char)letter
{
    _letter = letter;
    
    if (!letterLabel)
    {
        NSString *font = [NSString stringWithUTF8String:fontFile];
        letterLabel = [CCLabelBMFont labelWithString:@" " fntFile:font];
        [self addChild:letterLabel];
        placeNodeCenterOfParent(letterLabel, self);
    }
    
    NSString *letterStr = [NSString stringWithFormat:@"%c",_letter];
    letterLabel.string = [letterStr uppercaseString];
}

- (void) setPhysics
{
    CGFloat width = self.contentSize.width;
    CGFloat height = self.contentSize.height;
    CGFloat mass = width * height;
    
    int num = 4;
    cpVect verts[] = {
        cpv(-width/2, -height/2),
        cpv(-width/2, height/2),
        cpv(width/2, height/2),
        cpv(width/2, height/2)
    };
    self.CPBody = cpBodyNew(mass, cpMomentForPoly(1.0f, num, verts, cpvzero));
    cpBodySetUserData(self.CPBody, self);
    
    _shape = cpPolyShapeNew(self.CPBody, num, verts, cpvzero);
    cpShapeSetElasticity(_shape, 0.5f );
	cpShapeSetFriction(_shape, 0.5f );
    cpShapeSetUserData(_shape, self);
}

- (void) addToSpace:(cpSpace *)space
{
    cpSpaceAddBody(space, self.CPBody);
    cpSpaceAddShape(space, self.shape);
}

- (void) removeFromSpace:(cpSpace *)space
{
    cpSpaceRemoveBody(space, self.CPBody);
    cpSpaceRemoveShape(space, self.shape);
}

@end
