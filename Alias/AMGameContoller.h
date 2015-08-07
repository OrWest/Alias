//
//  AMGameContoller.h
//  Alias
//
//  Created by Alex Motor on 05.08.15.
//  Copyright (c) 2015 Alex Motor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMGame.h"
#import "AMTeam.h"
#import "AMWordPachage.h"

@interface AMGameContoller : NSObject

- (NSArray*) getAllTeamsName;
- (BOOL) addTeamWithName:(NSString*) name;
- (BOOL) changeNameOfTeamAtIndex:(NSInteger)index toName:(NSString*) name;
- (void) removeTeamAtIndex:(NSInteger) index;

- (void) createNewGameWithTeamsAtIndexes:(NSArray*) indexes;
- (void) setRoundTime:(NSInteger) roundTime
       wordCountToWin:(NSInteger) wordCount
   lastWordToEveryone:(BOOL) lastWord
        andExtraQuest:(BOOL) extraQuest;
- (void) setWordPackageAtIndex:(NSInteger) index;

- (void) nextTeamStartGameInRount:(NSInteger) round;
- (void) addCorrectAnswer;
- (void) addNotAnswered;
- (BOOL) isEndGame;

@end
