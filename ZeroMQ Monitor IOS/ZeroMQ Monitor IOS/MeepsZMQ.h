//
//  MeepsZMQ.h
//  ZeroMQ Monitor IOS
//
//  Created by Sean Zehnder on 10/8/11.
//  Copyright 2011 seanzehnder.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZMQContext;

@interface MeepsZMQ : NSObject {
    ZMQContext *context;

    NSOperationQueue *queue;
    NSInvocationOperation *operation;
}

@property(strong, nonatomic) ZMQContext *context;
@property(strong, nonatomic) NSOperationQueue *queue;
@property(strong, nonatomic) NSInvocationOperation *operation;


+(MeepsZMQ*) instance;

@end
