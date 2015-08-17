//
//  ViewController.m
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMTeamAndSettingsViewController.h"
#import "AMTeamCell.h"
#import "AMPackageViewController.h"

@interface AMTeamAndSettingsViewController ()

@property (strong, nonatomic) AMGameContoller* gameController;
@property (assign, nonatomic) BOOL lastWordChecked;
@property (assign, nonatomic) BOOL extraQuestChecked;

@end

@implementation AMTeamAndSettingsViewController

#pragma mark - View methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameController = [AMGameContoller instance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    if (self.nameTeamTextField) {
        self.nameTeamTextField.text = [[self.gameController getTeamsList] objectAtIndex:self.indexOfChangingTeam];
    } else {
        if ([self.gameController haveContinue]) {
            self.continueButton.hidden = NO;
        } else {
            self.continueButton.hidden = YES;
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.gameController saveProperties];
}


#pragma mark - Actions

- (IBAction)pressCheckerAction:(UIButton *)sender {
    UIImage* tempImage = [sender backgroundImageForState:UIControlStateNormal];
    [sender setBackgroundImage:[sender backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];
    [sender setBackgroundImage:tempImage forState:UIControlStateHighlighted];
    
    if ([sender isEqual:self.lastWordChecker]) {
        self.lastWordChecked = !self.lastWordChecked;
    } else {
        self.extraQuestChecked = !self.extraQuestChecked;
    }
}

- (IBAction)changeRoundTimeAction:(UISlider *)sender {
    self.roundTimeInSecondLabel.text = [NSString stringWithFormat:@"%d",(int)sender.value];
}

- (IBAction)changeWordsToWinAction:(UISlider *)sender {
    self.wordsToWinLabel.text = [NSString stringWithFormat:@"%d",(int)sender.value];
}

- (IBAction)newTeamOKAction:(id)sender {
    [self.gameController addTeamWithName:self.nameNewTeamTextField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeTeamOKAction:(id)sender {
    [self.gameController changeNameOfTeamAtIndex:self.indexOfChangingTeam toName:self.nameTeamTextField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteTeamAction:(id)sender {
    [self.gameController removeTeamAtIndex:self.indexOfChangingTeam];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.gameController getTeamsList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* teamIdentifier = @"TeamCell";
    
    AMTeamCell* cell = [self.tableView dequeueReusableCellWithIdentifier:teamIdentifier];
    
    if (cell) {
        cell.teamName.text = [[self.gameController getTeamsList] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMTeamCell* cell = (AMTeamCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell pressTeamCheckerAction:cell.checkerButton];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.nameNewTeamTextField]) {
        [self newTeamOKAction:textField];
    } else {
        [self changeTeamOKAction:textField];
    }
    
    return YES;
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewGame"]) {
        self.teamCheckedCount = 0;
        
    } else if ([segue.identifier isEqualToString:@"TeamChecked"]) {
        
        NSMutableArray* teamsToPlay = [NSMutableArray array];
        for (int i = 0; i < [[self.gameController getTeamsList] count]; i++) {
            AMTeamCell* cell = (AMTeamCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (cell.checked) {
                [teamsToPlay addObject:[NSNumber numberWithInteger:i]];
            }
        }
        [self.gameController createNewGameWithTeamsAtIndexes:teamsToPlay];
        
        self.lastWordChecked = NO;
        self.extraQuestChecked = NO;
        
    } else if ([segue.identifier isEqualToString:@"SetSettings"]) {
                
        [self.gameController setRoundTime:self.roundTimeSlider.value
                           wordCountToWin:self.wordsToWinSlider.value
                       lastWordToEveryone:self.lastWordChecked
                            andExtraQuest:self.extraQuestChecked];
    } else if ([segue.identifier isEqualToString:@"ContinueGame"]) {
        [self.gameController loadLastGameProperties];
    } else if ([segue.identifier isEqualToString:@"ChangeTeam"]) {
        [segue.destinationViewController setIndexOfChangingTeam:self.indexOfChangingTeam];
    }
}




@end
