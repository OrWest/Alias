//
//  ViewController.m
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "ViewController.h"
#import "AMGameContoller.h"
#import "AMTeamCell.h"
#import "AMPackageViewController.h"

@interface ViewController ()

@property (strong, nonatomic) AMGameContoller* gameController;
@property (assign, nonatomic) BOOL lastWordChecked;
@property (assign, nonatomic) BOOL extraQuestChecked;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction) pressBackAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

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


#pragma mark - Segue


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewGame"]) {
        self.teamCheckedCount = 0;
        
        self.gameController = [[AMGameContoller alloc] init];
        
        [segue.destinationViewController setGameController:self.gameController];
        
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
        
        [segue.destinationViewController setGameController:self.gameController];
    } else if ([segue.identifier isEqualToString:@"SetSettings"]) {
        [segue.destinationViewController setGameController:self.gameController];
        
        [self.gameController setRoundTime:self.roundTimeSlider.value
                           wordCountToWin:self.wordsToWinSlider.value
                       lastWordToEveryone:self.lastWordChecked
                            andExtraQuest:self.extraQuestChecked];
    }
}




@end
