//
//  FCView.m
//  resEditor
//
//  Created by Stanislav on 8/7/14.
//  Copyright 2014 __MyCompanyName__. All rights reserved.
//

#import "FCView.h"
#import "MainWindowController.h"
#include <stdio.h>
@implementation FCView

@synthesize textLeft;
@synthesize textTop;
@synthesize textRight;
@synthesize textBottom;

// -----------------------------------
// Initialize the View
// -----------------------------------

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		// setup the starting location of the
		// draggable item
		[self setItemPropertiesToDefault:self];
		widgets = [[ NSMutableArray alloc] initWithCapacity:10 ];
    }
    return self;
}

// -----------------------------------
// Release the View
// -----------------------------------

- (void)dealloc
{
    // release the color items and set
    // the instance variables to nil
    [itemColor release];
    itemColor=nil;
    
    [backgroundColor release];
    backgroundColor=nil;
    [widgets release];
	resource_node_free(root_res_node);
    // call super
    [super dealloc];
}

// -----------------------------------
// Draw the View Content
// -----------------------------------

- (void)drawRect:(NSRect)rect
{
    // erase the background by drawing white
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:rect];
    
    // set the current color for the draggable item
    [[self itemColor] set];
    
    // draw the draggable item
    if(dragging)
        [NSBezierPath strokeRect:[self calculatedItemBounds]];
	//draw widgets from tree
	if(root_res_node != nil)
		[self drawWidget: root_res_node];
	
	
}

- (void) drawWidget:(resource_t * )resNode{
	static NSRect parentRect;
	if (!(dragging && dragNode.node == resNode)){
        [NSBezierPath  strokeRect:NSMakeRect(parentRect.origin.x + resNode->_base.fr.left, parentRect.origin.y + resNode->_base.fr.top,
                                             (resNode->_base.fr.right - resNode->_base.fr.left),
                                             (resNode->_base.fr.bottom - resNode->_base.fr.top))];
        if(resNode->childs){
            parentRect.origin.x = parentRect.origin.x + resNode->_base.fr.left;
            parentRect.origin.y = parentRect.origin.y + resNode->_base.fr.top;
            for(int i = 0; i < resNode->childs->length; ++i){
                [self drawWidget: (resNode->childs->at(resNode->childs, i)) ];
            }
            parentRect.origin.x = parentRect.origin.x - resNode->_base.fr.left;
            parentRect.origin.y = parentRect.origin.y - resNode->_base.fr.top;
        }
    }
}

- (void) setResourceNode:(resource_t * )resNode{
	if(root_res_node != nil){
		resource_node_free(root_res_node);
		root_res_node = nil;
	}
    
	root_res_node = resNode;
	NSRect rect = [self frame];
	rect.origin.x = 0;
	rect.origin.y = 0;
	
	[self display];
}

- (BOOL)isOpaque
{
    // If the background color is opaque, return YES
    // otherwise, return NO
    return [[self backgroundColor] alphaComponent] >= 1.0 ? YES : NO;
}

- (BOOL)isFlipped {
	return YES;
}

// -----------------------------------
// Modify the item location
// -----------------------------------

- (void)offsetLocationByX:(float)x andY:(float)y
{
    // tell the display to redraw the old rect
    [self updateRect];
	
    // since the offset can be generated by both mouse moves
    // and moveUp:, moveDown:, etc.. actions, we'll invert
    // the deltaY amount based on if the view is flipped or
    // not.
    int invertDeltaY = 1;
    dragNode.rect.origin.x += x;
    dragNode.rect.origin.y += y*invertDeltaY;
    
    // invalidate the new rect location so that it'll
    // be redrawn
    [self updateRect];
    
}

// -----------------------------------
// Hit test the item
// -----------------------------------

- (BOOL)isPointInItem:(NSPoint)testPoint
{
    BOOL itemHit=NO;
    
    // test first if we're in the rough bounds
    itemHit = NSPointInRect(testPoint,[self calculatedItemBounds]);
    
    // yes, lets further refine the testing
    if (itemHit) {
		
    }
	
    return itemHit;
}

- (NSRect) widgetRect:(NSPoint)testPoint ResNode:(resource_t * )resNode SelNode:(resource_t **) selNode{
	static NSRect parentRect;
	NSRect node = NSMakeRect(parentRect.origin.x + resNode->_base.fr.left, parentRect.origin.y + resNode->_base.fr.top,
							 (resNode->_base.fr.right - resNode->_base.fr.left),
							 (resNode->_base.fr.bottom - resNode->_base.fr.top));
	if (NSPointInRect(testPoint,node)){
		*selNode = (resNode);
		//check child layers
        if(resNode->childs){
			parentRect.origin.x = parentRect.origin.x + resNode->_base.fr.left;
			parentRect.origin.y = parentRect.origin.y + resNode->_base.fr.top;
			for(int i = 0; i < resNode->childs->length; ++i){
				NSRect retnode = [self widgetRect: testPoint ResNode:(resNode->childs->at(resNode->childs, i)) SelNode:selNode];
				if( !(retnode.origin.x == 0 &&
					  retnode.origin.y == 0 &&
					  retnode.size.width == 0 &&
					  retnode.size.height == 0) ){
					node = retnode;
				}
			}
			parentRect.origin.x = parentRect.origin.x - resNode->_base.fr.left;
			parentRect.origin.y = parentRect.origin.y - resNode->_base.fr.top;
		}
		return node;
	} else {
		return NSMakeRect(0,0,0,0);
	}
}

// -----------------------------------
// Handle Mouse Events
// -----------------------------------

-(void)mouseDown:(NSEvent *)event
{
    NSPoint clickLocation;
    BOOL itemHit=NO;
    
    // convert the click location into the view coords
    clickLocation = [self convertPoint:[event locationInWindow]
							  fromView:nil];
    /*
     // did the click occur in the item?
     itemHit = [self isPointInItem:clickLocation];
     
     // Yes it did, note that we're starting to drag
     if (itemHit) {
     // flag the instance variable that indicates
     // a drag was actually started
     dragging=YES;
     
     // store the starting click location;
     lastDragLocation=clickLocation;
     
     // set the cursor to the closed hand cursor
     // for the duration of the drag
     [[NSCursor closedHandCursor] push]; //openHandCursor
     }
     */
	resource_t * selNode = nil;
	NSRect nodeRect = [self widgetRect:clickLocation ResNode:root_res_node SelNode:&selNode];
	if( !(nodeRect.origin.x == 0 &&
		  nodeRect.origin.y == 0 &&
		  nodeRect.size.width == 0 &&
		  nodeRect.size.height == 0) ){
		
		
		MainWindowController * wc = [[self window]  windowController];
		
		[wc setRectLeft:selNode->_base.fr.left Top:selNode->_base.fr.top Right:selNode->_base.fr.right Bottom:selNode->_base.fr.bottom];
        [wc setName: [[[NSString alloc] initWithUTF8String:selNode->type ] autorelease]];
        [self setLocation:nodeRect.origin];
        dragNode.node = selNode;
        dragNode.rect = nodeRect;
        dragNode.offsetX = nodeRect.origin.x - selNode->_base.fr.left;
        dragNode.offsetY = nodeRect.origin.y - selNode->_base.fr.top;
        dragging = YES;
		
		// store the starting click location;
		lastDragLocation=clickLocation;
        [[NSCursor openHandCursor] push];
	}
	
}
-(void)updateDragCoordinat{
    MainWindowController * wc = [[self window]  windowController];
    double left = dragNode.rect.origin.x - dragNode.offsetX;
    double top = dragNode.rect.origin.y - dragNode.offsetY;
    double bottom = dragNode.rect.origin.y + dragNode.rect.size.height - dragNode.offsetY;
    double right = dragNode.rect.origin.x + dragNode.rect.size.width - dragNode.offsetX;
    [wc setRectLeft:left Top:top Right:right Bottom:bottom];
}


-(void)mouseDragged:(NSEvent *)event
{
    if (dragging) {
		NSPoint newDragLocation=[self convertPoint:[event locationInWindow]
										  fromView:nil];
		
		
		// offset the pill by the change in mouse movement
		// in the event
		[self offsetLocationByX:(newDragLocation.x-lastDragLocation.x)
						   andY:(newDragLocation.y-lastDragLocation.y)];
		
		// save the new drag location for the next drag event
		lastDragLocation=newDragLocation;
		
		// support automatic scrolling during a drag
		// by calling NSView's autoscroll: method
		[self autoscroll:event];
        [self updateDragCoordinat ];
    }
}

-(void)mouseUp:(NSEvent *)event
{
    dragNode.node->_base.fr.left = dragNode.rect.origin.x - dragNode.offsetX;
    dragNode.node->_base.fr.top = dragNode.rect.origin.y - dragNode.offsetY;
    dragNode.node->_base.fr.bottom = dragNode.rect.origin.y + dragNode.rect.size.height - dragNode.offsetY;
    dragNode.node->_base.fr.right = dragNode.rect.origin.x + dragNode.rect.size.width - dragNode.offsetX;
    dragging=NO;
    
    // finished dragging, restore the cursor
    [NSCursor pop];
    [self updateRect];
    // the item has moved, we need to reset our cursor
    // rectangle
    [[self window] invalidateCursorRectsForView:self];
    
}




// -----------------------------------
// First Responder Methods
// -----------------------------------

- (BOOL)acceptsFirstResponder
{
    return YES;
}



// -----------------------------------
// Handle KeyDown Events
// -----------------------------------


- (void)keyDown:(NSEvent *)event
{
    BOOL handled = NO;
    NSString  *characters;
    
    // get the pressed key
    characters = [event charactersIgnoringModifiers];
    
    // is the "r" key pressed?
    if ([characters isEqual:@"r"]) {
		// Yes, it is
		handled = YES;
		
		// set the rectangle properties
		[self setItemPropertiesToDefault:self];
    }
    if (!handled)
		[super keyDown:event];
    
}


- (IBAction)setItemPropertiesToDefault:(id)sender
{
    [self setLocation:NSMakePoint(0.0f,0.0f)];
    [self setItemColor:[NSColor grayColor]];
    [self setBackgroundColor:[NSColor whiteColor]];
}



// -----------------------------------
// Handle color changes via first responder
// -----------------------------------

- (void)changeColor:(id)sender
{
    // Set the color in response
    // to the color changing in the color panel.
    // get the new color by asking the sender, the color panel
    [self setItemColor:[sender color]];
}




// -----------------------------------
// Reset Cursor Rects
// -----------------------------------

-(void)resetCursorRects
{
    // remove the existing cursor rects
    [self discardCursorRects];
    
    // add the draggable item's bounds as a cursor rect
    [self addCursorRect:[self calculatedItemBounds] cursor:[NSCursor openHandCursor]];
    
}

// -----------------------------------
//  Accessor Methods
// -----------------------------------

- (void)setItemColor:(NSColor *)aColor
{
	if (![itemColor isEqual:aColor]) {
        [itemColor release];
        itemColor = [aColor retain];
		
		// if the colors are not equal, mark the
		// draggable rect as needing display
        [self updateRect];
    }
}


- (NSColor *)itemColor
{
    return [[itemColor retain] autorelease];
}

- (void)setBackgroundColor:(NSColor *)aColor
{
	if (![backgroundColor isEqual:aColor]) {
        [backgroundColor release];
        backgroundColor = [aColor retain];
		
		// if the colors are not equal, mark the
		// draggable rect as needing display
        [self updateRect];
    }
}


- (NSColor *)backgroundColor
{
    return [[backgroundColor retain] autorelease];
}

- (void) updateRect{
    NSRect rect = [self calculatedItemBounds];
    rect.origin.x -= 1;
    rect.origin.y -= 1;
    rect.size.height += 2;
    rect.size.width +=2;
    [self setNeedsDisplayInRect:rect];
}

- (void)setLocation:(NSPoint)point
{
    // test to see if the point actually changed
    if (!NSEqualPoints(point,dragNode.rect.origin)) {
        // tell the display to redraw the old rect
		[self updateRect];
		
        // reassign the rect
		dragNode.rect.origin=point;
		
        // display the new rect
		[self updateRect];
		
        // invalidate the cursor rects
		[[self window] invalidateCursorRectsForView:self];
    }
}

- (NSPoint)location {
    return location;
}


- (NSRect)calculatedItemBounds
{
    NSRect calculatedRect;
    
    // calculate the bounds of the draggable item
    // relative to the location
    
    
    if(dragNode.node != NULL){
        
        
        calculatedRect.origin = dragNode.rect.origin;
        calculatedRect.size = dragNode.rect.size;
        
    } else {
        // the example assumes that the width and height
        // are fixed values
        calculatedRect.origin=location;
        calculatedRect.size.width=60.0f;
        calculatedRect.size.height=20.0f;
    }
    
    return calculatedRect;
}



@end
