//
//  UIViewController+ViewController.m
//  Sletti
//
//  Created by Arsalan Iravani on 13.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Sletti-Swift.h>

@interface ViewController ()
{
    id<SINClient> _client;
    id<SINCall> _call;
}
@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSinchClient];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(answertToAnIncomingCall)
                                                 name:@"answer"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopTalking)
                                                 name:@"stopTalking"
                                               object:nil];
}

-(void) answertToAnIncomingCall {
    NSLog(@"Answer to a call. View Controller");
    [_call answer];
}

-(void) stopTalking {
    NSLog(@"Stop Talking. View Controller");
    [_call hangup];
    _call = nil;
}

- (void)initSinchClient {
    _client = [Sinch clientWithApplicationKey:@"e7ccdedf-3bce-4dc6-9a2d-2a59d8ecece5"
                            applicationSecret:@"iQEHbo53c0SQlNiih6VXcA=="
                              environmentHost:@"clientapi.sinch.com"
                                       userId:_callFromUserID];
    _client.callClient.delegate = self;
    [_client setSupportCalling:YES];
    [_client start];
    [_client startListeningOnActiveConnection];
}
    
- (IBAction)callUser:(id)sender {
    NSLog(@"Call user. View Controller");
    if (_call == nil){
        _call = [_client.callClient callUserWithId: _callToUserID]; // Create the call
        _call.delegate = self; // Listen for events on self
    }
    else {
        [_call hangup];
        _call = nil;
    }
}
    
    
#pragma mark - SINCallDelegate
- (void)callDidProgress:(id<SINCall>)call {
    // In this method you can play ringing tone and update ui to display progress of call.
    NSLog(@"Progres. View Controller");
}

- (void)callDidEstablish:(id<SINCall>)call {
    // Change to hangup when the call is connected
    NSLog(@"Establish. View Controller");
    [self.callButton setTitle:@"Hang up" forState:UIControlStateNormal];
    _callImage.image = [UIImage imageNamed:@"desclineIcon"];
}

-(void)callDidEnd:(id<SINCall>)call {
    // Change to call again
    NSLog(@"End. View Controller");
    [self.callButton setTitle:@"Call" forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopTalking" object:nil];
    [self stopTalking];
}
@end

