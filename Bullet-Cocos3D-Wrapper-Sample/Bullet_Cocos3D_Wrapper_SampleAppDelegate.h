//
//  Bullet_Cocos3D_Wrapper_SampleAppDelegate.h
//  Bullet-Cocos3D-Wrapper-Sample
//
//  Created by Scot Olson on 6/30/11.
//  Copyright Rhonda Graphics Inc 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCNodeController.h"
#import "CC3World.h"

@interface Bullet_Cocos3D_Wrapper_SampleAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow* window;
	CCNodeController* viewController;
}

@property (nonatomic, retain) UIWindow* window;

@end
