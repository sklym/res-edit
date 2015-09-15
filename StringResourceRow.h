//
//  StringResourceRow.h
//  resEditor
//
//  Created by Stanislav Fedorov on 15/09/15.
//
//

#import <Foundation/Foundation.h>

@interface StringResourceRow : NSObject{
    NSString * key;
    NSString * english;
    NSString * german;
}
@property(assign,readwrite) NSString * key;
@property (assign,readwrite) NSString * english;
@property (assign,readwrite) NSString * german;

-(instancetype) initWithValues:(NSString*) key english:(NSString*) english german:(NSString*) german;
@end
