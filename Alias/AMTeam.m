//
//  Team.m
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMTeam.h"

@implementation AMTeam

- (instancetype)initWithName:(NSString*) name
{
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

@end
