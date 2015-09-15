//
//  StringResourceRow.m
//  resEditor
//
//  Created by Stanislav Fedorov on 15/09/15.
//
//

#import "StringResourceRow.h"

@implementation StringResourceRow

@synthesize key;
@synthesize english;
@synthesize german;

-(instancetype) initWithValues:(NSString*) keyIn english:(NSString*) englishIn german:(NSString*) germanIn{
    self = [super init];
    if(self){
        self.key = keyIn;
        self.english = englishIn;
        self.german = germanIn;
        
    }
    return self;
}

-(void) dealloc{
    [super dealloc];
}

@end
