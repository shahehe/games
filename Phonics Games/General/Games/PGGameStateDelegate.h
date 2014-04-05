//
//  PGGameState.h
//  Phonics Games
//
//  Created by yiplee on 14-4-3.
//  Copyright (c) 2014年 yiplee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PGGameStateDelegate <NSObject>
@optional

- (void) phonicsGameHasStarted:(id)sender;

@end
