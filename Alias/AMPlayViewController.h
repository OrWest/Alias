//
//  AMPlayViewController.h
//  Alias
//
//  Created by Alex Motor on 08.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMGameContoller.h"

@interface AMPlayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *wordView;
@property (weak, nonatomic) IBOutlet UILabel *answeredLabel;
@property (weak, nonatomic) IBOutlet UILabel *notAnsweredLabel;
@property (weak, nonatomic) IBOutlet UILabel *roundRemainLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@property (weak, nonatomic) IBOutlet UIView *halfAlphaViewWithTip;
@property (weak, nonatomic) IBOutlet UIView *viewWithTip;
@property (weak, nonatomic) IBOutlet UILabel *toptipLabel;
@property (weak, nonatomic) IBOutlet UILabel *extraQuestLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTipLabel;

@property (weak, nonatomic) IBOutlet UIView *lastWordView;
@property (weak, nonatomic) IBOutlet UILabel *lastWordLabel;
@property (weak, nonatomic) IBOutlet UITableView *lastWordTableView;

- (IBAction)tipOkAction:(UIButton *)sender;
- (IBAction)lastWordOKAction:(UIButton *)sender;

@end
