//
//  TeamCell.h
//  Alias
//
//  Created by Alex Motor on 07.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMTeamAndSettingsViewController.h"

@interface AMTeamCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UIButton* checkerButton;
@property (weak, nonatomic) IBOutlet AMTeamAndSettingsViewController* viewController;
@property (assign, nonatomic) BOOL checked;

- (IBAction)pressTeamCheckerAction:(UIButton *)sender;
- (IBAction)changeTeamNameAction:(UIButton *)sender;

@end
