//
//  AMStartGameViewController.m
//  Alias
//
//  Created by Alex Motor on 07.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMStartGameViewController.h"

@interface AMStartGameViewController ()

@property (strong, nonatomic) AMGameContoller* gameController;

@end

@implementation AMStartGameViewController

#pragma mark - View methods

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.gameController = [AMGameContoller instance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.currentTeamLabel.text = [self.gameController getCurrentTeam];
    [self.tableView reloadData];
}

#pragma mark - Action

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

@end
