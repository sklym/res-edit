//
//  MenuAction.m
//  resEditor
//
//  Created by Stanislav on 7/29/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//


#import "resEditorAppDelegate.h"

@implementation resEditorAppDelegate (MenuAction)

- (IBAction) openFile:(id)sender
{
	
    NSString * title = @"Open resource file";
    //}
    
	NSOpenPanel* panel = [[NSOpenPanel openPanel] retain];
	
    [panel setCanChooseDirectories: YES];
    [panel setCanChooseFiles: YES];
    [panel setAllowsMultipleSelection: NO];
    [panel setTitle: title];
	[panel setCanCreateDirectories: NO];
	NSString *frType = @"fr";
	NSMutableArray * filetypes = [NSMutableArray arrayWithCapacity:1];
	[filetypes addObject:frType];	
	[panel setAllowedFileTypes: filetypes];
	
	if ([panel runModal] == NSFileHandlingPanelOKButton)
    {
		NSString * workFilePath = [[NSString alloc] initWithString: [panel filename]];
		[self openEditor: [workFilePath retain]];
		[workFilePath release];
	}
    [panel release];
		//return nil;
}

@end
