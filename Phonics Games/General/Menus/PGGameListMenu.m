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

#import "PGStageMenu.h"

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
    
    NSArray *w = @[@"CAT",@"MAT",@"ADD",@"BAG",@"BAT",@"DAM"];
    
    NSString *font = @"Avenir-BlackOblique";
    NSString *l = [NSString stringWithFormat:@"%c",letter];
    CCLabelTTF *title = [CCLabelTTF labelWithString:l fontName:font fontSize:64];
    title.color = ccWHITE;
    title.position = CCMP(0.5, 0.8);
    [self addChild:title];
    
    [CCMenuItemFont setFontName:font];
    
    CCMenuItemFont *learnWord = [CCMenuItemFont itemWithString:@"Learn Word" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[PGLearnWord gameWithWords:w]];
    }];
    learnWord.color = ccWHITE;
    
    CCMenuItemFont *searchWord = [CCMenuItemFont itemWithString:@"Search Word" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[PGSearchWord gameWithWords:w panelSize:CGSizeMake(630, 720) gridSize:CGSizeMake(90, 90)]];
    }];
    searchWord.color = ccWHITE;
    
    CCMenuItemFont *cardMatch = [CCMenuItemFont itemWithString:@"Card Match" block:^(id sender) {
        
    }];
    cardMatch.isEnabled = NO;
    cardMatch.color = ccWHITE;
    
    CCMenuItemFont *bubble = [CCMenuItemFont itemWithString:@"Bubble" block:^(id sender) {
        
    }];
    bubble.color = ccWHITE;
    bubble.isEnabled = NO;
    
    CCMenuItemFont *back = [CCMenuItemFont itemWithString:@"BACK" block:^(id sender) {
        [[CCDirector sharedDirector] replaceScene:[PGStageMenu stageMenu]];
    }];
    back.color = ccYELLOW;
    
    CCMenu *menu = [CCMenu menuWithItems:learnWord,searchWord,cardMatch,bubble,back, nil];
    [menu alignItemsVerticallyWithPadding:20];
    menu.position = CMP(0.5);
    [self addChild:menu];
    
    return self;
}

@end
