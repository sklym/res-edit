//
//  StringResourceDataSource.h
//  resEditor
//
//  Created by Stanislav Fedorov on 10/09/15.
//
//

#import <Cocoa/Cocoa.h>
#import "StringResource.h"

@interface StringResourceDataSource : NSObject<NSTableViewDataSource>{
    StringResource * stringResource;
}

- (void)setStringResource:(StringResource *)aStringResource;

@end
