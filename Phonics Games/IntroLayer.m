//
//  IntroLayer.m
//  Phonics Games
//
//  Created by yiplee on 14-3-31.
//  Copyright yiplee 2014年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"

#import "UtilsMacro.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
	// return the scene
	return scene;
}

//
-(id) init
{
	if( (self=[super init])) {
        CCFontDefinition *font = [[CCFontDefinition alloc] initWithFontName:@"HoeflerText-BlackItalic" fontSize:48];
        CCLabelTTF *welcome = [CCLabelTTF labelWithString:@"Phonics Games" fontDefinition:font];
		welcome.position = CMP(0.5);
        [self addChild:welcome];
        
        SLLogString(@"hello world");
        SLLogPoint(SCREEN_SIZE_P);
	}
	
	return self;
}

-(void) onEnter
{
	[super onEnter];
}
@end
