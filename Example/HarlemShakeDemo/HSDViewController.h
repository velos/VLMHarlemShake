//
//  HSDViewController.h
//  HarlemShakeDemo
//
//  Created by Zac White on 3/7/13.
//  Copyright (c) 2013 Velos Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSDViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *shakeButton;

- (IBAction)performShake:(id)sender;

@end
