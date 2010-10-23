//
//  AccentuateUs.m
//  accentuateus-osx-service
//
//  Created by Michael Schade on 10/23/10.
//  Copyright 2010 Spearhead Development LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccentuateUs.h"

@implementation AccentuateUs

- (void)accentuate:(NSPasteboard *) pboard
        userData:(NSString *) data
        error:(NSString **)error {
    NSArray *types = [pboard types];
    types = [NSArray arrayWithObject:NSStringPboardType];
    [pboard declareTypes:types owner:nil];
    [pboard setString:@"AA" forType:NSStringPboardType];
    return;
}

@end

int main(int argc, char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    AccentuateUs *service = [[AccentuateUs alloc] init];
    NSRegisterServicesProvider(service, @"AccentuateUs");
    
    NSLog(@"Test.");
    
    NS_DURING
    [[NSRunLoop currentRunLoop] run];
    NS_HANDLER
    NSLog(@"%@", localException);
    NS_ENDHANDLER
    
    [service release];
    [pool release];
    return 0;
}