//
//  Bullet_Cocos3D_Wrapper_SampleLayer.m
//  Bullet-Cocos3D-Wrapper-Sample
//
//  Created by Scot Olson on 6/30/11.
//  Copyright Rhonda Graphics Inc 2011. All rights reserved.
//

#import "Bullet_Cocos3D_Wrapper_SampleLayer.h"
#import "Bullet_Cocos3D_Wrapper_SampleWorld.h"


@implementation Bullet_Cocos3D_Wrapper_SampleLayer
- (void)dealloc {
    [super dealloc];
}


/**
 * Template method that is invoked automatically during initialization, regardless
 * of the actual init* method that was invoked. Subclasses can override to set up their
 * 2D controls and other initial state without having to override all of the possible
 * superclass init methods.
 *
 * The default implementation does nothing. It is not necessary to invoke the
 * superclass implementation when overriding in a subclass.
 */
-(void) initializeControls {}

 // The ccTouchMoved:withEvent: method is optional for the <CCTouchDelegateProtocol>.
 // The event dispatcher will not dispatch events for which there is no method
 // implementation. Since the touch-move events are both voluminous and seldom used,
 // the implementation of ccTouchMoved:withEvent: has been left out of the default
 // CC3Layer implementation. To receive and handle touch-move events for object
 // picking,uncomment the following method implementation. To receive touch events,
 // you must also set the isTouchEnabled property of this instance to YES.
/*
 // Handles intermediate finger-moved touch events. 
-(void) ccTouchMoved: (UITouch *)touch withEvent: (UIEvent *)event {
	[self handleTouch: touch ofType: kCCTouchMoved];
}
*/

@end
