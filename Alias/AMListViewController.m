//
//  AMListViewController.m
//  Alias
//
//  Created by Alex Motor on 10.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMListViewController.h"

@interface AMListViewController ()

@property (strong, nonatomic) NSMutableArray* cities;
@property (strong, nonatomic) NSArray* cells;

@end

@implementation AMListViewController

#pragma mark - View methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray* cities = @[NSLocalizedString(@"Moscow", @"City"),
                        NSLocalizedString(@"Minsk", @"City"),
                        NSLocalizedString(@"Vilnius", @"City"),
                        NSLocalizedString(@"Grodno", @"City"),
                        NSLocalizedString(@"Brest", @"City")];
    self.cities = [NSMutableArray arrayWithArray:cities];
    [self.cities sortUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        return [obj1 compare:obj2];
    }];
    [self generateCellsWithFilter:@""];
}

#pragma mark - Private methods

- (void) generateCellsWithFilter:(NSString*) filterString {
    NSMutableArray* returnArray = [NSMutableArray array];
    
    NSString* lowerCaseFilterString = [filterString lowercaseString];
    
    for (NSString* string in self.cities) {
        NSString* lowerCaseString = [string lowercaseString];
        
        if (([lowerCaseFilterString length] > 0) && ([lowerCaseString rangeOfString:lowerCaseFilterString].location == NSNotFound)) {
            continue;
        }
        
        [returnArray addObject:string];
    }
    
    self.cells = returnArray;
}

#pragma mark - Actions

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goToSiteAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://tut.by"]];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* teamIdentifier = @"CityCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:teamIdentifier];
    
    if (cell) {
        cell.textLabel.text = [self.cells objectAtIndex:indexPath.row];

    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self generateCellsWithFilter:searchText];
    [self.tableView reloadData];
}

@end
