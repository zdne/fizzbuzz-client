//
//  ZNFizzBuzzAnswer.m
//  FizzBuzz
//
//  Created by Zdenek Nemec on 5/27/14.
//  Copyright (c) 2014 Zdenek Nemec. All rights reserved.
//

#import "ZNFizzBuzzAnswer.h"

@implementation ZNFizzBuzzAnswer

- (id)init
{
    self = [super init];
    return self;
}

- (id)initWithNumber:(NSNumber *)number andValue:(NSString *)value
{
    self = [super init];
    if (self) {
        _number = [number stringValue];
        _value = value;
    }
    return self;
}

@end
