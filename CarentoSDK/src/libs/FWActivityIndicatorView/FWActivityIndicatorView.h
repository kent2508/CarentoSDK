//
//  FWActivityIndicatorView.h
//  MBall
//
//  Created by Kent Vu on 8/23/15.
//  Copyright (c) 2015 mobiphone. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FWActivityIndicatorLocation) {
    FWActivityIndicatorLocationCenter,
    FWActivityIndicatorLocationLeft,
    FWActivityIndicatorLocationRight
};

@interface FWActivityIndicatorView : UIActivityIndicatorView

@property (nonatomic) FWActivityIndicatorLocation location;
@property (nonatomic) BOOL isAnimating;

+ (FWActivityIndicatorView *)showInView:(UIView *)view;
+ (FWActivityIndicatorView *)showInView:(UIView *)view location:(FWActivityIndicatorLocation)location;
+ (FWActivityIndicatorView *)showWhiteIndicatorInView:(UIView *)view location:(FWActivityIndicatorLocation)location;

+ (NSUInteger)hideAllActivityIndicatorInView:(UIView *)view;
- (void)hide;

@end

/*@                                    /\  /\
 * @                                  /  \/  \                        ----- |   | ----      |---\ |    | /--\  --- |   |  ---- /--\ /--\
 *  @                                /        --                        |   |   | |         |   / |    | |      |  |\  |  |    |    |
 *   \---\                          /           \                       |   |---| ----      |--/  |    |  \     |  | \ |  ----  \    \
 *    |   \------------------------/       /-\    \                     |   |   | |         |  \  |    |   -\   |  |  \|  |      -\   -\
 *    |                                    \-/     \                    |   |   | ----      |---/  \--/  \--/  --- |   \  ---- \--/ \--/
 *     \                                             ------O
 *      \                                                 /                 --- |   | ----  /--\        |--\   /--\   /--\
 *       |    |                    |    |                /                   |  |\  | |    |    |       |   | |    | |
 *       |    |                    |    |-----    -------                    |  | \ | ---- |    |       |   | |    | | /-\
 *       |    |\                  /|    |     \  WWWWWW/                     |  |  \| |    |    |       |   | |    | |    |
 *       |    | \                / |    |      \-------                     --- |   \ |     \--/        |--/   \--/   \--/
 *       |    |  \--------------/  |    |
 *      /     |                   /     |
 *      \      \                  \      \
 *       \-----/                   \-----/
 */