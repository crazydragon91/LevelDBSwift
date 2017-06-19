//
//  LevelDB.swift
//  ExampleLevelDB
//
//  Created by Long Cu Huy Hoang on 6/19/17.
//  Copyright © 2017 Long Cu Huy Hoang. All rights reserved.
//

import Foundation

open class LevelDB {
    
    var database: Database
    
    public init(name: String) {
        database = Database(database: name)
    }
    
    public subscript(key: String) -> String? {
        get {
            return database.get(key)
        }
        
        set(newValue) {
            database.put(key, value: newValue!)
        }
    }
    
    public func delete(key: String) -> Bool {
        return database.delete(key)
    }
    
    public func collect(key: String) -> [String] {
        if let c = database.iterate(key) as? [String] {
            return c
        }
        
        return []
    }
    
    public func deleteCollection(keys: [String]) -> Bool {
        return database.deleteBatch(keys)
    }
    
    public func close() {
        database.close()
    }
}
