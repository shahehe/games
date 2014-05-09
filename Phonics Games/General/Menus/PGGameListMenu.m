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
        
        CGPoint startPos = ccp(0.30, 0.70);
        CGPoint offset   = ccp(0.43, -0.25);
        CGPoint p_size   = ccpFromSize(panel.boundingBox.size);

        [itemNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *name = obj;
            CCLabelTTF *label = [CCLabelTTF labelWithString:name fontName:@"Avenir-BlackOblique" fontSize:20*CC_CONTENT_SCALE_FACTOR()];
            if (idx <= 3)
            {
                label.color = ccWHITE;
            }
            else
            {
                label.color = ccMAGENTA;
            }
            
            CCMenuItem *item = [self buttonWithNode:label];
            
            int x = idx % 2;
            int y = idx / 2;
            item.position = ccpCompMult(ccpAdd(startPos, ccpCompMult(offset, ccp(x, y))),p_size);
            [items addObject:item];
        }];
        
        NSUInteger idx = 0;
        __block PGGameListMenu *self_copy = self;
        
        // Learn Word
        {
            CCMenuItem *item = [items objectAtIndex:idx];
            [item setBlock:^(id sender) {
                PGLearnWord *game = [PGLearnWord gameWithWords:self_copy.words];
                game.gameLevel = [[PGManager sharedManager] gameLevel] + 1;
                CCScene *scene = [CCScene node];
                [scene addChild:game];
                [[CCDirector sharedDirector] pushScene:scene];
            }];
        }
        
        idx++;// Search Word,idx = 1
        {
            CCMenuItem *item = [items objectAtIndex:idx];
            [item setBlock:^(id sender) {
                CGSize gridSize;
                switch ([[PGManager sharedManager] gameLevel]) {
                    case 0:
                        gridSize = CGSizeMake(100, 100);
                        break;
                    case 1:
                        gridSize = CGSizeMake(80, 80);
                        break;
                    case 2:
                        gridSize = CGSizeMake(60, 60);
                        break;
                    default:
                        NSAssert(nil, @"wrong game level");
                        break;
                }
                [[CCDirector sharedDirector] pushScene:[PGSearchWord gameWithWords:self_copy.words panelSize:CGSizeMake(640, 640) gridSize:gridSize]];
            }];
        }
        
        idx++;// Card Mattch, idx = 2
        {
            CCMenuItem *item = [items objectAtIndex:idx];
            [item setBlock:^(id sender) {
                [[CCDirector sharedDirector] pushScene:[CardMatching gameWithWords:self_copy.words]];
            }];
        }
        
        idx++;// Bubble , idx = 3
        {
            CCMenuItem *item = [items objectAtIndex:idx];
            [item setBlock:^(id sender) {
                [[CCDirector sharedDirector] pushScene:[LoadingLayer scene]];
                
                dispatch_queue_t queue = dispatch_queue_create("bubble", NULL);
                dispatch_async(queue, ^{
                    CCGLView *view = (CCGLView*)[[CCDirector sharedDirector] view];
                    EAGLContext *_auxGLcontext = [[EAGLContext alloc]
                                                  initWithAPI:kEAGLRenderingAPIOpenGLES2
                                                  sharegroup:[[view context] sharegroup]];
                    if( [EAGLContext setCurrentContext:_auxGLcontext] )
                    {
                        [BubbleGameLayer preloadTextures];
                        glFlush();
                        
                        [EAGLContext setCurrentContext:nil];
                    }
                    
                    [_auxGLcontext release];
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        CCScene *game = [BubbleGameLayer gameWithWords:self_copy.words];
                        ((BubbleGameLayer*)[game.children objectAtIndex:0]).gameLevel = [PGManager sharedManager].gameLevel + 1;
                        [[CCDirector sharedDirector] popScene];
                        [[CCDirector sharedDirector] pushScene:game];
                    });
                });
                
                dispatch_release(queue);
            }];
        }
        
        idx++; // game level , idx = 4
        {
            CCMenuItem *easy   = [items objectAtIndex:idx++]; // idx = 5
            CCMenuItem *normal = [items objectAtIndex:idx++]; // idx = 6
            CCMenuItem *hard   = [items objectAtIndex:idx];
            
            
            CGPoint gameLevelButtonPosition = ccp(p_size.x / 2, easy.position.y);
            CCMenuItemToggle *gameLevel = [CCMenuItemToggle itemWithItems:@[easy,normal,hard] block:^(id sender) {
                NSUInteger level = ((CCMenuItemToggle*)sender).selectedIndex;
                [[PGManager sharedManager] setGameLevel:level];
            }];
            gameLevel.position = gameLevelButtonPosition;
            gameLevel.selectedIndex = [[PGManager sharedManager] gameLevel];
            
            [items removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(idx-2, 3)]];
            [items addObject:gameLevel];
        }
        
        CCMenu *gameMenu = [CCMenu menuWithArray:items];
        gameMenu.position = CGPointZero;
        [panel addChild:gameMenu];
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
