//
//  FCView.h
//  resEditor
//
//  Created by Stanislav on 8/7/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "model.h"

struct widget_pl{
	NSRect rect;
	resource_t * node;
    double offsetX;
    double offsetY;
};


@interface FCView : NSView {
	NSPoint location;
    NSColor *itemColor;
    NSColor *backgroundColor;
    struct widget_pl dragNode;
    
    // private variables that track state
    BOOL dragging;
    NSPoint lastDragLocation;
    
    NSMutableArray * widgets;
	resource_t * root_res_node;
	
	NSTextField * textLeft;
	NSTextField * textTop;
	NSTextField * textRight;
	NSTextField * textBottom;
}

@property (assign) IBOutlet NSTextField * textLeft;
@property (assign) IBOutlet NSTextField * textTop;
@property (assign) IBOutlet NSTextField * textRight;
@property (assign) IBOutlet NSTextField * textBottom;


- (void) drawWidget:(resource_t * )resNode;
- (void) setResourceNode:(resource_t * )resNode;

- (id)initWithFrame:(NSRect)frame;

// -----------------------------------
// Draw the View Content
// -----------------------------------

- (void)drawRect:(NSRect)rect;
- (BOOL)isOpaque;
- (BOOL)isFlipped;
// -----------------------------------
// Modify the Rectange location 
// -----------------------------------

- (void)offsetLocationByX:(float)x andY:(float)y;
// -----------------------------------
// Handle Mouse Events 
// -----------------------------------

-(void)mouseDown:(NSEvent *)event;
-(void)mouseDragged:(NSEvent *)event;
-(void)mouseUp:(NSEvent *)event;

// -----------------------------------
// First Responder Methods
// -----------------------------------

- (BOOL)acceptsFirstResponder;
// -----------------------------------
// Handle KeyDown Events 
// -----------------------------------
- (void)keyDown:(NSEvent *)event;

// -----------------------------------
// Handle color changes via first responder 
// -----------------------------------
- (void)changeColor:(id)sender;

// -----------------------------------
// Reset Cursor Rects 
// -----------------------------------
-(void)resetCursorRects;

// -----------------------------------
// Handle NSResponder Actions 
// -----------------------------------

-(IBAction)setItemPropertiesToDefault:(id)sender;


// -----------------------------------
// Various Accessor Methods
// -----------------------------------
- (void)setItemColor:(NSColor *)aColor;
- (NSColor *)itemColor;

- (void)setLocation:(NSPoint)point;
- (NSPoint)location;
- (NSRect)calculatedItemBounds;

- (void)setBackgroundColor:(NSColor *)aColor;
- (NSColor *)backgroundColor;

- (BOOL)isPointInItem:(NSPoint)testPoint;
- (NSRect) widgetRect:(NSPoint)testPoint ResNode:(resource_t * )resNode SelNode:(resource_t **) selNode;
- (void)updateRect;
- (void)updateDragCoordinat;
///////////////


@end
