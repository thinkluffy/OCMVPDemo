//
// Created by Luffy on 2017/9/5.
// Copyright (c) 2017 ___THINKYEAH___. All rights reserved.
//

#import "BooksController.h"
#import "EventBus.h"

@implementation BooksChangedEvent

- (instancetype)initWithMessage:(NSString *)message {
    self = [super init];
    if (self) {
        _message = message;
    }
    return self;
}

@end

@interface BooksController () {
    NSMutableArray<Book *> *_books;
}
@end

@implementation BooksController

- (NSArray<Book *> *)loadBooks {
    if (!_books) {
        NSMutableArray<Book *> *books = [[NSMutableArray<Book *> alloc] init];

        [books addObject:[[Book alloc] initWithBookName:@"Gone with Wind"]];
        [books addObject:[[Book alloc] initWithBookName:@"The Monkeys"]];
        [books addObject:[[Book alloc] initWithBookName:@"Three Countries"]];
        [books addObject:[[Book alloc] initWithBookName:@"The Red Dreams"]];

        _books = books;
    }
    return _books;
}

- (void)removeBook:(Book *)book {
    [_books removeObject:book];
    [self postBooksChangedEvent:@"Rook Removed"];
}

- (void)postBooksChangedEvent:(NSString *)message {
    [[EventBus sharedBus] postEvent:[[BooksChangedEvent alloc] initWithMessage:message]];
}

@end
