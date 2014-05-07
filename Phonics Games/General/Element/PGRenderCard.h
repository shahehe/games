//
//  PGRenderCard.h
//  Phonics Games
//
//  Created by yiplee on 5/7/14.
//  Copyright 2014 yiplee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
    FlipFromLeft = 0,
    FlipFromRight,
    FlipFromUp,
    FlipFromDown
}CardFlipDirection;

#pragma mark -- PGRenderCardConfig

@interface PGRenderCardConfig : NSObject

@property (nonatomic,copy) NSString *fontName;
@property (nonatomic,assign) CGFloat fontSize;

@property (nonatomic,assign) CGPoint imagePosition;
@property (nonatomic,assign) CGPoint labelPosition;

@property (nonatomic,retain) CCSpriteFrame *cardBackImageFrame;
@property (nonatomic,retain) CCSpriteFrame *cardFrame;

@property (nonatomic,copy) NSString *cardImageFileName;

@end

#pragma mark -- PGRenderCard

@interface PGRenderCard : CCSprite

@property (nonatomic,copy,readonly) NSString *word;

//
// 正面向上 ，返回 YES；
// 否则，返回 NO。
@property(nonatomic,readonly)BOOL isShow;

+ (PGRenderCardConfig *) defaultConfigForWord:(NSString*)word;

+ (instancetype) cardWithWord:(NSString*)word config:(PGRenderCardConfig*)config;
- (id) initWithWord:(NSString*)word config:(PGRenderCardConfig*)config;

- (void) showFromDirection:(CardFlipDirection)_direction withDuration:(ccTime)_duration;
- (void) hideFromDirection:(CardFlipDirection)_direction withDuration:(ccTime)_duration;
- (void) flipCardFromDirection:(CardFlipDirection)_direction withDuration:(ccTime)_duration;

- (void) showDirectly;
- (void) hideDirectly;

- (BOOL) isMatchWithCard:(PGRenderCard *)card ignoreSelf:(BOOL)ignore;

@end
