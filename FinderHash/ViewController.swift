//
//  ViewController.swift
//  FinderHash
//
//  Created by Max Chuquimia on 7/06/2016.
//  Copyright © 2016 Chuquimian Productions. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var hashDropdown: NSPopUpButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hashDropdown.removeAllItems()
        
        Defaults.options.forEach { hash in
            hashDropdown.addItemWithTitle(hash.name)
        }
        
        let selectedHash = Defaults.selectedHash().rawValue
        
        let selectedIndex = Defaults.options.indexOf { hash -> Bool in
            return hash.rawValue == selectedHash
        } ?? 2
        
        hashDropdown.selectItemAtIndex(selectedIndex)
    }

    @IBAction func dropdownChanged(sender: AnyObject) {
        Defaults.setSelectedHash(Defaults.options[hashDropdown.indexOfSelectedItem])
    }
}

