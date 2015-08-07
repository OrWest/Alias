//
//  AMGameContoller.m
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import "AMGameContoller.h"

@interface AMGameContoller ()

@property (strong, nonatomic) NSMutableArray* teams;
@property (strong, nonatomic) NSMutableArray* wordPackages;
@property (strong, nonatomic) AMGame* currentGame;
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
        
        for (int i = 0; i < 3; i++) {
            AMWordPachage* pachage = [[AMWordPachage alloc] initPachageWithDifficulty:i];
            [self.wordPackages addObject:pachage];
        }
    }
    return self;
}

#pragma mark - Team manipulation

- (NSArray*) getAllTeamsName {
    NSMutableArray* teamsName = [NSMutableArray array];
    for (AMTeam* team in self.teams) {
        [teamsName addObject:team.name];
    }
    
    return teamsName;
}

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

- (void) removeTeamAtIndex:(NSInteger) index {
    [self.teams removeObjectAtIndex:index];
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
    
    self.currentGame.teams = gameTeams;
}

- (void) setRoundTime:(NSInteger) roundTime wordCountToWin:(NSInteger)
                            wordCount lastWordToEveryone:(BOOL) lastWord andExtraQuest:(BOOL) extraQuest {
    if (self.currentGame) {
        AMGame* game = self.currentGame;
        
        game.roundTimeInSecond = roundTime;
        game.scoreToWin = wordCount;
        game.lastWordForEveryone = lastWord;
        game.extraQuest = extraQuest;
    }
}

- (NSArray*) getAllWordPackages {
    NSMutableArray* tempArray = [NSMutableArray array];
    for (AMWordPachage* package in self.wordPackages) {
        [tempArray addObject:package];
    }
    
    return tempArray;
}

- (void) setWordPackageAtIndex:(NSInteger) index {
    if (self.currentGame) {
        AMWordPachage* wordPackage = [self.wordPackages objectAtIndex:index];
        self.currentGame.currentWordPocket = wordPackage;
    }
}

#pragma mark - Game manipulation

- (void) nextTeamStartGameInRount:(NSInteger) round {
    if (!self.currentGame.currentTeam) {
        [self startTeam:[self.currentGame.teams firstObject] andRound:round];
    } else {
        NSInteger indexOfCurrentTeam =
            [self.currentGame.teams indexOfObject:self.currentGame.currentTeam];
        if ([self.currentGame.teams count] > indexOfCurrentTeam + 1) {
            [self startTeam:[self.currentGame.teams objectAtIndex:indexOfCurrentTeam + 1]
                   andRound:round];
        } else {
            NSLog(@"Bad invoke nextTeam");
        }
    }
}

- (void) startTeam:(AMTeam*) team andRound:(NSInteger) round {
    [self.currentGame startGameWithTeam:team andRound:round];
    
    self.roundTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(everySecondAction)
                                                     userInfo:nil
                                                      repeats:YES];
}

- (void) addCorrectAnswer {
    self.currentGame.answeredCount++;
    
}

- (void) addNotAnswered {
    self.currentGame.notAnsweredCount++;
}

- (void) endRound:(NSInteger) round{
    AMTeam* currentTeam = self.currentGame.currentTeam;
    if ([currentTeam isEqual:[self.currentGame.teams lastObject]]) {
        if ([self isEndGame]) {
            //invoke end game
        } else {
            self.currentGame.currentTeam = nil;
            round++;
            [self nextTeamStartGameInRount:round];
        }
    } else {
        [self nextTeamStartGameInRount:round];
    }
}

- (BOOL) isEndGame {
    NSArray* teams = self.currentGame.teams;
    
    NSInteger bestScore = 0;
    AMTeam* teamWithBestScore = nil;
    
    for (AMTeam* team in teams) {
        if (team.score > bestScore) {
            bestScore = team.score;
            teamWithBestScore = team;
        }
    }
    
    if (bestScore > self.currentGame.scoreToWin) {
        NSInteger teamCountWithBestScore = 0;
        for (AMTeam* team in teams) {
            if (team.score == bestScore) {
                teamCountWithBestScore++;
            }
        }
        
        if (teamCountWithBestScore > 1) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}


#pragma mark - Timer Action

- (void) everySecondAction {
    if (self.currentGame.secondRemain > 0) {
        self.currentGame.secondRemain--;
        NSLog(@"Timer: %ld", self.currentGame.secondRemain);
    }
    else
    {
        NSLog(@"Game ended: %ld", self.currentGame.secondRemain);
        [self.roundTimer invalidate];
        //invoke end round
    }
}


@end
