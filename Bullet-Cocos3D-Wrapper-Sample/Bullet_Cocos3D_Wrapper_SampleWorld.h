//
//  Bullet_Cocos3D_Wrapper_SampleWorld.h
//  Bullet-Cocos3D-Wrapper-Sample
//
//  Created by Scot Olson on 6/30/11.
//  Copyright Rhonda Graphics Inc 2011. All rights reserved.
//


#import "CC3PhysicsWorld.h"
#import "CC3PhysicsObject3D.h"
#import "CC3World.h"
#import "CC3MeshNode.h"
#import "btBulletDynamicsCommon.h"

/** A sample application-specific CC3World subclass.*/
@interface Bullet_Cocos3D_Wrapper_SampleWorld : CC3World {
    CC3PhysicsObject3D *sphereObject;
    CC3PhysicsWorld *_physicsWorld;
}

@end
