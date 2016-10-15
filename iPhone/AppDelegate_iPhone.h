//
//  AppDelegate_iPhone.h
//  eyeDoubleMatch
//
//  Created by Gene Backlin on 9/10/10.
//  Copyright MariZack Consulting 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate_iPhone :NSObject <UIApplicationDelegate> {
    UIWindow *window;
    UIViewController *viewController;
}

@property (nonatomic, retain)IBOutlet UIWindow *window;
@property (nonatomic, retain)IBOutlet UIViewController *viewController;

@end

