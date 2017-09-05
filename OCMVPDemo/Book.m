//
// Created by Luffy on 2017/9/5.
// Copyright (c) 2017 ___THINKYEAH___. All rights reserved.
//

#import "Book.h"

@interface Book () {
    NSString *_bookName;
}
@end

@implementation Book

- (instancetype)initWithBookname:(NSString *)bookName {
    self = [super init];
    if (self) {
        _bookName = bookName;
    }
    return self;
}

@end