//
//  GameCenterViewControlleriPad.m
//  eyeDoubleMatch
//
//  Created by Gene Backlin on 11/15/10.
//  Copyright 2010 MariZack Consulting. All rights reserved.
//

#import "GameCenterViewControlleriPad.h"
#import "RootViewControlleriPad.h"


@implementation GameCenterViewControlleriPad

@synthesize delegate;
@synthesize currentLeaderBoard;
@synthesize gameCenterManager;
@synthesize personalBestScoreString;
@synthesize personalTodayBestScoreString;
@synthesize cachedHighestScore;
@synthesize personalBestLabel;
@synthesize personalTodayBestLabel;
@synthesize allTimeBestLabel;


#pragma mark -
#pragma mark GameCenter View Controllers

- (IBAction)showLeaderboard:(id)sender {
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL) {
		leaderboardController.category = self.currentLeaderBoard;
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self; 
        [self presentViewController:leaderboardController animated:YES completion:nil];
	}
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showAchievements:(id)sender {
	GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
	if (achievements != NULL) {
		achievements.achievementDelegate = self;
        [self presentViewController:achievements animated:YES completion:nil];
	}
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)resetAchievements:(id)sender {
	if([self gameCenterManager]) {
		[[self gameCenterManager] resetAchievements];
	}
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:kCFNumberFormatterDecimalStyle];
	[formatter setUsesGroupingSeparator:YES];
	
	if([self personalTodayBestScoreString] && [self personalBestScoreString] && [self cachedHighestScore]) {
		NSNumber *aTodayBest = [NSNumber numberWithLongLong:[[self personalTodayBestScoreString] longLongValue]];
		NSNumber *aPersonalBest = [NSNumber numberWithLongLong:[[self personalBestScoreString] longLongValue]];
		
		[personalTodayBestLabel setText:[NSString stringWithFormat:@"%@ points", [formatter stringFromNumber:aTodayBest]]];
		[personalBestLabel setText:[NSString stringWithFormat:@"%@ points", [formatter stringFromNumber:aPersonalBest]]];
		[allTimeBestLabel setText:[self cachedHighestScore]];
	}
	
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

#pragma mark -
#pragma mark Action methods

- (IBAction)done:(id)sender {
    [[self delegate] done];
}

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark Memory methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
