//
//  resEditorAppDelegate.h
//  resEditor
//
//  Created by Stanislav on 7/29/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "model.h"
#import "MainWindowController.h"

@interface resEditorAppDelegate : NSObject <NSApplicationDelegate> {
	NSWindow *window;
	NSString * workFilePath_;
	
}
@property (assign) IBOutlet NSWindow *window;


- (void) openEditor: (NSString *) inPath;
- (void) show: (resource_t *) res_node Text:(NSMutableString *) text;
- (void) tabs : (NSMutableString*) text TabNumber:(int)x ;
@end

@interface resEditorAppDelegate (MenuAction)
	- (IBAction) openFile:(id)sender;
@end