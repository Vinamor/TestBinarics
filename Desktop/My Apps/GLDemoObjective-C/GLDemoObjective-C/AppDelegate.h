//
//  AppDelegate.h
//  GLDemoObjective-C
//
//  Created by Ostap Romaniv on 9/12/17.
//  Copyright © 2017 Ostap Romaniv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

