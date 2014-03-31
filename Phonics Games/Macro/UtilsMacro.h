//
//  UtilsMacro.h
//  Phonics Games
//
//  Created by yiplee on 14-3-31.
//  Copyright (c) 2014年 yiplee. All rights reserved.
//

#import "PGConfig.h"

#ifndef Phonics_Games_UtilsMacro_h
#define Phonics_Games_UtilsMacro_h

#define APP_CACHES_PATH \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0]

#define APP_DOCUMENT_PATH \
[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]

#define SPRITE_FRAME_CACHE      [CCSpriteFrameCache sharedSpriteFrameCache]
#define TEXTURE_CACHE           [CCTextureCache sharedTextureCache]

#define SCREEN_SIZE             [[CCDirector sharedDirector] winSize]
#define SCREEN_WIDTH            SCREEN_SIZE.width
#define SCREEN_HEIGHT           SCREEN_SIZE.height
#define SCREEN_SIZE_P           ccp(SCREEN_WIDTH,SCREEN_HEIGHT)

#define CCMP(x,y)               ccpCompMult(SCREEN_SIZE_P,ccp((x),(y)))
#define CMP(x)                  CCMP(x,x)
#define CMPP(x,y)               ccpCompMult((x),(y));

#define RGBA8888 \
[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

#define RGBA4444 \
[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];

#define RGB565 \
[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];

#define PIXEL_FORMAT_DEFAULT    RGBA8888



#if NEED_OUTPUT_LOG

#define SLog(xx, ...)   NSLog(xx, ##__VA_ARGS__)
#define SLLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#else

#define SLog(xx, ...)  ((void)0)
#define SLLog(xx, ...)  ((void)0)

#endif

#define SLLogString(str) \
SLLog(@"%@",str)

#define SLLogRect(rect) \
SLLog(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y, \
rect.size.width, rect.size.height)

#define SLLogPoint(pt) \
SLLog(@"%s x=%f, y=%f", #pt, pt.x, pt.y)

#define SLLogSize(size) \
SLLog(@"%s w=%f, h=%f", #size, size.width, size.height)

#define SLLogColor(_COLOR) \
SLLog(@"%s h=%f, s=%f, v=%f", #_COLOR, _COLOR.hue, _COLOR.saturation, _COLOR.value)


#endif
