//
//  PGGameListMenu.m
//  Phonics Games
//
//  Created by yiplee on 14-4-7.
//  Copyright 2014年 yiplee. All rights reserved.
//

#import "PGGameListMenu.h"
#import "UtilsMacro.h"

#import "PGLearnWord.h"
#import "PGSearchWord.h"
#import "CardMatching.h"
#import "BubbleGameLayer.h"

#import "PGStageMenu.h"
#import "LoadingLayer.h"

#import "PGManager.h"

@interface PGGameListMenu ()
{
    
}

@property (nonatomic,readonly) char letter;
@property (nonatomic,copy) NSArray *words;

@end

@implementation PGGameListMenu

+ (CCScene *) menuWithLetter:(char)letter
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [[[[self class] alloc] initWithLetter:letter] autorelease];
    [scene addChild:layer];
    return scene;
}

- (id) initWithLetter:(char)letter
{
    self = [super init];
    
    _letter = letter;
    
    self.words = [[PGManager sharedManager] wordsForLetter:self.letter];
    
    RGBA4444
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu_letter_list.plist"];
    
    RGB565
    CCSprite *bg = [CCSprite spriteWithFile:@"menu_farm_bg.pvr.ccz"];
    PIXEL_FORMAT_DEFAULT
    
    bg.position = CCMP(0.5, 0.5);
    bg.scaleX = SCREEN_WIDTH / bg.contentSize.width;
    bg.scaleY = SCREEN_HEIGHT/ bg.contentSize.height;
    [self addChild:bg z:0];
    
    CCMenuItemImage* backButton = [CCMenuItemImage itemWithNormalImage:@"back_button_N.png" selectedImage:@"back_button_P.png" block:^(id sender){
        [[CCDirector sharedDirector] popScene];
    }];

    backButton.position = CCMP(0.1, 0.9);
    
    CCMenu *menu = [CCMenu menuWithItems:backButton, nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
    @autoreleasepool { // game menu
        CCSprite *panel = [CCSprite spriteWithSpriteFrameName:@"menu_panel"];
        panel.position = CCMP(0.5,0.5);
        [self addChild:panel];
        
        NSArray *itemNames = @[@"Learn Word",@"Search Word",@"Card Match",@"Bubble",@"Easy",@"Normal",@"Hard"];
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:itemNames.count];
        
        for (NSString *name in itemNames)
        {
            CCLabelTTF *label = [CCLabelTTF labelWithString:name fontName:@"Avenir-BlackOblique" fontSize:20*CC_CONTENT_SCALE_FACTOR()];
            label.color = ccWHITE;
            [items addObject:[self buttonWithNode:label]];
        }
        
        
    }

    return self;
}

- (void) onEnter
{
    [super onEnter];
    
}

- (void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
}

- (CCMenuItemSprite*) buttonWithNode:(CCNode*)node
{
    CCSprite *N = [CCSprite spriteWithSpriteFrameName:@"menu_button_N"];
    CCSprite *P = [CCSprite spriteWithSpriteFrameName:@"menu_button_P"];
    
    CCMenuItemSprite *item = [CCMenuItemSprite itemWithNormalSprite:N selectedSprite:P];
    
    CGPoint p = ccpFromSize(item.boundingBox.size);
    node.position = ccpMult(p, 0.5);
    [item addChild:node];
    
    return item;
}

- (void) dealloc
{
    NSLog(@"game list : dealloc");
    [super dealloc];
    
    [_words release];
}

@end
