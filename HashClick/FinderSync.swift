//
//  FinderSync.swift
//  HashClick
//
//  Created by Max Chuquimia on 7/06/2016.
//  Copyright © 2016 Chuquimian Productions. All rights reserved.
//

import Cocoa
import FinderSync

class FinderSync: FIFinderSync {

    var rootURL: NSURL = NSURL(fileURLWithPath: "/")

    override init() {
        super.init()
        FIFinderSyncController.defaultController().directoryURLs = [self.rootURL]
    }

    override func menuForMenuKind(menuKind: FIMenuKind) -> NSMenu? {
        
        guard menuKind == .ContextualMenuForItems else {
            return nil
        }
        
        guard let _  = currentlySelectedFile() else {
            return nil
        }
        
        let hash = Defaults.selectedHash()
        
        let subMenu = NSMenu(title: "")
        subMenu.addItemWithTitle("Copy \(hash.name)", action: #selector(FinderSync.copyHash(_:)), keyEquivalent: "")
        return subMenu
    }

    private func currentlySelectedFile() -> NSURL? {
        
        guard let items = FIFinderSyncController.defaultController().selectedItemURLs() else {
            return nil
        }
        
        guard items.count == 1 else {
            return nil
        }
        
        guard let file = items.first else {
            return nil
        }
        
        var isDirectory: AnyObject?
        let _ = try? file.getResourceValue(&isDirectory, forKey: NSURLIsDirectoryKey)
        
        guard let isDirectoryNumber = isDirectory as? NSNumber else {
            return nil
        }
        
        //Seems backwards right?
        guard isDirectoryNumber == false else {
            return nil
        }
        
        return file
    }
    
    @IBAction func copyHash(sender: AnyObject?) {
        
        guard let file = currentlySelectedFile() else {
            return
        }
        
        let hash = Defaults.selectedHash()
       
        guard let checksum = Hasher(hash: hash, contentsOfFile: file)?.hashString() else {
            return
        }
        
        
        NSPasteboard.copy(checksum)
    }

}

extension NSPasteboard {
    static func copy(string: String) {
        NSPasteboard.generalPasteboard().declareTypes([NSStringPboardType], owner: nil)
        NSPasteboard.generalPasteboard().setString(string, forType: NSStringPboardType)
    }
}

