//
//  MenuAction.m
//  resEditor
//
//  Created by Stanislav on 7/29/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//


#import "resEditorAppDelegate.h"
#import "StringResource.h"
#import "StringResourceDataSource.h"
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

- (IBAction) openStringResourceFile: (id)sender{
    //   [windowStringResource orderFront:sender];
    //   return;
    NSString * title = @"Open String Resource File";
    
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
        StringResource* strRes = [[StringResource alloc] init];
		NSString * workFilePath = [[NSString alloc] initWithString: [panel filename]];
		//english
        [strRes parse:workFilePath];
        //german - try open german resource file
        NSUInteger length = [workFilePath length];
        NSString * dePath = [NSString stringWithFormat:@"%@deDE.fr",[workFilePath substringToIndex:length - 7] ];
        [strRes parse:dePath];
        
        StringResourceDataSource * strDataSource = [[[windowStringResource windowController] tableView] dataSource];
        [strDataSource setStringResource:strRes];
		[workFilePath release];
        [[[windowStringResource windowController] tableView] reloadData];
        [windowStringResource orderFront:sender];
	}
    
    [panel release];
    
}

@end
