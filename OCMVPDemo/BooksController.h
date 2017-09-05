//
// Created by Luffy on 2017/9/5.
// Copyright (c) 2017 ___THINKYEAH___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

extern const NSNotificationName EVENT_NAME_BOOKS_CHANGED;

@interface BooksController : NSObject

- (NSArray<Book *> *)loadBooks;

- (void)removeBook:(Book *)book;

@end