//
//  Hasher.swift
//  FinderHash
//
//  Created by Max Chuquimia on 7/06/2016.
//  Copyright © 2016 Chuquimian Productions. All rights reserved.
//

import Cocoa

struct Hasher {
    
    let hash: Hash
    let data: NSData
    
    init?(hash: Hash, contentsOfFile file: NSURL) {
        self.hash = hash
        
        guard let path = file.path else {
            return nil
        }
        
        guard let data = NSFileManager.defaultManager().contentsAtPath(path) else {
            return nil
        }
        
        self.data = data
    }
    
    func hashData() -> NSData {
        switch hash {
        case .MD5: return data.MD5()
        case .SHA1: return data.SHA1()
        case .SHA224: return sha224()
        case .SHA256: return sha256()
        case .SHA384: return sha384()
        case .SHA512: return sha512()
        }
    }
    
    func hashString() -> String {
        return hashData().hexedString()
    }
   
    //http://stackoverflow.com/a/25391020/1153630
    private func sha224() -> NSData {
        var hash = [UInt8](count: Int(CC_SHA224_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA224(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA224_DIGEST_LENGTH))
        return res
    }
    
    private func sha256() -> NSData {
        var hash = [UInt8](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA256(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA256_DIGEST_LENGTH))
        return res
    }
    
    private func sha384() -> NSData {
        var hash = [UInt8](count: Int(CC_SHA384_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA384(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA384_DIGEST_LENGTH))
        return res
    }
    
    private func sha512() -> NSData {
        var hash = [UInt8](count: Int(CC_SHA512_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA512(data.bytes, CC_LONG(data.length), &hash)
        let res = NSData(bytes: hash, length: Int(CC_SHA512_DIGEST_LENGTH))
        return res
    }
    
}

//http://stackoverflow.com/a/25136254/1153630
extension Int {
    private func hexedString() -> String {
        return String(format:"%02x", self)
    }
}
extension NSData {
    private func hexedString() -> String {
        var string = String()
        for i in UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(bytes), count: length) {
            string += Int(i).hexedString()
        }
        return string
    }
    
    private func MD5() -> NSData {
        let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))!
        CC_MD5(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(result.mutableBytes))
        return NSData(data: result)
    }
    
    private func SHA1() -> NSData {
        let result = NSMutableData(length: Int(CC_SHA1_DIGEST_LENGTH))!
        CC_SHA1(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(result.mutableBytes))
        return NSData(data: result)
    }
}
