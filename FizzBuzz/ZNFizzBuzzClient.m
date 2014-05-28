//
//  ZNFizzBuzzClient.m
//  FizzBuzz
//
//  Created by Zdenek Nemec on 5/27/14.
//  Copyright (c) 2014 Zdenek Nemec. All rights reserved.
//

#import "ZNFizzBuzzClient.h"
#import "ZNFizzBuzzAnswer.h"
#import "SHMKit/SHMParser.h"
#import "SHMKit/SHMLink.h"

@interface ZNFizzBuzzClient()
@property (nonatomic, copy) NSString* fizzBuzzAppURL;
@property (atomic, strong) SHMParser* sirenClient;
@property (atomic, strong) NSMutableArray* results;
@end

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
        self.results = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
 *  Initialize FizzBuzz service client and solve the FizzBuzz
 *
 *  Designer note:  In a real world you would want to split this function
 *                  into several separate parts. However to demonstrate 
 *                  the workflow as whole we will keep it in one happy
 *                  nested-blocks spaghetti.
 *
 */
- (void)solveFizzBuzzWithCompletion:(void (^)(NSError* error, NSArray* results))completion
{
    //self.fizzBuzzAppURL = @"http://fizzbuzzaas.herokuapp.com";
    self.fizzBuzzAppURL = @"http://localhost:3000";
    
    // Set the FizzBuzz server URL
    self.sirenClient = [[SHMParser alloc] initWithSirenRoot:self.fizzBuzzAppURL];
    
    // Initialize the client - fetch API root
    NSLog(@"following %@", self.fizzBuzzAppURL);
    [self.sirenClient retrieveRoot:^(NSError* error, SHMEntity* entity) {

        if (error) {
            NSLog(@"error initializing the client: %@", error.description);
            if (completion)
                completion(error, nil);
            return;
        }
        
        // Look for the 'first' relation
        if ([entity hasLinkRel:@"first"]) {
            
            [self patchLink:entity andLinkRel:@"first"];    // Should not be needed - check the comment for this function
            
            // Follow the link with the 'first' relation
            [entity stepToLinkRel:@"first" withCompletion:^(NSError* error, SHMEntity* firstEntity) {

                if (error) {
                    NSLog(@"error following the 'first' relation: %@", error);
                    if (completion)
                        completion(error, nil);
                    return;
                }
                
                // Process 'first' resource properties
                ZNFizzBuzzAnswer* answer = [[ZNFizzBuzzAnswer alloc] initWithNumber:firstEntity.properties[@"number"]
                                                                           andValue:firstEntity.properties[@"value"]];
                [self.results addObject:answer];

                // Follow 'next' (if available)
                [self fizzBuzz:firstEntity withCompletion:completion];
            }];
        }
        
    }];
}

- (void)fizzBuzz:(SHMEntity *)entity withCompletion:(void (^)(NSError* error, NSArray* result))completion
{
    // Look for the 'next' relation, if not found we have nothing to do
    if ([entity hasLinkRel:@"next"]) {
        
        [self patchLink:entity andLinkRel:@"next"]; // Should not be needed - check the comment for this function
        
        [entity stepToLinkRel:@"next" withCompletion:^(NSError* error, SHMEntity* nextEntity) {

            if (error) {
                NSLog(@"error following the 'next' relation: %@", error);
                if (completion)
                    completion(error, nil);
                return;
            }

            // Process 'next' resource properties
            ZNFizzBuzzAnswer* answer = [[ZNFizzBuzzAnswer alloc] initWithNumber:nextEntity.properties[@"number"]
                                                                       andValue:nextEntity.properties[@"value"]];
            [self.results addObject:answer];
            
            // Follow 'next'
            [self fizzBuzz:nextEntity withCompletion:completion];
        }];
        
        return;
    }

    // Nothing to do
    if (completion)
        completion(nil, self.results);
    
    NSLog(@"-- All done --");
}

/*
 *  Patch a link in Siren entity links so they are a full URI
 *  
 *  Designer note:  The need for such function is SHMkit shortcoming
 *                  and us such should not be needed in a mature client.
 */
-(void)patchLink:(SHMEntity *)entity andLinkRel:(NSString*)linkRel {
    for (SHMLink *link in entity.links) {
        for (NSString *rel in link.rel) {
            if ([rel isEqualToString:linkRel]) {
                NSString *patchedLink = [NSString stringWithFormat:@"%@%@", self.fizzBuzzAppURL, link.href];
                link.href = patchedLink;
            }
        }
    }
}

@end
