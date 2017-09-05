//
// Created by Luffy on 2017/9/5.
// Copyright (c) 2017 ___THINKYEAH___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@interface BooksChangedEvent : NSObject

@property (copy, readonly) NSString *message;

- (instancetype)initWithMessage:(NSString *)message;

@end

@interface BooksController : NSObject

- (NSArray<Book *> *)loadBooks;

- (void)removeBook:(Book *)book;

@end