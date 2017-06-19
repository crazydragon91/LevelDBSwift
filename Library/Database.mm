//
//  StoreDB.m
//  ExampleLevelDB
//
//  Created by Long Cu Huy Hoang on 6/19/17.
//  Copyright © 2017 Long Cu Huy Hoang. All rights reserved.
//

#import "Database.h"

#include <iostream>
#include <sstream>
#include <string>

#import <leveldb/db.h>
#import <leveldb/write_batch.h>

using namespace std;
using namespace leveldb;

typedef DB levelDB;

@implementation Database {
    levelDB *database;
}

- (instancetype)initWithDatabase:(NSString *)name {
    self = [super init];
    if (self) {
        [self createDatabse:name];
    }
    return self;
}

-(void)createDatabse:(NSString *)name {
    Options options;
    options.create_if_missing = true;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSError *error = nil;
    NSString *dbPath = [paths[0] stringByAppendingPathComponent:name];
    NSString *lockFolderPath = [dbPath stringByAppendingPathComponent:@"LOCK"];
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    if (![mgr fileExistsAtPath:lockFolderPath]) {
        NSURL *url = [NSURL fileURLWithPath:dbPath];
        [mgr createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error != nil) {
            NSLog(@"%@", error);
            return;
        }
    }
    
    Status status = levelDB::Open(options, [dbPath UTF8String], &self->database);
    if (false == status.ok()) {
        NSLog(@"ERROR: Unable to open/create database.");
        cout << status.ToString();
    } else {
        NSLog(@"INFO: Database setup.");
    }
}

-(NSArray *)iterate:(NSString *)key {
    ReadOptions readOptions;
    Iterator *it = database->NewIterator(readOptions);
    
    Slice slice = Slice(key.UTF8String);
    
    std::string endKey = key.UTF8String;
    endKey.append("0xFF");
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (it->Seek(slice); it->Valid() && it->key().ToString() < endKey; it->Next()) {
        NSString *value = [[NSString alloc] initWithCString:it->value().ToString().c_str() encoding:[NSString defaultCStringEncoding]];
        [array addObject:value];
    }
    delete it;
    
    return array;
}

-(bool)deleteBatch:(NSArray*)keys {
    WriteBatch batch;
    
    for (int i=0; i <[keys count]; i++) {
        NSString *key = [keys objectAtIndex:i];
        Slice slice = Slice(key.UTF8String);
        batch.Delete(slice);
    }
    
    Status s = self->database->Write(WriteOptions(), &batch);
    return s.ok();
}

-(NSString *)get:(NSString *)key {
    ostringstream keyStream;
    keyStream << key.UTF8String;
    
    ReadOptions readOptions;
    string value;
    Status s = self->database->Get(readOptions, keyStream.str(), &value);
    
    NSString *nsstr = [[NSString alloc] initWithUTF8String:value.c_str()];
    
    return [nsstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(bool)put:(NSString *)key value:(NSString *)value {
    ostringstream keyStream;
    keyStream << key.UTF8String;
    
    ostringstream valueStream;
    valueStream << value.UTF8String;
    
    WriteOptions writeOptions;
    Status s = self->database->Put(writeOptions, keyStream.str(), valueStream.str());
    
    return s.ok();
}

-(bool)delete:(NSString *)key {
    ostringstream keySream;
    keySream << key.UTF8String;
    
    WriteOptions writeOptions;
    Status s = self->database->Delete(writeOptions, keySream.str());
    
    return s.ok();
}

-(void)close {
    delete self->database;
}

@end
