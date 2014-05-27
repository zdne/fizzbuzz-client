//
//  ZNFizzBuzzClient.h
//  FizzBuzz
//
//  Created by Zdenek Nemec on 5/27/14.
//  Copyright (c) 2014 Zdenek Nemec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZNFizzBuzzClient : NSObject

// Returns the shared FizzBuzz client instance
+ (ZNFizzBuzzClient *)sharedFizzBuzzClient;

// Solve FizzBuzz
- (void)solveFizzBuzzWithCompletion:(void (^)(NSError* error, NSArray* result))completion;

@end
