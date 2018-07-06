//
//  FWActivityIndicatorView.m
//  MBall
//
//  Created by Kent Vu on 8/23/15.
//  Copyright (c) 2015 mobiphone. All rights reserved.
//

#import "FWActivityIndicatorView.h"

@interface FWActivityIndicatorView () {
    
}

@property (nonatomic, weak, setter=setParentView:)     UIView   *parentView;
@property (nonatomic)           float   cSize;
@property (nonatomic, strong)   UIColor   *cColor;
@property (nonatomic)           FWActivityIndicatorLocation cLoc;

@end

@implementation FWActivityIndicatorView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesWhenStopped = YES;
    }
    return self;
}

+ (FWActivityIndicatorView *)showInView:(UIView *)view {
    return [FWActivityIndicatorView showInView:view color:nil width:0 location:FWActivityIndicatorLocationCenter];
}

+ (FWActivityIndicatorView *)showInView:(UIView *)view location:(FWActivityIndicatorLocation)location {
    return [FWActivityIndicatorView showInView:view color:nil width:0 location:location];
}

+ (FWActivityIndicatorView *)showWhiteIndicatorInView:(UIView *)view location:(FWActivityIndicatorLocation)location {
    return [FWActivityIndicatorView showInView:view color:[UIColor whiteColor] width:0 location:location];
}

+ (FWActivityIndicatorView *)showInView:(UIView *)view color:(UIColor *)colored width:(float)width location:(FWActivityIndicatorLocation)location {
    FWActivityIndicatorView *activator = [[FWActivityIndicatorView alloc] initWithActivityIndicatorStyle:colored ? UIActivityIndicatorViewStyleWhite : UIActivityIndicatorViewStyleGray];
    activator.cSize = (width==0) ? 20.0 : width;
    if (colored) activator.cColor = colored;
    activator.cLoc = location;
    [view addSubview:activator];
    activator.parentView = view;
    [activator setupConstraints];
//    [activator layoutIndicator];
    [activator startAnimating];
    activator.isAnimating = YES;
    return activator;
}

- (void)setupConstraints {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self       addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0
                                                            constant:_cSize]];
    
    [self       addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:0
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0
                                                            constant:_cSize]];
    
    [self.superview       addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.superview
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0
                                                            constant:0]];
    
    
    switch (_cLoc) {
        case FWActivityIndicatorLocationCenter:
        {
            [self.superview           addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.superview
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1.0
                                                                        constant:0]];
        }
            break;
        case FWActivityIndicatorLocationLeft:
        {
            [self.superview           addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.superview
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.0
                                                                        constant:5]];
        }
            break;
        case FWActivityIndicatorLocationRight:
        {
            [self.superview           addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.superview
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:-5]];
        }
            break;
            
        default:
            break;
    }
    
    [self layoutIfNeeded];
}

- (void)setParentView:(UIView *)parentView {
    _parentView = parentView;
//    [_parentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"frame"]) {
//        [self layoutIndicator];
//    }
//}

//- (void)layoutIndicator {
//    
//    float desireY = (CGRectGetHeight(_parentView.frame)-_cSize)/2;
//    switch (self.cLoc) {
//        case FWActivityIndicatorLocationCenter:
//        {
//            self.frame = CGRectMake((CGRectGetWidth(_parentView.frame)-_cSize)/2, desireY, _cSize, _cSize);
//        }
//            break;
//        case FWActivityIndicatorLocationLeft:
//        {
//            self.frame = CGRectMake(5, desireY, _cSize, _cSize);
//            
//        }
//            break;
//        case FWActivityIndicatorLocationRight:
//        {
//            self.frame = CGRectMake(CGRectGetWidth(_parentView.frame)-_cSize-5, desireY, _cSize, _cSize);
//            
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

- (void)hide {
    if (_parentView) {
//        [_parentView removeObserver:self forKeyPath:@"frame"];
    }
    self.isAnimating = NO;
    [self stopAnimating];
    [self removeFromSuperview];
}


+ (NSUInteger)hideAllActivityIndicatorInView:(UIView *)view {
    NSArray *huds = [self allHUDsForView:view];
    NSUInteger count = huds.count;
    for (FWActivityIndicatorView *hud in huds) {
        [hud hide];
    }
    return count;
}
+ (NSArray *)allHUDsForView:(UIView *)view {
    NSMutableArray *huds = [NSMutableArray array];
    NSArray *subviews = view.subviews;
    for (UIView *aView in subviews) {
        if ([aView isKindOfClass:self]) {
            [huds addObject:aView];
        }
    }
    return [NSArray arrayWithArray:huds];
}

@end
