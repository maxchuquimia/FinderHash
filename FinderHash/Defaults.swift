//
//  Defaults.swift
//  FinderHash
//
//  Created by Max Chuquimia on 7/06/2016.
//  Copyright © 2016 Chuquimian Productions. All rights reserved.
//

import Foundation

let HASH_KEY = "HashKey"
let APP_GROUP = "group.com.chuquimianproductions.FinderHash"

enum Hash: String {
    
    case MD5 = "md5"
    
    case SHA1 = "1"
    case SHA224 = "224"
    case SHA256 = "256"
    case SHA384 = "384"
    case SHA512 = "512"
    
    var name: String {
        switch self {
        case .MD5: return "MD5"
        case .SHA1: return "SHA-1"
        case .SHA224: return "SHA-224"
        case .SHA256: return "SHA-256"
        case .SHA384: return "SHA-384"
        case .SHA512: return "SHA-512"
        }
    }
}

struct Defaults {
    
    static let store = NSUserDefaults(suiteName: "group.com.chuquimianproductions.FinderHash")!
    
    static let options: [Hash] = [.MD5, .SHA224, .SHA256, .SHA384, .SHA512]
    
    static func selectedHash() -> Hash {
        let value =  store.stringForKey(HASH_KEY) ?? Hash.SHA256.rawValue
        return Hash(rawValue: value) ?? Hash.SHA256
    }
    
    static func setSelectedHash(hash: Hash) {
        store.setValue(hash.rawValue, forKey: HASH_KEY)
        store.synchronize()
    }
}