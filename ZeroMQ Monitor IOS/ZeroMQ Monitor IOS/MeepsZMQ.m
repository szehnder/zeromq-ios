//
//  MeepsZMQ.m
//  ZeroMQ Monitor IOS
//
//  Created by Sean Zehnder on 10/8/11.
//  Copyright 2011 seanzehnder.com. All rights reserved.
//

#import "MeepsZMQ.h"
#import <ZMQContext.h>
#import "ZMQSocket.h"
#import "BSONCodec.h"

@implementation MeepsZMQ

@synthesize context, queue;
@synthesize operation;

static MeepsZMQ *g_instance = NULL;


//context = zmq.Context()
//
//subscriber = context.socket (zmq.SUB)
//subscriber.connect ("tcp://192.168.55.112:5556")
//subscriber.connect ("tcp://192.168.55.201:7721")
//subscriber.setsockopt (zmq.SUBSCRIBE, "NASDAQ")
//
//publisher = context.socket (zmq.PUB)
//publisher.bind ("ipc://nasdaq-feed")
//
//while True:
//message = subscriber.recv()
//publisher.send (message)

- (id)init
{
    self = [super init];
    if (self) {
        self.context = [[ZMQContext alloc] initWithIOThreads:2];
//        self.publisher = [self.context socketWithType:ZMQ_PUB];
//        [self.publisher bindToEndpoint:@"ipc://boogie-woogie"];
         
        self.queue = [NSOperationQueue new];
        self.operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                                selector:@selector(setupSockets:)
                                                                                  object:self.context];
        [self.queue addOperation:self.operation];
    }
    
    return self;
}

-(void) setupSockets:(ZMQContext*)myContext {
    ZMQSocket *subscriber = [myContext socketWithType:ZMQ_SUB];    
    [subscriber connectToEndpoint: @"tcp://127.0.0.1:5556" ];
    [subscriber setData:[@"NASDAQ" dataUsingEncoding:NSUTF8StringEncoding] forOption:ZMQ_SUBSCRIBE];
    [subscriber setData:[@"sean - ios" dataUsingEncoding:NSUTF8StringEncoding] forOption:ZMQ_IDENTITY];
        
    while (1) {
        NSData *r = [subscriber receiveDataWithFlags:ZMQ_SNDMORE];
        NSData *m = [subscriber receiveDataWithFlags:ZMQ_NOBLOCK];
        if (m!=NULL) {
//            NSString *message = [NSString stringWithUTF8String:[m bytes]];
//            NSArray *parts = [message componentsSeparatedByString:@" "];
//            NSString *header = [[NSString alloc] initWithFormat:@"%@ %@ ", [parts objectAtIndex:0], [parts objectAtIndex:1]];
//            NSInteger byteCount = [header dataUsingEncoding:NSUTF8StringEncoding].length;
            
//            NSData *bsonData = [m subdataWithRange:NSMakeRange(byteCount, m.length-byteCount-1)];
            NSDictionary *dict = [m BSONValue];
            
//            NSLog(@"Raw Message: %@", message);
//            NSLog(@"Parts: %@", parts );
            NSLog(@"Message Topic: %@", [dict objectForKey:@"topic"]);
            NSLog(@"Message Body: %@", [dict objectForKey:@"body"]);
            
            [self performSelectorOnMainThread:@selector(postMessageNotification:) withObject:dict waitUntilDone:NO];
            
        }
        sleep(3);
        
    }
}
             
-(void) postMessageNotification:(NSString*)myMessage {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatMessageReceived" object:myMessage];       
}

-(void) sendMessage:(NSString*) myMessage {
//    NSData *msg = [myMessage dataUsingEncoding:NSUTF8StringEncoding];
//    [self.publisher sendData:msg withFlags:ZMQ_NOBLOCK];
}

+(MeepsZMQ*) instance {
    @synchronized(self) {
        if (g_instance==NULL)
            g_instance = [[MeepsZMQ alloc] init];
    }
    return g_instance;
}




@end
