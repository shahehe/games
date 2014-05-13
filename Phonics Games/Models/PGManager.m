//
//  PGManager.m
//  Phonics Games
//
//  Created by yiplee on 14-4-1.
//  Copyright (c) 2014年 yiplee. All rights reserved.
//

#import "PGManager.h"

#import "UtilsMacro.h"

@interface PGManager ()
//private
@property(nonatomic,retain) NSArray *wordLists;

@end

@implementation PGManager

+ (instancetype) sharedManager
{
    static PGManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[PGManager alloc] init];
    });
    
    return instance;
}

- (id) init
{
    self = [super init];
    NSAssert(self, @"Game Manager failed launch");
    
    NSString *wordListPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"cardMatchWordList.plist"];
    self.wordLists = [NSArray arrayWithContentsOfFile:wordListPath];
    
    // letter A active default
    NSDictionary *gameStatus = @{@"LearnWord" :[NSNumber numberWithBool:NO],
                                 @"SearchWord":[NSNumber numberWithBool:NO],
                                 @"CardMatch" :[NSNumber numberWithBool:NO],
                                 @"Bubble"    :[NSNumber numberWithBool:NO]};
    [[NSUserDefaults standardUserDefaults] \
     registerDefaults:@{@"A": gameStatus}];
    
    return self;
}

- (void) dealloc
{
    [_wordLists release];
    
    [super dealloc];
}

// 因为现在单词列表中好多字母没有单词，先采取此下策。
- (NSArray*) wordsForLetter:(char)letter
{
    NSUInteger idx = letter - 'A' > 0 ? letter - 'A' : letter - 'a';
    NSArray *words = [self.wordLists objectAtIndex:idx];
    
    return words.count > 0 ? words :@[@"bear",@"bird",@"boat",@"bus"];
}

- (BOOL) isActiveForLetter:(char)letter
{
    NSString *l = [NSString stringWithFormat:@"%c",letter];
    if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:l])
    {
        return YES;
    }
    
    return NO;
}

- (void) activeLetter:(char)letter
{
    if (letter > 'Z') return;
    NSDictionary *gameStatus = @{@"LearnWord" :[NSNumber numberWithBool:NO],
                                 @"SearchWord":[NSNumber numberWithBool:NO],
                                 @"CardMatch" :[NSNumber numberWithBool:NO],
                                 @"Bubble"    :[NSNumber numberWithBool:NO]};
    NSString *l = [NSString stringWithFormat:@"%c",letter];
    [[NSUserDefaults standardUserDefaults] \
     registerDefaults:@{l: gameStatus}];
}

- (void) finishGame:(NSString *)gameName
{
    NSString *l = [NSString stringWithFormat:@"%c",_currentLetter];
    NSMutableDictionary *data = [[[[NSUserDefaults standardUserDefaults]\
                                    dictionaryForKey:l]\
                                    mutableCopy]\
                                    autorelease ];
    if (!data)
    {
        SLLog(@"WARNING:finsh a unactive game:%@",gameName);
        return;
    }
    
    [data setValue:[NSNumber numberWithBool:YES] forKey:gameName];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:l];
    
    if ([self isLetterPassed:_currentLetter])
    {
        [self activeLetter:_currentLetter++];
    }
}

- (BOOL) isLetterPassed:(char)letter
{
    BOOL passed = YES;
    NSString *l = [NSString stringWithFormat:@"%c",letter];
    NSDictionary *data = [[NSUserDefaults standardUserDefaults] dictionaryForKey:l];
    
    if (data)
    {
        for (NSNumber *n in [data allKeys])
        {
            if (![n boolValue])
            {
                passed = NO;
                break;
            }
        }
    }
    else
    {
        passed = NO;
    }
    
    return passed;
}

- (void) synchronizeData
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
