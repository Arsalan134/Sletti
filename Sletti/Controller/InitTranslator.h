//
//  UIViewController+InitTranslator.h
//  Sletti
//
//  Created by Arsalan Iravani on 16.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Sinch/Sinch.h>

@interface InitTranslator: UIViewController<SINCallClientDelegate, SINCallDelegate>
@property (nonatomic, strong) NSString *callFromUserID;
@end
