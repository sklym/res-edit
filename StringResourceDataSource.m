//
//  StringResourceDataSource.m
//  resEditor
//
//  Created by Stanislav Fedorov on 10/09/15.
//
//

#import "StringResourceDataSource.h"
#import "StringResourceRow.h"

@implementation StringResourceDataSource

- (void)dealloc{
    [allKeys release];
    [stringResource release];
    [super dealloc];
}

/* Required method for the NSTableDataSource protocol. */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
    return count;
}

- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    StringResourceRow * stringResourceRow = [allKeys objectAtIndex:row];
    if([ [tableColumn identifier] isEqualToString:@"1001"]){
        //column key
        [cell setStringValue:[stringResourceRow key]];
        
    } else if([ [tableColumn identifier] isEqualToString:@"1002"]){
        //column english
         [cell setStringValue:[stringResourceRow english]];
    } else if([ [tableColumn identifier] isEqualToString:@"1003"]){
        //column german
         [cell setStringValue:[stringResourceRow german]];
    }
}

- (void)setStringResource:(StringResource *)aStringResource{
    stringResource = aStringResource;
    count = [[stringResource englishDictionary] count];
    allKeys = [[NSMutableArray alloc] initWithCapacity:count ] ;
    [[stringResource englishDictionary] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString * german = [[stringResource germanDictionary] objectForKey:key];
        [allKeys addObject:[[StringResourceRow alloc] initWithValues:key english:obj german:german]];
    }];    
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    NSArray * descriptors = [tableView sortDescriptors];
    [allKeys sortUsingDescriptors:descriptors];
    [tableView reloadData];
}

@end
