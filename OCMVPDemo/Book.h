//
// Created by Luffy on 2017/9/5.
// Copyright (c) 2017 ___THINKYEAH___. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Book : NSObject

@property (atomic, strong) NSString *bookName;

- (instancetype)initWithBookname:(NSString *)bookName;

@end