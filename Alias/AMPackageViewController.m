//
//  AMPackageViewController.m
//  Alias
//
//  Created by Alex Motor on 07.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMPackageViewController.h"
#import "AMStartGameViewController.h"
#import "AMWordPachageCell.h"
#import "AMWordPachage.h"

@interface AMPackageViewController ()

@end

@implementation AMPackageViewController


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.gameController getAllWordPackages] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* wordPackageIdentifier = @"WordPackageCell";
    
    AMWordPachageCell* cell = [self.tableView dequeueReusableCellWithIdentifier:wordPackageIdentifier];
    
    if (cell) {
        AMWordPachage* package = [[self.gameController getAllWordPackages] objectAtIndex:indexPath.row];
        cell.name.text = package.name;
        NSString* difficultyString;
        switch (package.difficulty) {
            case 0:
                difficultyString = @"Легко";
                break;
            case 1:
                difficultyString = @"Средне";
                break;
            case 2:
                difficultyString = @"Сложно";
                break;
                
            default:
                break;
        }
        
        cell.difficulty.text = difficultyString;
        
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (int i = 0; i < [[self.gameController getAllWordPackages] count]; i++) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (indexPath.row == i) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}


#pragma mark - Segue


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    for (int i = 0; i < [[self.gameController getAllWordPackages] count]; i++) {
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [self.gameController setWordPackageAtIndex:i];
        }
    }
    
    [segue.destinationViewController setGameController:self.gameController];
}


@end
