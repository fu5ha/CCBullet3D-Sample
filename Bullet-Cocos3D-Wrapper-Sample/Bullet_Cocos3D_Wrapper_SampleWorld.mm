//
//  Bullet_Cocos3D_Wrapper_SampleWorld.m
//  Bullet-Cocos3D-Wrapper-Sample
//
//  Created by Scot Olson on 6/30/11.
//  Copyright Rhonda Graphics Inc 2011. All rights reserved.
//

extern "C" {
#import "CC3Foundation.h"  
};

#import "Bullet_Cocos3D_Wrapper_SampleWorld.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"
#import "CC3PODMaterial.h"
#import "cocos2d.h"

@implementation Bullet_Cocos3D_Wrapper_SampleWorld

-(void) dealloc {
	[super dealloc];
}

/**
 * Constructs the 3D world.
 *
 * Adds 3D objects to the world, loading a 3D 'hello, world' message
 * from a POD file, and creating the camera and light programatically.
 *
 * When adapting this template to your application, remove all of the content
 * of this method, and add your own to construct your 3D model world.
 *
 * NOTE: The POD file used for the 'hello, world' message model is fairly large,
 * because converting a font to a mesh results in a LOT of triangles. When adapting
 * this template project for your own application, REMOVE the POD file 'hello-world.pod'
 * from the Resources folder of your project!!
 */
-(void) initializeWorld {
    
    _physicsWorld = [[CC3PhysicsWorld alloc] init];
    [_physicsWorld setGravity:0 y:-9.8 z:0];
    
    
	// Create the camera, place it back a bit, and add it to the world
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v( 0.0, 3.0, 30.0 );
	[self addChild: cam];
    
	// Create a light, place it back and to the left at a specific
	// position (not just directional lighting), and add it to the world
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
	lamp.location = cc3v( -2.0, 0.0, 0.0 );
	lamp.isDirectionalOnly = NO;
	[cam addChild: lamp];
    
	// This is the simplest way to load a POD resource file and add the
	// nodes to the CC3World, if no customized resource subclass is needed.
    [CC3PODMaterial setShininessExpansionFactor:128.0];
	[self addContentFromPODResourceFile: @"hello-world.pod"];
    [self addContentFromPODResourceFile: @"test.pod"];
    [self addContentFromPODResourceFile: @"Sphere_POD.pod"];
	// Create OpenGL ES buffers for the vertex arrays to keep things fast and efficient,
	// and to save memory, release the vertex data in main memory because it is now redundant.
	[self createGLBuffers];
	[self releaseRedundantData];
	
	// That's it! The model world is now constructed and is good to go.
	
	// ------------------------------------------
    
	// But to add some dynamism, we'll animate the 'hello, world' message
	// using a couple of cocos2d actions...
	
	// Fetch the 'hello, world' 3D text object that was loaded from the
	// POD file and start it rotating
	CC3MeshNode* helloTxt = (CC3MeshNode*)[self getNodeNamed: @"Hello"];
    CC3MeshNode* groundNode = (CC3MeshNode*)[self getNodeNamed:@"Cube"];
    CC3MeshNode* sphereNode = (CC3MeshNode*)[self getNodeNamed:@"Sphere"];
    CC3MeshNode* sphereNode2 = [sphereNode copy];
    [self addChild:sphereNode2];
	
	// To make things a bit more appealing, set up a repeating up/down cycle to
	// change the color of the text from the original red to blue, and back again.
	GLfloat tintTime = 8.0f;
	ccColor3B startColor = helloTxt.color;
	ccColor3B endColor = { 50, 0, 200 };
	CCActionInterval* tintDown = [CCTintTo actionWithDuration: tintTime
														  red: endColor.r
														green: endColor.g
														 blue: endColor.b];
	CCActionInterval* tintUp = [CCTintTo actionWithDuration: tintTime
														red: startColor.r
													  green: startColor.g
													   blue: startColor.b];
    CCActionInterval* tintCycle = [CCSequence actionOne: tintDown two: tintUp];
	[helloTxt runAction: [CCRepeatForever actionWithAction: tintCycle]];
    [sphereNode2 runAction: [CCRepeatForever actionWithAction: tintCycle]];
    btCollisionShape *sphereShape = new btSphereShape(1);
    btCollisionShape *helloShape = new btBoxShape(btVector3(1,1.5,0.1));
    btCollisionShape *groundShape = new btBoxShape(btVector3(5,0.1,5));
    helloTxt.location = cc3v(2,20,0);
    sphereNode2.location = cc3v(-0.75,17,0);
    sphereNode.location = cc3v(0,10,0);
    CC3PhysicsObject3D *helloObject = [_physicsWorld createPhysicsObject:helloTxt shape:helloShape mass:1 restitution:0.8 position:helloTxt.location];
    CC3PhysicsObject3D *groundObject = [_physicsWorld createPhysicsObject:groundNode shape:groundShape mass:0 restitution:1.0 position:groundNode.location];
    sphereObject = [_physicsWorld createPhysicsObject:sphereNode shape:sphereShape mass:2 restitution:1.0 position:sphereNode.location];
    CC3PhysicsObject3D *sphereObject2 = [_physicsWorld createPhysicsObject:sphereNode2 shape:sphereShape mass:0.5 restitution:1.0 position:sphereNode2.location];
    sphereObject.rigidBody->setDamping(0.1,0.8);
    sphereObject2.rigidBody->setDamping(0.1,0.8);
    [sphereObject applyImpulse:cc3v(0,2,0) withPosition:cc3v(sphereObject.node.location.x, sphereObject.node.location.y + 0.5, sphereObject.node.location.z)];
    [sphereObject2 applyImpulse:cc3v(0.5,0,0.5) withPosition:sphereObject2.node.location];
}


/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides this node with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the node. The similar and complimentary
 * method updateAfterTransform: is automatically invoked after the transformMatrix has been
 * recalculated. If you need to make changes to the transform properties (location, rotation,
 * scale) of the node, or any child nodes, you should override this method to perform those
 * changes.
 *
 * The global transform properties of a node (globalLocation, globalRotation, globalScale)
 * will not have accurate values when this method is run, since they are only valid after
 * the transformMatrix has been updated. If you need to make use of the global properties
 * of a node (such as for collision detection), override the udpateAfterTransform: method
 * instead, and access those properties there.
 *
 * The specified visitor encapsulates the CC3World instance, to allow this node to interact
 * with other nodes in its world.
 *
 * The visitor also encapsulates the deltaTime, which is the interval, in seconds, since
 * the previous update. This value can be used to create realistic real-time motion that
 * is independent of specific frame or update rates. Depending on the setting of the
 * maxUpdateInterval property of the CC3World instance, the value of dt may be clamped to
 * an upper limit before being passed to this method. See the description of the CC3World
 * maxUpdateInterval property for more information about clamping the update interval.
 *
 * As described in the class documentation, in keeping with best practices, updating the
 * model state should be kept separate from frame rendering. Therefore, when overriding
 * this method in a subclass, do not perform any drawing or rending operations. This
 * method should perform model updates only.
 *
 * This method is invoked automatically at each scheduled update. Usually, the application
 * never needs to invoke this method directly.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {}

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides this node with an opportunity to perform update activities after
 * the transformMatrix of the node has been recalculated. The similar and complimentary
 * method updateBeforeTransform: is automatically invoked before the transformMatrix
 * has been recalculated.
 *
 * The global transform properties of a node (globalLocation, globalRotation, globalScale)
 * will have accurate values when this method is run, since they are only valid after the
 * transformMatrix has been updated. If you need to make use of the global properties
 * of a node (such as for collision detection), override this method.
 *
 * Since the transformMatrix has already been updated when this method is invoked, if
 * you override this method and make any changes to the transform properties (location,
 * rotation, scale) of any node, you should invoke the updateTransformMatrices method of
 * that node, to have its transformMatrix, and those of its child nodes, recalculated.
 *
 * The specified visitor encapsulates the CC3World instance, to allow this node to interact
 * with other nodes in its world.
 *
 * The visitor also encapsulates the deltaTime, which is the interval, in seconds, since
 * the previous update. This value can be used to create realistic real-time motion that
 * is independent of specific frame or update rates. Depending on the setting of the
 * maxUpdateInterval property of the CC3World instance, the value of dt may be clamped to
 * an upper limit before being passed to this method. See the description of the CC3World
 * maxUpdateInterval property for more information about clamping the update interval.
 *
 * As described in the class documentation, in keeping with best practices, updating the
 * model state should be kept separate from frame rendering. Therefore, when overriding
 * this method in a subclass, do not perform any drawing or rending operations. This
 * method should perform model updates only.
 *
 * This method is invoked automatically at each scheduled update. Usually, the application
 * never needs to invoke this method directly.
 */
-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {
    [_physicsWorld synchTransformation];
}

@end

