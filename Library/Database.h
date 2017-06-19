//
//  StoreDB.h
//  ExampleLevelDB
//
//  Created by Long Cu Huy Hoang on 6/19/17.
//  Copyright © 2017 Long Cu Huy Hoang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Database : NSObject

-(instancetype)initWithDatabase:(NSString *)name;

-(NSString *)get:(NSString *)key;

-(bool)put:(NSString *)key value:(NSString *)value;

-(bool)delete:(NSString *)key;

-(bool)deleteBatch:(NSArray *)keys;

-(NSArray *)iterate:(NSString *)key;

-(void)close;


@end
