//
//  PGRenderCard.m
//  Phonics Games
//
//  Created by yiplee on 5/7/14.
//  Copyright 2014 yiplee. All rights reserved.
//

#import "PGRenderCard.h"

#pragma mark -- PGRenderCardConfig

@implementation PGRenderCardConfig

- (void) dealloc
{
    [super dealloc];
    
    [_fontName release];
    [_cardBackImageFrame release];
    [_cardFrame release];
    
    [[CCTextureCache sharedTextureCache] removeTextureForKey:_cardImageFileName];
    [_cardImageFileName release];
}

@end

@interface PGRenderCard ()

@property (nonatomic,retain) CCSpriteFrame *cardFrame;
@property (nonatomic,retain) CCSpriteFrame *cardBackFrame;

@end

#pragma mark -- PGRenderCard

@implementation PGRenderCard

+ (PGRenderCardConfig *) defaultConfigForWord:(NSString *)word
{
    PGRenderCardConfig *config = [[[PGRenderCardConfig alloc] init] autorelease];
    
    config.fontName = @"Gill Sans";
    config.fontSize = 24 * CC_CONTENT_SCALE_FACTOR();
    
    config.imagePosition = ccp(0.5, 0.25);
    config.labelPosition = ccp(0.5, 0.65);
    
    config.cardBackImageFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"backCard.png"];
    config.cardFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cardBack.png"];
    
    config.cardImageFileName = [word stringByAppendingPathExtension:@"png"];
    
    return config;
}

+ (instancetype) cardWithWord:(NSString *)word config:(PGRenderCardConfig *)config
{
    return [[[[self class] alloc] initWithWord:word config:config] autorelease];
}

- (id) initWithWord:(NSString *)word config:(PGRenderCardConfig *)config
{
    self = [super init];
    
    _word = [word copy];
    
    PGRenderCardConfig *c = config;
    if (!c)
    {
        CCTexture2D *tex =
        [[CCTextureCache sharedTextureCache] addImage:@"card_back.png"];
        CGRect rect = CGRectZero;
        rect.size = tex.contentSize;
        CCSpriteFrame *f = [CCSpriteFrame frameWithTexture:tex rect:rect];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:f name:@"cardBack.png"];
        c = [PGRenderCard defaultConfigForWord:word];
    }
    
    self.cardBackFrame = c.cardBackImageFrame;
    self.displayFrame  = self.cardBackFrame;
    self.contentSize   = self.displayFrame.rect.size;
    
    CCSprite *card = [CCSprite spriteWithSpriteFrame:c.cardFrame];
    CGPoint p_card = ccpFromSize(card.boundingBox.size);
    card.position = ccpMult(p_card, 0.5);
    card.flipY = YES;
    
    CGFloat fontSize = c.fontSize - self.word.length * CC_CONTENT_SCALE_FACTOR();
    CCLabelTTF *label = [CCLabelTTF labelWithString:word fontName:c.fontName fontSize:fontSize];
    label.position = ccpCompMult(p_card, c.labelPosition);
    label.flipY = YES;
    
    CCSprite *image = [CCSprite spriteWithFile:c.cardImageFileName];
    image.position = ccpCompMult(p_card, c.imagePosition);
    image.flipY = YES;
    
    // for test
    label.scale = 0.6;
    image.scale = 0.6;
    
    CCRenderTexture *tex = [CCRenderTexture renderTextureWithWidth:p_card.x height:p_card.y];
    [tex begin];
    [card visit];
    [image visit];
    [label visit];
    [tex end];
    
    [[tex sprite] setBlendFunc:(ccBlendFunc){GL_ONE,GL_ONE_MINUS_SRC_ALPHA}];
    self.cardFrame = tex.sprite.displayFrame;
    
    _isShow = NO;
    
    return self;
}

- (void) dealloc
{
    [_word release];
    [_cardBackFrame release];
    [_cardFrame release];
    
    [super dealloc];
}

- (void) showFromDirection:(CardFlipDirection)_direction withDuration:(ccTime)_duration
{
    if (_isShow) return;
    _isShow = YES;
    
    CGFloat _angleZ_1,_angleZ_2;
    CGFloat _deltaAngleZ_1,_deltaAngleZ_2;
    CGFloat _angleX_1,_angleX_2;
    CGFloat _deltaAngleX_1,_deltaAngleX_2;
    
    switch (_direction) {
        case FlipFromLeft:
            _angleZ_1 = 0.f;_deltaAngleZ_1 = -90.f;_angleX_1 = 0.f;_deltaAngleX_1 = 0.f;
            _angleZ_2 = -270.f;_deltaAngleZ_2 = -90.f;_angleX_2 = 0.f;_deltaAngleX_2 = 0.f;
            break;
        case FlipFromRight:
            _angleZ_1 = 0.f;_deltaAngleZ_1 = 90.f;_angleX_1 = 0.f;_deltaAngleX_1 = 0.f;
            _angleZ_2 = 270.f;_deltaAngleZ_2 = 90.f;_angleX_2 = 0.f;_deltaAngleX_2 = 0.f;
            break;
        case FlipFromUp:
            _angleZ_1 = 0.f;_deltaAngleZ_1 = 90.f;_angleX_1 = 90.f;_deltaAngleX_1 = 0.f;
            _angleZ_2 = 270.f;_deltaAngleZ_2 = 90.f;_angleX_2 = 90.f;_deltaAngleX_2 = 0.f;
            break;
        case FlipFromDown:
            _angleZ_1 = 0.f;_deltaAngleZ_1 = 90.f;_angleX_1 = -90.f;_deltaAngleX_1 = 0.f;
            _angleZ_2 = 270.f;_deltaAngleZ_2 = 90.f;_angleX_2 = -90.f;_deltaAngleX_2 = 0.f;
            break;
        default:
            NSAssert(NO, @"this case should not be reached");
            break;
    }
    
    //do something
    id flipFirstHalf = [CCOrbitCamera actionWithDuration:_duration/2 radius:1.f deltaRadius:0.f angleZ:_angleZ_1 deltaAngleZ:_deltaAngleZ_1 angleX:_angleX_1 deltaAngleX:_deltaAngleX_1];
    CCCallBlock *replaceSprite = [CCCallBlock actionWithBlock:^{
        self.displayFrame = self.cardFrame;
    }];
    id flipSecondHalf = [CCOrbitCamera actionWithDuration:_duration/2 radius:1.f deltaRadius:0.f angleZ:_angleZ_2 deltaAngleZ:_deltaAngleZ_2 angleX:_angleX_2 deltaAngleX:_deltaAngleX_2];
    CCSequence *show = [CCSequence actions:flipFirstHalf,replaceSprite,flipSecondHalf, nil];
    [self runAction:show];
}

- (void) hideFromDirection:(CardFlipDirection)_direction withDuration:(ccTime)_duration
{
    if (!_isShow) return;
    _isShow = NO;
    
    CGFloat _angleZ_1,_angleZ_2;
    CGFloat _deltaAngleZ_1,_deltaAngleZ_2;
    CGFloat _angleX_1,_angleX_2;
    CGFloat _deltaAngleX_1,_deltaAngleX_2;
    
    switch (_direction) {
        case FlipFromLeft:
            _angleZ_1 = 0.f;_deltaAngleZ_1 = -90.f;_angleX_1 = 0.f;_deltaAngleX_1 = 0.f;
            _angleZ_2 = -270.f;_deltaAngleZ_2 = -90.f;_angleX_2 = 0.f;_deltaAngleX_2 = 0.f;
            break;
        case FlipFromRight:
            _angleZ_1 = 0.f;_deltaAngleZ_1 = 90.f;_angleX_1 = 0.f;_deltaAngleX_1 = 0.f;
            _angleZ_2 = 270.f;_deltaAngleZ_2 = 90.f;_angleX_2 = 0.f;_deltaAngleX_2 = 0.f;
            break;
        case FlipFromUp:
            _angleZ_1 = 0.f;_deltaAngleZ_1 = 90.f;_angleX_1 = 90.f;_deltaAngleX_1 = 0.f;
            _angleZ_2 = 270.f;_deltaAngleZ_2 = 90.f;_angleX_2 = 90.f;_deltaAngleX_2 = 0.f;
            break;
        case FlipFromDown:
            _angleZ_1 = 0.f;_deltaAngleZ_1 = 90.f;_angleX_1 = -90.f;_deltaAngleX_1 = 0.f;
            _angleZ_2 = 270.f;_deltaAngleZ_2 = 90.f;_angleX_2 = -90.f;_deltaAngleX_2 = 0.f;
            break;
        default:
            NSAssert(NO, @"this case should not be reached");
            break;
    }
    
    //do something
    id flipFirstHalf = [CCOrbitCamera actionWithDuration:_duration/2 radius:1.f deltaRadius:0.f angleZ:_angleZ_1 deltaAngleZ:_deltaAngleZ_1 angleX:_angleX_1 deltaAngleX:_deltaAngleX_1];
    CCCallBlock *replaceSprite = [CCCallBlock actionWithBlock:^{
        self.displayFrame = self.cardBackFrame;
    }];
    id flipSecondHalf = [CCOrbitCamera actionWithDuration:_duration/2 radius:1.f deltaRadius:0.f angleZ:_angleZ_2 deltaAngleZ:_deltaAngleZ_2 angleX:_angleX_2 deltaAngleX:_deltaAngleX_2];
    CCSequence *hide = [CCSequence actions:flipFirstHalf,replaceSprite,flipSecondHalf, nil];
    [self runAction:hide];
}

- (void) flipCardFromDirection:(CardFlipDirection)_direction withDuration:(ccTime)_duration
{
    if (_isShow)
        [self hideFromDirection:_direction withDuration:_duration];
    else
        [self showFromDirection:_direction withDuration:_duration];
}

- (void) showDirectly
{
    if (_isShow) return;
    _isShow = YES;
    
    self.displayFrame = self.cardFrame;
}

- (void) hideDirectly
{
    if (!_isShow) return;
    _isShow = NO;
    
    self.displayFrame = self.cardBackFrame;
}

- (BOOL) isMatchWithCard:(PGRenderCard *)card ignoreSelf:(BOOL)ignore
{
    if (!ignore && self == card)
    {
        return NO;
    }
    
    if ([self.word isEqualToString:card.word])
        return YES;
    else
        return NO;
}

@end
