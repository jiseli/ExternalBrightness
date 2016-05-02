//
//  AppDelegate.m
//  ExternalBrightness
//
//  Created by Julien Iseli on 25/04/16.
//  Copyright © 2016 Julien Iseli. All rights reserved.
//

#include "ddc.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize statusBar = _statusBar;

- (void) awakeFromNib {
  self.statusBar = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  //_statusBar.title = @"G";
  _statusBar.image = [NSImage imageNamed:@"Status"];
  [_statusBar.image setTemplate:YES];
  _statusBar.highlightMode = YES;
  _statusBar.toolTip = @"Controls external display brightness";
  _statusBar.menu = self.statusMenu;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  
  NSLog(@"Registering hotkeys...");
  
  // Register the Hotkeys
  EventHotKeyRef gMyHotKeyRef;
  EventHotKeyID gMyHotKeyID;
  EventTypeSpec eventType;
  eventType.eventClass = kEventClassKeyboard;
  eventType.eventKind = kEventHotKeyPressed;
  InstallApplicationEventHandler(&MyHotKeyHandler, 1, &eventType, NULL, NULL);
  
  // Brightness Down: option + shift + left arrow
  gMyHotKeyID.signature = 'hkdw';
  gMyHotKeyID.id = 11;
  RegisterEventHotKey(123, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  // Brightness Up: option + shift + right arrow
  gMyHotKeyID.signature = 'hkup';
  gMyHotKeyID.id = 12;
  RegisterEventHotKey(124, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  // Set Brightness (option + shift + 1 [to 10])
  gMyHotKeyID.signature = 'htk1';
  gMyHotKeyID.id = 1;
  RegisterEventHotKey(18, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature = 'htk2';
  gMyHotKeyID.id = 2;
  RegisterEventHotKey(19, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature = 'htk3';
  gMyHotKeyID.id = 3;
  RegisterEventHotKey(20, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature = 'htk4';
  gMyHotKeyID.id = 4;
  RegisterEventHotKey(21, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature = 'htk5';
  gMyHotKeyID.id = 5;
  RegisterEventHotKey(23, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature = 'htk6';
  gMyHotKeyID.id = 6;
  RegisterEventHotKey(22, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature = 'htk7';
  gMyHotKeyID.id = 7;
  RegisterEventHotKey(26, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature = 'htk8';
  gMyHotKeyID.id = 8;
  RegisterEventHotKey(28, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature = 'htk9';
  gMyHotKeyID.id = 9;
  RegisterEventHotKey(25, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
  
  gMyHotKeyID.signature = 'htk0';
  gMyHotKeyID.id = 10;
  RegisterEventHotKey(29, optionKey + shiftKey, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
}

OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent, void *userData){
  EventHotKeyID hkCom;
  GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hkCom), NULL, &hkCom);
  int id = hkCom.id;
  int brightnessValue = 0;

  NSLog(@"HotKey handler called by %d", hkCom.signature);
  
  switch (id) {
    case 1:
      [AppDelegate setBrightness: 10];
      break;
    case 2:
      [AppDelegate setBrightness: 20];
      break;
    case 3:
      [AppDelegate setBrightness: 30];
      break;
    case 4:
      [AppDelegate setBrightness: 40];
      break;
    case 5:
      [AppDelegate setBrightness: 50];
      break;
    case 6:
      [AppDelegate setBrightness: 60];
      break;
    case 7:
      [AppDelegate setBrightness: 70];
      break;
    case 8:
      [AppDelegate setBrightness: 80];
      break;
    case 9:
      [AppDelegate setBrightness: 90];
      break;
    case 10:
      [AppDelegate setBrightness: 100];
      break;
    case 11:
      brightnessValue = [AppDelegate readControlValue:0x10];
      [AppDelegate setBrightness: brightnessValue + 10];
      break;
    case 12:
      brightnessValue = [AppDelegate readControlValue:0x10];
      [AppDelegate setBrightness: brightnessValue - 10];
      break;
  }
  
  return noErr;
}

+ (void)setBrightness:(int)value{
  [AppDelegate setControlValue:0x10 : value];
}

+ (void)setControlValue:(int)control :(int)value {
    struct DDCWriteCommand write_command;
    write_command.control_id = control;
    write_command.new_value = value;
    ddc_write(0, &write_command);
}

+ (int)readControlValue:(int)control {
    struct DDCReadCommand read_command;
    read_command.control_id = control;
    
    ddc_read(0, &read_command);
    return ((int)read_command.response.current_value);
}

- (IBAction)increaseBrightness:(NSMenuItem *)sender {
  int brightnessValue = [AppDelegate readControlValue:0x10];
  [AppDelegate setBrightness: brightnessValue + 10];
}

- (IBAction)decreaseBrightness:(NSMenuItem *)sender {
  int brightnessValue = [AppDelegate readControlValue:0x10];
  [AppDelegate setBrightness: brightnessValue - 10];
}

- (IBAction)setAt10:(NSMenuItem *)sender {
  [AppDelegate setBrightness: 10];
}

- (IBAction)setAt20:(NSMenuItem *)sender {
  [AppDelegate setBrightness: 20];
}

- (IBAction)setAt30:(NSMenuItem *)sender {
  [AppDelegate setBrightness: 30];
}

- (IBAction)setAt40:(NSMenuItem *)sender {
  [AppDelegate setBrightness: 40];
}

- (IBAction)setAt50:(NSMenuItem *)sender {
  [AppDelegate setBrightness: 50];
}

- (IBAction)setAt60:(NSMenuItem *)sender {
  [AppDelegate setBrightness: 60];
}

- (IBAction)setAt70:(NSMenuItem *)sender {
  [AppDelegate setBrightness: 70];
}

- (IBAction)setAt80:(NSMenuItem *)sender {
  [AppDelegate setBrightness: 80];
}

- (IBAction)setAt90:(NSMenuItem *)sender {
  [AppDelegate setBrightness: 90];
}

- (IBAction)setAt100:(NSMenuItem *)sender {
  [AppDelegate setBrightness: 100];
}

@end
