//
//  MainWindowController.h
//  resEditor
//
//  Created by Stanislav on 8/14/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FCView.h"

@interface MainWindowController : NSWindowController {
	
	NSTextField * textArea_;
	FCView * custView;
	NSTextField * textLeft;
	NSTextField * textTop;
	NSTextField * textRight;
	NSTextField * textBottom;
}

- (void) setRectLeft:(int)left Top:(int)top Right:(int) right Bottom:(int)bottom; 

@property (assign) IBOutlet NSTextField * textArea_;
@property (assign) IBOutlet FCView * custView;
@property (assign) IBOutlet NSTextField * textLeft;
@property (assign) IBOutlet NSTextField * textTop;
@property (assign) IBOutlet NSTextField * textRight;
@property (assign) IBOutlet NSTextField * textBottom;

@end
