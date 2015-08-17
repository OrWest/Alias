//
//  ViewController.h
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMGameContoller.h"

@interface AMTeamAndSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (assign, nonatomic) NSInteger teamCheckedCount;
@property (assign, nonatomic) NSInteger indexOfChangingTeam;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIButton* nextButton;
@property (weak, nonatomic) IBOutlet UILabel *roundTimeInSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordsToWinLabel;
@property (weak, nonatomic) IBOutlet UISlider *roundTimeSlider;
@property (weak, nonatomic) IBOutlet UISlider *wordsToWinSlider;
@property (weak, nonatomic) IBOutlet UIButton *lastWordChecker;
@property (weak, nonatomic) IBOutlet UIButton *extraQuestChecker;
@property (weak, nonatomic) IBOutlet UITextField *nameNewTeamTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTeamTextField;


- (IBAction)pressCheckerAction:(UIButton *)sender;
- (IBAction)changeRoundTimeAction:(UISlider *)sender;
- (IBAction)changeWordsToWinAction:(UISlider *)sender;
- (IBAction)newTeamOKAction:(id)sender;
- (IBAction)changeTeamOKAction:(id)sender;
- (IBAction)deleteTeamAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;


@end
