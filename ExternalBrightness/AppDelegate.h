//
//  AppDelegate.h
//  ExternalBrightness
//
//  Created by Julien Iseli on 25/04/16.
//  Copyright © 2016 Julien Iseli. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface AppDelegate : NSObject

@property (assign) IBOutlet NSMenu *statusMenu;
@property (strong, nonatomic) NSStatusItem *statusBar;

+ (void)setControlValue:(int)control :(int)value;
+ (int)readControlValue:(int)control;

@end

