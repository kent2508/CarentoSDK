//
//  FontLoader.m
//  CarentoSDK
//
//  Created by Tuan Anh Vu on 6/30/18.
//  Copyright © 2018 Carento. All rights reserved.
//

#import "FontLoader.h"
#import <CoreText/CoreText.h>

@implementation FontLoader

+ (void)loadFont:(NSString *)fontFileNameWithoutExtension {
    NSString *fontPath = [[NSBundle bundleForClass:self] pathForResource:fontFileNameWithoutExtension ofType:@"ttf"];
    NSData *inData = [NSData dataWithContentsOfFile:fontPath];
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)inData);
    CGFontRef fontRef = CGFontCreateWithDataProvider(provider);
    
    if (!CTFontManagerRegisterGraphicsFont(fontRef, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    } else {
        CFStringRef fontNameRef = CGFontCopyPostScriptName(fontRef);
//        UIFont *font = [UIFont fontWithName:(__bridge NSString *)fontNameRef size:someSize];
        // Your UIFont is ready.
        
        CFRelease(fontNameRef);
    }
    CFRelease(fontRef);
    CFRelease(provider);
}

@end
