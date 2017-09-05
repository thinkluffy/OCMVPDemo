//
// Created by Luffy on 2017/9/5.
// Copyright (c) 2017 ___THINKYEAH___. All rights reserved.
//

#import "MainPresenter.h"
#import "BooksController.h"
#import "EventBus.h"

@interface MainPresenter() {
    BooksController *_booksController;
}

@property (weak) id<IMainView> view;

@end

@implementation MainPresenter

- (instancetype)initWithView:(id<IMainView>)view {
    self = [super init];
    if (self) {
        _view = view;
        _booksController = [[BooksController alloc] init];

        [[EventBus sharedBus] subscribeEvent:[BooksChangedEvent class]
                                         for:self
                                      action:@selector(onBooksChangedEvent:)
                                          at:MainThread];
    }
    return self;
}

- (void)dealloc {
    [[EventBus sharedBus] unsubscribeFor:self];
}

#pragma mark - IMainPresenter

- (void)loadBooks {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSArray<Book *> *books = [_booksController loadBooks];

        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.view showBooks:books];
        });
    });
}

- (void)removeBook:(Book *)book {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_booksController removeBook:book];
    });
}

#pragma mark -

- (void)onBooksChangedEvent:(BooksChangedEvent *)booksChangedEvent {
    [self loadBooks];
}

@end
