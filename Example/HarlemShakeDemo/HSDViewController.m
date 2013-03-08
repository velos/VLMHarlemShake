//
//  HSDViewController.m
//  HarlemShakeDemo
//
//  Created by Zac White on 3/7/13.
//  Copyright (c) 2013 Velos Mobile. All rights reserved.
//

#import "HSDViewController.h"

#import "VLMHarlemShake.h"

@interface HSDViewController ()

@property (strong, nonatomic) VLMHarlemShake *harlemShake;

@end

@implementation HSDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.harlemShake = [[VLMHarlemShake alloc] initWithLonerView:self.shakeButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)performShake:(id)sender {
    [self.harlemShake shakeWithCompletion:^{
        NSLog(@"Shaking done.");
    }];
}

@end
