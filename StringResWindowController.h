//
//  StringResWindowController.h
//  resEditor
//
//  Created by Stanislav Fedorov on 11/09/15.
//
//

#import <Cocoa/Cocoa.h>

@interface StringResWindowController : NSWindowController{
    NSTableView * tableView;
}
@property (assign) IBOutlet NSTableView * tableView;

@end
