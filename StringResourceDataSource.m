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
    return count;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    NSString * key = [allKeys objectAtIndex:row];
    if([ [tableColumn identifier] isEqualToString:@"1001"]){
        //column key
        [cell setStringValue:key];
        
    } else if([ [tableColumn identifier] isEqualToString:@"1002"]){
        //column english
         [cell setStringValue:[[stringResource englishDictionary] objectForKey:key]];
    } else if([ [tableColumn identifier] isEqualToString:@"1003"]){
        //column german
         [cell setStringValue:[[stringResource germanDictionary] objectForKey:key]];
    }
}

- (void)setStringResource:(StringResource *)aStringResource{
    stringResource = aStringResource;
    count = [[stringResource englishDictionary] count];
    allKeys = [[NSMutableArray alloc] initWithCapacity:count ] ;
      [allKeys addObjectsFromArray: [[stringResource englishDictionary] allKeys]];
}

@end
