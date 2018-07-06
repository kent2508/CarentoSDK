//
//  FontLoader.h
//  CarentoSDK
//
//  Created by Tuan Anh Vu on 6/30/18.
//  Copyright © 2018 Carento. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontLoader : NSObject
+ (void)loadFont:(NSString *)fontFileNameWithoutExtension;
@end
