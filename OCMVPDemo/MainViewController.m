//
//  MainViewController.m
//  OCMVPDemo
//
//  Created by Luffy on 2017/9/5.
//  Copyright © 2017 ___THINKYEAH___. All rights reserved.
//

#import "MainViewController.h"
#import "MainPresenter.h"


@interface MainViewController () <UIAlertViewDelegate> {
    id <IMainPresenter> _presenter;
    NSArray<Book *> *_books;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _presenter = [[MainPresenter alloc] initWithView:self];

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
    if (_books) {
        return _books.count;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Book *book = _books[(NSUInteger) indexPath.row];

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

    Book *book = _books[(NSUInteger) indexPath.row];
    cell.textLabel.text = book.bookName;

    return cell;
}

#pragma mark IMainView

- (void)showBooks:(NSArray<Book *> *)books {
    _books = books;
    [self.tableView reloadData];
}

@end
