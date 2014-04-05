//
//  PGLearnWord.h
//  Phonics Games
//
//  Created by yiplee on 14-4-1.
//  Copyright 2014年 yiplee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "SimpleAudioEngine.h"

@interface PGLearnWord : CCLayer<CDLongAudioSourceDelegate>

@property (nonatomic,copy,readonly) NSString *gameName;
@property (nonatomic,retain) NSArray *words;
@property (nonatomic,copy,readonly) NSString *currentWord;

+ (CCScene *) gameWithWords:(NSArray*)words;
- (id) initWithWords:(NSArray*)words;

@end
