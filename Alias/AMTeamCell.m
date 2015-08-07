//
//  TeamCell.m
//  Alias
//
//  Created by Alex Motor on 07.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMTeamCell.h"

@implementation AMTeamCell

- (IBAction)pressTeamCheckerAction:(UIButton *)sender {
    UIImage* tempImage = [sender backgroundImageForState:UIControlStateNormal];
    [sender setBackgroundImage:[sender backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateNormal];
    [sender setBackgroundImage:tempImage forState:UIControlStateHighlighted];
    
    self.checked =  !self.checked;
    
    if (self.checked) {
        self.viewController.teamCheckedCount++;
    } else {
        self.viewController.teamCheckedCount--;
    }
    
    
    if (self.viewController.teamCheckedCount > 1) {
        [self.viewController.nextButton setHidden:NO];
    } else {
        [self.viewController.nextButton setHidden:YES];

    }
}
@end
