//
// Created by Luffy on 2017/9/5.
// Copyright (c) 2017 ___THINKYEAH___. All rights reserved.
//

#import "BooksController.h"

const NSNotificationName EVENT_NAME_BOOKS_CHANGED = @"BooksChangedEvent";

@interface BooksController () {
    NSMutableArray<Book *> *_books;
}
@end

@implementation BooksController

- (NSArray<Book *> *)loadBooks {
    if (!_books) {
        NSMutableArray<Book *> *books = [[NSMutableArray<Book *> alloc] init];

        [books addObject:[[Book alloc] initWithBookname:@"Gone with Wind"]];
        [books addObject:[[Book alloc] initWithBookname:@"The Monkeys"]];
        [books addObject:[[Book alloc] initWithBookname:@"Three Countries"]];
        [books addObject:[[Book alloc] initWithBookname:@"The Red Dreams"]];

        _books = books;
    }
    return _books;
}

- (void)removeBook:(Book *)book {
    [_books removeObject:book];
    [self postBooksChangedEvent];
}

- (void)postBooksChangedEvent {
    [[NSNotificationCenter defaultCenter]
            postNotificationName:EVENT_NAME_BOOKS_CHANGED
                          object:self];
}

@end