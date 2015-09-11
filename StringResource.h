//
//  StringResource.h
//  resEditor
//
//  Created by Stanislav Fedorov on 10/09/15.
//
//

#import <Foundation/Foundation.h>

@interface StringResource : NSObject{
    NSMutableDictionary * englishDictionary;
    NSMutableDictionary * germanDictionary;
}

- (void)parse:(NSString*)path;

@property(readonly) NSMutableDictionary * englishDictionary;
@property(readonly) NSMutableDictionary * germanDictionary;
@end
