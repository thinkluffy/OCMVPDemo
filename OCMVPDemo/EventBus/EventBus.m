//
// Created by Luffy on 2017/9/5.
// Copyright (c) 2017 ___THINKYEAH___. All rights reserved.
//

#import "EventBus.h"

@interface Subscriber : NSObject

@property (weak) NSObject *performer;
@property (assign) SEL action;

- (instancetype)initWithPerformer:(NSObject *)performer withAction:(SEL)action;

@end

@implementation Subscriber

- (instancetype)initWithPerformer:(NSObject *)performer withAction:(SEL)action {
    self = [super init];
    if (self) {
        _performer = performer;
        _action = action;
    }
    return self;
}

@end

@interface EventBus () {
    NSMutableDictionary<NSString *, NSMutableArray<Subscriber *>*> *_subscribersMapAtPostingThread;
    NSMutableDictionary<NSString *, NSMutableArray<Subscriber *>*> *_subscribersMapAtBackgroundThread;
    NSMutableDictionary<NSString *, NSMutableArray<Subscriber *>*> *_subscribersMapAtMainThread;
}
@end

@implementation EventBus

+ (instancetype)sharedBus {
    static EventBus *instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _subscribersMapAtPostingThread = [[NSMutableDictionary alloc] init];
        _subscribersMapAtBackgroundThread = [[NSMutableDictionary alloc] init];
        _subscribersMapAtMainThread = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)subscribeEvent:(Class)eventClass for:(NSObject *)target action:(SEL)action at:(EventBusThread)thread {
    NSMutableDictionary<NSString *, NSMutableArray<Subscriber *>*> *subscribersMap;
    if (thread == PostingThread) {
        subscribersMap = _subscribersMapAtPostingThread;

    } else if (thread == BackgroundThread) {
        subscribersMap = _subscribersMapAtBackgroundThread;

    } else {
        subscribersMap = _subscribersMapAtMainThread;
    }

    NSMutableArray<Subscriber *> *subscribers = subscribersMap[NSStringFromClass(eventClass)];
    if (!subscribers) {
        subscribers = [[NSMutableArray alloc] init];
        subscribersMap[NSStringFromClass(eventClass)] = subscribers;
    }

    Subscriber *subscriber = [[Subscriber alloc] initWithPerformer:target withAction:action];
    [subscribers addObject:subscriber];
}

- (void)removeSubscriber:(NSObject *)target fromMap:(NSMutableDictionary<NSString *, NSMutableArray<Subscriber *>*> *)map {
    for (NSString *className in map) {
        NSMutableArray<Subscriber *> *subscribers = map[className];
        for (Subscriber *subscriber in subscribers) {
            if (subscriber.performer == target) {
                [subscribers removeObject:subscriber];
            }
        }
    }
}

- (void)unsubscribeFor:(NSObject *)target {
    [self removeSubscriber:target fromMap:_subscribersMapAtPostingThread];
    [self removeSubscriber:target fromMap:_subscribersMapAtBackgroundThread];
    [self removeSubscriber:target fromMap:_subscribersMapAtMainThread];
}

- (void)postEvent:(NSObject *)event {
    NSMutableArray<Subscriber *> *subscribers = _subscribersMapAtPostingThread[NSStringFromClass([event class])];
    for (Subscriber *subscriber in subscribers) {
//            IMP imp = [subscriber.performer methodForSelector:subscriber.action];
//            void (*func)(NSObject *, SEL) = (void *)imp;
//            func(subscriber.performer, subscriber.action);

        [subscriber.performer performSelector:subscriber.action withObject:event];
    }

    subscribers = _subscribersMapAtBackgroundThread[NSStringFromClass([event class])];
    if (subscribers && subscribers.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (Subscriber *subscriber in subscribers) {
                [subscriber.performer performSelector:subscriber.action withObject:event];
            }
        });
    }

    subscribers = _subscribersMapAtMainThread[NSStringFromClass([event class])];
    if (subscribers && subscribers.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (Subscriber *subscriber in subscribers) {
                [subscriber.performer performSelector:subscriber.action withObject:event];
            }
        });
    }
}

@end
