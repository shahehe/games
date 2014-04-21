//
//  PGManager.h
//  Phonics Games
//
//  Created by yiplee on 14-4-1.
//  Copyright (c) 2014年 yiplee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGManager : NSObject

@property(nonatomic,readwrite) char newestActiveLetter;
@property(nonatomic,readwrite) char currentLetter;

+ (instancetype) sharedManager;

- (BOOL) isActiveForLetter:(char)letter;

- (void) activeLetter:(char)letter;
- (void) finishGame:(NSString*)gameName;

- (BOOL) isLetterPassed:(char)letter;

- (void) synchronizeData;

@end
