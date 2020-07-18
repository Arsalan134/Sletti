//
//  UIViewController+ViewController.h
//  Sletti
//
//  Created by Arsalan Iravani on 13.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>

@interface ViewController : UIViewController<SINCallClientDelegate, SINCallDelegate>
@property (weak, nonatomic) IBOutlet UIButton *callButton;

@property (nonatomic, strong) NSString *callFromUserID;
@property (nonatomic, strong) NSString *callToUserID;
@property (nonatomic, strong) UIImageView *callImage;

- (IBAction)callUser:(id)sender;

@end
