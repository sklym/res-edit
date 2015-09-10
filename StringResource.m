//
//  StringResource.m
//  resEditor
//
//  Created by Stanislav Fedorov on 10/09/15.
//
//

#import "StringResource.h"

#define GERMAN_LOCALE   "k_deDE"
#define ENGLISH_LOCALE  "k_enUS"
#define RESOURCE        "resource"

@implementation StringResource

- (id)init{
    self = [super init];
    if(self){
        englishDictionary = [[NSMutableDictionary alloc] init];
        germanDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc{
    [englishDictionary release];
    [germanDictionary release];
    [super dealloc];
}

-(void)parse:(NSString *)path{
    
    NSError *error = nil;
	NSString *resFileString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if(!resFileString){
        //error
        return;
    }
    
}

@end
