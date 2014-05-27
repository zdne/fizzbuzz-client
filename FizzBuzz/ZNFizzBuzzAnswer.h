//
//  ZNFizzBuzzAnswer.h
//  FizzBuzz
//
//  Created by Zdenek Nemec on 5/27/14.
//  Copyright (c) 2014 Zdenek Nemec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNFizzBuzzAnswer : NSObject

@property (nonatomic, readonly) NSString* number;
@property (nonatomic, readonly) NSString* value;

- (id)initWithNumber:(NSNumber *)number andValue:(NSString *)value;

@end
