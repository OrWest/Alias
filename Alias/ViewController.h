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
@property (weak, nonatomic) IBOutlet UIButton *lastWordChecker;
@property (weak, nonatomic) IBOutlet UIButton *extraQuestChecker;
@property (weak, nonatomic) IBOutlet UILabel *roundTimeInSecond;
@property (weak, nonatomic) IBOutlet UILabel *wordsToWin;

- (IBAction) pressBackAction:(UIButton*) sender;
- (IBAction)pressCheckerAction:(UIButton *)sender;
- (IBAction)changeRoundTimeAction:(UISlider *)sender;
- (IBAction)changeWordsToWinAction:(UISlider *)sender;

@end

