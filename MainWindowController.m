//
//  MainWindowController.m
//  resEditor
//
//  Created by Stanislav on 8/14/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "MainWindowController.h"


@implementation MainWindowController


@synthesize textArea_;
@synthesize custView;
@synthesize textLeft;
@synthesize textTop;
@synthesize textRight;
@synthesize textBottom;

- (void) setRectLeft:(int)left Top:(int)top Right:(int) right Bottom:(int)bottom{
	[textLeft setIntValue:left];
	[textTop setIntValue:top];
	[textRight setIntValue:right];
	[textBottom setIntValue:bottom];
}

@end
