// yiplee

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PGColor : NSObject {
    
}

+ (ccColor3B) addColor:(ccColor3B)color onColor:(ccColor3B)originColor;

+ (ccColor3B) removeColor:(ccColor3B)color fromColor:(ccColor3B)originColor;

+ (ccColor3B) randomColor;

+ (ccColor3B) randomBrightColor;

+ (ccColor4B) randomBrightColor4B;

+ (ccColor3B) reverseColor:(ccColor3B) color;

+ (void) introduceColor:(ccColor3B)color;

@end

@interface NSString (yipleeColor)

- (ccColor3B) string2ColorWithDefaultColor:(ccColor3B) defaultColor;

@end


