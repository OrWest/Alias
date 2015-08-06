//
//  Team.h
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMTeam : NSObject

@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) NSInteger score;

- (instancetype)initWithName:(NSString*) name;

@end
