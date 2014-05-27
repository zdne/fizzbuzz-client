//
//  ZNFizzBuzzClient.m
//  FizzBuzz
//
//  Created by Zdenek Nemec on 5/27/14.
//  Copyright (c) 2014 Zdenek Nemec. All rights reserved.
//

#import "ZNFizzBuzzClient.h"

@implementation ZNFizzBuzzClient

+ (ZNFizzBuzzClient *)sharedFizzBuzzClient;
{
    static ZNFizzBuzzClient* _sharedFizzBuzzClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFizzBuzzClient = [[ZNFizzBuzzClient alloc] init];
    });
    
    return _sharedFizzBuzzClient;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)doSomeStuff
{
    
}

@end
