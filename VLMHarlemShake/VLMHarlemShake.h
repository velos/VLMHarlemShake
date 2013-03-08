//
//  VLMHarlemShake.h
//  HarlemShakeDemo
//
//  Created by Zac White on 3/5/13.
//  Copyright (c) 2013 Velos Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLMHarlemShake : NSObject

// creates a harlem shake object with a loner view.
- (id)initWithLonerView:(UIView *)lonerView;

// shakes the loner view for 15 seconds and then shakes every view
// it can find for another 15 seconds.
// calls completion when done.
- (void)shakeWithCompletion:(void(^)())completion;

@end
