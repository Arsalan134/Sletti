//
//  UIViewController+InitTranslator.m
//  Sletti
//
//  Created by Arsalan Iravani on 16.04.2018.
//  Copyright © 2018 Arsalan Iravani. All rights reserved.
//

#import "InitTranslator.h"
#import <QuartzCore/QuartzCore.h>
#import <Sletti-Swift.h>

@interface InitTranslator ()
{
    id<SINClient> _client;
    id<SINCall> _call;
}
@end

@implementation InitTranslator
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSinchClient];
    TabController *tabController;
    tabController = [[TabController alloc] init];
    
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
    NSLog(@"answered To Call. INIT TRANSLATOR");
    [_call answer];
}

-(void) stopTalking {
    NSLog(@"stop To Call. INIT TRANSLATOR");
    [_call hangup];
    _call = nil;
}

-(void)viewDidAppear:(BOOL)animated {
    [self performSegueWithIdentifier:@"showT" sender:self];
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

- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call {
    // For now we are just going to answer calls,
    // in a normal app you would show in incoming call screen
    call.delegate = self;
    _call = call;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"recievedCall" object: nil
                                                      userInfo: [NSMutableDictionary dictionaryWithObjectsAndKeys: call.remoteUserId, @"remoteUserID", nil]];
}


#pragma mark - SINCallDelegate
- (void)callDidProgress:(id<SINCall>)call {
    // In this method you can play ringing tone and update ui to display progress of call.
    NSLog(@"Progres. Init translator");
}

- (void)callDidEstablish:(id<SINCall>)call {
    // Change to hangup when the call is connected
    NSLog(@"Establish. Init translator");
}

-(void)callDidEnd:(id<SINCall>)call {
    // Change to call again
    NSLog(@"End. Init translator");
    [self stopTalking];
}

@end



