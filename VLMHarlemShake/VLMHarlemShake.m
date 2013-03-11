//
//  VLMHarlemShake.m
//  HarlemShakeDemo
//
//  Created by Zac White on 3/5/13.
//  Copyright (c) 2013 Velos Mobile. All rights reserved.
//

#import "VLMHarlemShake.h"

#import <AVFoundation/AVFoundation.h>

typedef enum {
    VLMShakeStyleOne = 0,
    VLMShakeStyleTwo,
    VLMShakeStyleThree,
    VLMShakeStyleEnd
} VLMShakeStyle;

@interface VLMHarlemShake () <AVAudioPlayerDelegate>

@property (nonatomic, strong) UIView *lonerView;
@property (nonatomic, strong) NSMutableArray *shakingViews;

@property (nonatomic, copy) void(^completionBlock)();

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

// we want to keep a strong reference to self so we can exist
// while we're playing even if ARC doesn't want us to.
@property (nonatomic, strong) VLMHarlemShake *selfAnchor;

@property (nonatomic, assign, getter = isShaking) BOOL shaking;

// finds views that we might want to shake.
- (void)_findViewsOfInterestWithCallback:(void(^)(UIView *viewOfInterest))callback;
- (void)_findViewsOfInterestInView:(UIView *)rootView withCallback:(void(^)(UIView *viewOfInterest))callback;

// actually shakes the view.
- (void)_shakeView:(UIView *)view withShakeStyle:(VLMShakeStyle)style randomSeed:(CGFloat)seed;

// animation creation methods.
- (CAAnimation *)animationForStyleOneWithSeed:(CGFloat)seed;
- (CAAnimation *)animationForStyleTwoWithSeed:(CGFloat)seed;
- (CAAnimation *)animationForStyleThreeWithSeed:(CGFloat)seed;

@end

@implementation VLMHarlemShake

- (id)initWithLonerView:(UIView *)lonerView
{
    if (!(self = [self init])) return nil;
    
    self.lonerView = lonerView;
    
    return self;
}

- (id)init
{
    if (!(self = [super init])) return nil;
    
    self.shakingViews = [NSMutableArray array];
    self.shaking = NO;
    
    NSURL *audioURL = [[NSBundle mainBundle] URLForResource:@"HarlemShake" withExtension:@"mp3"];
    
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:&error];
    self.audioPlayer.delegate = self;
    
    [self.audioPlayer prepareToPlay];
    
    if (!self.audioPlayer && error) {
        NSLog(@"ERROR: %@", error);
        self.selfAnchor = nil;
        
        return nil;
    }
    
    return self;
}

- (void)shakeWithCompletion:(void(^)())completion
{
    if (self.shaking) return;
    
    // keep a strong reference to self;
    self.selfAnchor = self;
    
    self.shaking = YES;
    self.completionBlock = completion;
    
    // start playing the harlem shake track.
    [self.audioPlayer play];
    
    // inspect the hierarchy.
    self.shakingViews = [NSMutableArray array];
    
    // shake the loner view.
    [self _shakeView:self.lonerView withShakeStyle:VLMShakeStyleThree randomSeed:(arc4random() / (CGFloat)RAND_MAX)];
    
    double delayInSeconds = 15.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self _findViewsOfInterestWithCallback:^(UIView *viewOfInterest) {
            
            [self.shakingViews addObject:viewOfInterest];
            
            // shake the view with a random animation.
            [self _shakeView:viewOfInterest withShakeStyle:(rand() % VLMShakeStyleEnd) randomSeed:(arc4random() / (CGFloat)RAND_MAX)];
            // shake it with another to create more animations.
            [self _shakeView:viewOfInterest withShakeStyle:(rand() % VLMShakeStyleEnd) randomSeed:(arc4random() / (CGFloat)RAND_MAX)];
        }];
    });
}

- (void)_findViewsOfInterestWithCallback:(void(^)(UIView *viewOfInterest))callback
{
    // find the top view.
    UIView *topView = self.lonerView;
    while ([topView superview]) {
        topView = [topView superview];
    }
    
    [self _findViewsOfInterestInView:topView withCallback:callback];
}

- (void)_findViewsOfInterestInView:(UIView *)rootView withCallback:(void(^)(UIView *viewOfInterest))callback
{
    for (UIView *view in [rootView subviews]) {
        
        if ([view isKindOfClass:[UILabel class]] ||
            [view isKindOfClass:[UIButton class]] ||
            [view isKindOfClass:[UIImageView class]] ||
            [view isKindOfClass:[UISwitch class]] ||
            [view isKindOfClass:[UITableViewCell class]] ||
            [view isKindOfClass:[UIProgressView class]] ||
            [view isKindOfClass:[UITextField class]] ||
            [view isKindOfClass:[UISlider class]] ||
            [view isKindOfClass:[UITextView class]]) {
            
            if (callback) callback(view);
        } else {
            [self _findViewsOfInterestInView:view withCallback:callback];
        }
    }
}

- (void)_shakeView:(UIView *)view withShakeStyle:(VLMShakeStyle)style randomSeed:(CGFloat)seed
{
    if (style == VLMShakeStyleOne) {
        [view.layer addAnimation:[self animationForStyleOneWithSeed:seed] forKey:@"styleOne"];
    } else if (style == VLMShakeStyleTwo) {
        [view.layer addAnimation:[self animationForStyleTwoWithSeed:seed] forKey:@"styleTwo"];
    } else if (style == VLMShakeStyleThree) {
        [view.layer addAnimation:[self animationForStyleThreeWithSeed:seed] forKey:@"styleThree"];
    }
    
    self.shaking = NO;
}

- (CAAnimation *)animationForStyleOneWithSeed:(CGFloat)seed
{
    CAAnimationGroup *styleOneGroup = [CAAnimationGroup animation];
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    if (seed < 0.5) {
        rotate.fromValue = @(M_PI * 2);
        rotate.toValue = @(0);
    } else {
        rotate.fromValue = @(0);
        rotate.toValue = @(M_PI * 2);
    }
    
    rotate.duration = 1.0 + seed;
    
    CABasicAnimation *pop = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    pop.fromValue = @(1);
    pop.toValue = @(1.2);
    
    pop.beginTime = rotate.duration;
    
    pop.duration = 0.5 + seed;
    
    pop.autoreverses = YES;
    pop.repeatCount = 1;
    
    styleOneGroup.repeatCount = 10;
    styleOneGroup.autoreverses = YES;
    styleOneGroup.duration = rotate.duration + pop.duration;
    styleOneGroup.animations = @[rotate, pop];
    
    return styleOneGroup;
}

- (CAAnimation *)animationForStyleTwoWithSeed:(CGFloat)seed
{
    CAKeyframeAnimation *keyFrameShake = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CGFloat negative = -1;
    if (seed < 0.5) {
        negative = 1;
    }
    
    CATransform3D startingScale = CATransform3DIdentity;
    CATransform3D secondScale = CATransform3DScale(CATransform3DIdentity, 1.0f + (seed * negative), 1.0f + (seed * negative), 1.0f);
    CATransform3D thirdScale = CATransform3DScale(CATransform3DIdentity, 1.0f + (seed * -negative), 1.0f + (seed * -negative), 1.0f);
    CATransform3D finalScale = CATransform3DIdentity;
    
    keyFrameShake.values = @[[NSValue valueWithCATransform3D:startingScale],
                             [NSValue valueWithCATransform3D:secondScale],
                             [NSValue valueWithCATransform3D:thirdScale],
                             [NSValue valueWithCATransform3D:finalScale]
                             ];
    
    keyFrameShake.keyTimes = @[@(0), @(0.4), @(0.7), @(1.0)];
    
    NSArray *timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 ];
    
    keyFrameShake.timingFunctions = timingFunctions;
    
    keyFrameShake.duration = 1.0 + seed;
    keyFrameShake.repeatCount = 100;
    
    return keyFrameShake;
}

- (CAAnimation *)animationForStyleThreeWithSeed:(CGFloat)seed
{
    CAKeyframeAnimation *keyFrameShake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation"];
    
    CGFloat negative = -1;
    if (seed < 0.5) {
        negative = 1;
    }
    
    NSInteger offsetOne = (NSInteger)((10 + 20. * seed) * negative);
    NSInteger offsetTwo = -offsetOne;
    
    NSValue *startingOffset = [NSValue valueWithCGSize:CGSizeZero];
    NSValue *firstOffset = [NSValue valueWithCGSize:CGSizeMake(offsetOne, 0)];
    NSValue *secondOffset = [NSValue valueWithCGSize:CGSizeMake(offsetTwo, 0)];
    NSValue *thirdOffset = [NSValue valueWithCGSize:CGSizeZero];
    NSValue *fourthOffset = [NSValue valueWithCGSize:CGSizeMake(0, offsetOne)];
    NSValue *fifthOffset = [NSValue valueWithCGSize:CGSizeMake(0, offsetTwo)];
    NSValue *finalOffset = [NSValue valueWithCGSize:CGSizeZero];
    
    keyFrameShake.values = @[startingOffset, firstOffset, secondOffset, thirdOffset, fourthOffset, fifthOffset, finalOffset];
    
    keyFrameShake.keyTimes = @[@(0), @(0.1), @(0.3), @(0.4), @(0.5), @(0.7), @(0.8), @(1.0)];
    
    NSArray *timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                 ];
    
    keyFrameShake.timingFunctions = timingFunctions;
    
    keyFrameShake.duration = 1.0 + seed;
    keyFrameShake.repeatCount = 100;
    
    return keyFrameShake;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        // reset all the views.
        for (UIView *view in self.shakingViews) {
            [view.layer removeAllAnimations];
        }
        
        if (self.completionBlock) self.completionBlock();
    }
    
    // release the anchor because we're done playing.
    self.selfAnchor = nil;
}

@end
