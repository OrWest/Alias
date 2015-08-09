//
//  ViewController.h
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIButton* nextButton;
@property (assign, nonatomic) NSInteger teamCheckedCount;
@property (weak, nonatomic) IBOutlet UILabel *roundTimeInSecondLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordsToWinLabel;
@property (weak, nonatomic) IBOutlet UISlider *roundTimeSlider;
@property (weak, nonatomic) IBOutlet UISlider *wordsToWinSlider;
@property (weak, nonatomic) IBOutlet UIButton *lastWordChecker;
@property (weak, nonatomic) IBOutlet UIButton *extraQuestChecker;

- (IBAction) pressBackAction:(UIButton*) sender;
- (IBAction)pressCheckerAction:(UIButton *)sender;
- (IBAction)changeRoundTimeAction:(UISlider *)sender;
- (IBAction)changeWordsToWinAction:(UISlider *)sender;

@end

