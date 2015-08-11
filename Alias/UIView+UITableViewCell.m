//
//  UIView+UITableViewCell.m
//  Alias
//
//  Created by Alex Motor on 09.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "UIView+UITableViewCell.h"

@implementation UIView (UITableViewCell)

- (UITableViewCell *)superCell{
    if (!self.superview) {
        return nil;
    }
    
    if ([self.superview isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell*)self.superview;
    }
    
    return [self.superview superCell];
}

@end
