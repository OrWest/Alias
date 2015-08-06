//
//  AMGameContoller.m
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMGameContoller.h"

@interface AMGameContoller ()

@property (strong, nonatomic) NSTimer* roundTimer;

@end

@implementation AMGameContoller

#pragma mark - Initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.teams = [NSMutableArray array];
        self.wordPackages = [NSMutableArray array];
        
        NSArray* defaultTeamNames = [NSArray arrayWithObjects:@"Минеры", @"Декады", nil];
        
        for (int i = 0; i < 2; i++) {
            AMTeam* team = [[AMTeam alloc] initWithName:[defaultTeamNames objectAtIndex:i]];
            [self.teams addObject:team];
        }
    }
    return self;
}

#pragma mark - Team manipulation

- (BOOL) addTeamWithName:(NSString *)name {
    
    BOOL uniqueName = [self isUniqueName:name];
    
    if (uniqueName) {
        AMTeam* team = [[AMTeam alloc] initWithName:name];
        
        [self.teams addObject:team];
    }
    
    return uniqueName;
}

- (BOOL) changeNameOfTeamAtIndex:(NSInteger)index toName:(NSString*) name {
    BOOL uniqueName = [self isUniqueName:name];
    
    if (uniqueName) {
        AMTeam* team = [self.teams objectAtIndex:index];
        team.name = name;
    }
    
    return uniqueName;
}

#pragma mark - Private methods

- (BOOL) isUniqueName:(NSString*) name {
    for (AMTeam* team in self.teams) {
        if ([team.name isEqualToString:name]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Game

- (void) createNewGameWithTeamsAtIndexes:(NSArray*) indexes{
    AMGame* game = [[AMGame alloc] init];
    self.currentGame = game;
    
    NSMutableArray* gameTeams = [NSMutableArray array];
    
    for (int i = 0; i < [indexes count]; i++) {
        NSInteger teamIndex = [[indexes objectAtIndex:i] integerValue];
        AMTeam* team = [self.teams objectAtIndex:teamIndex];
        
        [gameTeams addObject:team];
    }
}

- (void) setRoundTime:(NSInteger) roundTime wordCountToWin:(NSInteger)
                            wordCount lastWordToEveryone:(BOOL) lastWord andExtraQuest:(BOOL) extraQuest {
    if (self.currentGame) {
        AMGame* game = self.currentGame;
        
        game.roundTimeInSecond = roundTime;
        game.wordsToWin = wordCount;
        game.lastWordForEveryone = lastWord;
        game.extraQuest = extraQuest;
    }
}

- (void) setWordPocket:(AMWordPachage*) wordPackage {
    if (self.currentGame) {
        self.currentGame.currentWordPocket = wordPackage;
    }
}

- (void) startGame {
    self.roundTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(everySecondAction)
                                                     userInfo:nil
                                                      repeats:YES];
}


#pragma mark - Timer Action

- (void) everySecondAction {
    
}


@end
