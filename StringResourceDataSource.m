//
//  StringResourceDataSource.m
//  resEditor
//
//  Created by Stanislav Fedorov on 10/09/15.
//
//

#import "StringResourceDataSource.h"

@implementation StringResourceDataSource
/* Required method for the NSTableDataSource protocol. */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
    return 1;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if([ [tableColumn identifier] isEqualToString:@"1001"]){
        //column key
        [cell setStringValue:@"kTest"];
    } else if([ [tableColumn identifier] isEqualToString:@"1002"]){
        //column english
         [cell setStringValue:@"PageRobot Preferences"];
    } else if([ [tableColumn identifier] isEqualToString:@"1003"]){
        //column german
         [cell setStringValue:@"Die globalen PageRobot-Variablen werden geprüft..."];
    }
}

- (void)setStringResource:(StringResource *)aStringResource{
    stringResource = aStringResource;
}

@end
