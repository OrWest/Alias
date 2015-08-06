//
//  Game.h
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMTeam.h"
#import "AMWordPachage.h"

@interface AMGame : NSObject

@property (strong, nonatomic) NSArray* teams;
@property (strong, nonatomic) AMWordPachage* currentWordPocket;
@property (assign, nonatomic) NSInteger roundTimeInSecond;
@property (assign, nonatomic) NSInteger scoreToWin;
@property (assign, nonatomic) BOOL lastWordForEveryone;
@property (assign, nonatomic) BOOL extraQuest;

@property (assign, nonatomic) NSInteger round;
@property (assign, nonatomic) NSInteger secondRemain;
@property (strong, nonatomic) AMTeam* currentTeam;
@property (assign, nonatomic) NSInteger answeredCount;
@property (assign, nonatomic) NSInteger notAnsweredCount;

- (void) startGameWithTeam:(AMTeam*) team andRound:(NSInteger) round;

@end
