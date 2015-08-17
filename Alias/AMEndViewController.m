//
//  AMEndViewController.m
//  Alias
//
//  Created by Alex Motor on 08.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMEndViewController.h"

@interface AMEndViewController ()

@property (strong, nonatomic) AMGameContoller* gameController;

@end

@implementation AMEndViewController

#pragma mark - View methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameController = [AMGameContoller instance];
    
    self.winnerLabel.text = [self.gameController getWinnerTeam];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.gameController getTeamsNamesInGame] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* teamScoreIdentifier = @"TeamScoreCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:teamScoreIdentifier];
    
    if (cell) {
        cell.textLabel.text = [[self.gameController getTeamsNamesInGame] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [[self.gameController getTeamsScoreInGame] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

#pragma mark - Actions

- (IBAction)endGamePressAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
