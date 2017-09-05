//
//  MainViewController.m
//  OCMVPDemo
//
//  Created by Luffy on 2017/9/5.
//  Copyright © 2017 ___THINKYEAH___. All rights reserved.
//

#import "MainViewController.h"
#import "MainPresenter.h"


@interface TableViewDataSource : NSObject {
    NSArray<Book *> *_books;
}

- (void)setBooks:(NSArray<Book *> *)books;

- (NSInteger)count;

- (Book *)getBook:(NSInteger)index;

@end

@implementation TableViewDataSource

- (void)setBooks:(NSArray<Book *> *)books {
    _books = books;
}

- (NSInteger)count {
    return _books.count;
}

- (Book *)getBook:(NSInteger)index {
    return _books[(NSUInteger) index];
}

@end

@interface MainViewController () {
    id<IMainPresenter> _presenter;
    TableViewDataSource *_tableViewDataSource;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _presenter = [[MainPresenter alloc] initWithView:self];
    _tableViewDataSource = [[TableViewDataSource alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [_presenter loadBooks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableViewDataSource count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Book *book = [_tableViewDataSource getBook:indexPath.row];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove Book?"
                                                                   message:[NSString stringWithFormat:@"Sure to remove the book of \"%@?\"", book.bookName]
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Remove"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [_presenter removeBook:book];
                                                      }];

    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];

    [alert addAction:yesButton];
    [alert addAction:cancelButton];

    [self presentViewController:alert animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }

    Book *book = [_tableViewDataSource getBook:indexPath.row];
    cell.textLabel.text = book.bookName;
    
    return cell;
}

#pragma mark IMainView

- (void)showBooks:(NSArray<Book *> *)books {
    [_tableViewDataSource setBooks:books];
    [self.tableView reloadData];
}

@end
