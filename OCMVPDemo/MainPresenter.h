//
// Created by Luffy on 2017/9/5.
// Copyright (c) 2017 ___THINKYEAH___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainContract.h"


@interface MainPresenter : NSObject <IMainPresenter>

- (instancetype)initWithView:(id<IMainView>)view;

@end