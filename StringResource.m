//
//  StringResource.m
//  resEditor
//
//  Created by Stanislav Fedorov on 10/09/15.
//
//

#import "StringResource.h"

#define GERMAN_LOCALE   @"k_deDE"
#define ENGLISH_LOCALE  @"k_enUS"
#define RESOURCE        @"resource"

@implementation StringResource

@synthesize englishDictionary;
@synthesize germanDictionary;

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
    NSScanner * scanner = [NSScanner scannerWithString:resFileString];
    //english
    if([scanner scanUpToString:RESOURCE intoString:NULL] &&
       [scanner scanUpToString:@"{" intoString:NULL]){
        NSUInteger scanLocation = [scanner scanLocation];
        if([scanner scanUpToString:ENGLISH_LOCALE intoString:NULL] &&
           [scanner scanUpToString:@"{" intoString:NULL]){
            [scanner scanUpToString:@"{" intoString:NULL];
            NSString * keyValueData;
            [scanner scanUpToString:@"}" intoString:&keyValueData];
            [self parseKeyValue:keyValueData dictionary:englishDictionary];
        }else{
            [scanner setScanLocation:scanLocation];
        }
        
        if( [scanner scanUpToString:GERMAN_LOCALE intoString:NULL] &&
           [scanner scanUpToString:@"{" intoString:NULL]){
            [scanner scanUpToString:@"{" intoString:NULL];
            NSString * keyValueData;
            [scanner scanUpToString:@"}" intoString:&keyValueData];
            [self parseKeyValue:keyValueData dictionary:germanDictionary];
        }
    }
    
}
-(void) parseKeyValue:(NSString*)keyValueData dictionary: (NSMutableDictionary*) dictionary{
    NSScanner * scanner = [NSScanner scannerWithString:keyValueData];
    [scanner setCharactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
    NSCharacterSet * comments = [NSCharacterSet characterSetWithCharactersInString:@"//"];
    NSCharacterSet * comma = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSCharacterSet * newLine = [NSCharacterSet newlineCharacterSet];
    NSCharacterSet* letter = [NSCharacterSet letterCharacterSet];
    NSCharacterSet* punctuation = [NSCharacterSet punctuationCharacterSet];
    
    NSUInteger scanLocation = [scanner scanLocation];
    while([scanner isAtEnd] == NO){
        scanLocation = [scanner scanLocation];
        if([scanner scanCharactersFromSet:comments intoString:NULL]){
            [scanner scanUpToCharactersFromSet:newLine intoString:NULL];
            [scanner scanCharactersFromSet:newLine intoString:NULL];
            continue;
        } else if([scanner scanString:@"k" intoString:NULL]){
            [scanner setScanLocation:--scanLocation];
            [scanner scanUpToString:@"k" intoString:NULL];
            NSString * key;
            [scanner scanUpToCharactersFromSet:comma intoString:&key];
            
            NSMutableString * value = [[NSMutableString alloc] init];
            [scanner scanString:@"," intoString:NULL];
            while([scanner scanString:@"," intoString:NULL] == NO){
                scanLocation = [scanner scanLocation];
                if([scanner scanString:@"\"" intoString:NULL]){
                    NSString * prValue;
                    [scanner scanUpToString:@"\"" intoString:&prValue];
                    [value appendFormat:@"\"%@\"",prValue];
                    [scanner scanString:@"\"" intoString:NULL];
                    continue;
                } else if([scanner scanCharactersFromSet:letter intoString:NULL]){
                    NSString * prValue;
                    [scanner setScanLocation:--scanLocation];
                    [scanner scanUpToCharactersFromSet:letter intoString:NULL];
                    [scanner scanUpToCharactersFromSet:punctuation intoString:&prValue];
                    [value appendString:prValue];
                } else
                    [scanner setScanLocation:++scanLocation];
            }
            NSLog(@"Key-%@, Value-%@", key, value);
            [dictionary setObject:value forKey:key];
            [value release];
            
            
        } else
            [scanner setScanLocation:++scanLocation];
    }
}



@end
