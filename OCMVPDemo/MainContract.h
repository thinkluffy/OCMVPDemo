//
// Created by Luffy on 2017/9/5.
// Copyright (c) 2017 ___THINKYEAH___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"

@protocol IMainView <NSObject>

@required
- (void)showBooks:(NSArray<Book *> *)books;

@end


@protocol IMainPresenter <NSObject>

@required
- (void)loadBooks;

@required
- (void)removeBook:(Book *)book;

@end