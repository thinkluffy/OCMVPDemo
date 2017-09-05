//
// Created by Luffy on 2017/9/5.
// Copyright (c) 2017 ___THINKYEAH___. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum EventBusThread : NSUInteger {
    PostingThread,
    BackgroundThread,
    MainThread
} EventBusThread;

@interface EventBus : NSObject

+ (instancetype)sharedBus;

- (void)subscribeEvent:(Class)eventClass for:(NSObject *)target action:(SEL)action at:(EventBusThread)thread;

- (void)unsubscribeFor:(NSObject *)target;

- (void)postEvent:(NSObject *)event;

@end