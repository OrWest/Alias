//
//  TeamCell.m
//  Alias
//
//  Created by Alex Motor on 07.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMTeamCell.h"
#import "UIView+UITableViewCell.h"

@implementation AMTeamCell

- (IBAction)pressTeamCheckerAction:(UIButton *)sender {
    UIImage* tempImage = [sender backgroundImageForState:UIControlStateNormal];
    [sender setBackgroundImage:[sender backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];
    [sender setBackgroundImage:tempImage forState:UIControlStateHighlighted];
    
    self.checked = !self.checked;
    
    if (self.checked) {
        self.viewController.teamCheckedCount++;
    } else {
        self.viewController.teamCheckedCount--;
    }
    
    
    if (self.viewController.teamCheckedCount > 1) {
        [self.viewController.nextButton setHidden:NO];
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.viewController.nextButton.alpha = 1.f;
                         } completion:^(BOOL finished) {
                         }];
    } else {
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.viewController.nextButton.alpha = 0.f;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [self.viewController.nextButton setHidden:YES];
                             }
                         }];
    }
}

- (IBAction)changeTeamNameAction:(UIButton *)sender {
    AMTeamCell* cell    = (AMTeamCell*)[sender superCell];
    NSString* teamName  = cell.teamName.text;
    self.viewController.indexOfChangingTeam =
    [[[AMGameContoller instance] getTeamsList] indexOfObject:teamName];
    
    [self.viewController performSegueWithIdentifier:@"ChangeTeam" sender:self];
}
@end
