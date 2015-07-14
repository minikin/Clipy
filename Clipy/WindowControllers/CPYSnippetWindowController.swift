//
//  CPYSnippetWindowController.swift
//  Clipy
//
//  Created by 古林俊佑 on 2015/07/14.
//  Copyright (c) 2015年 Shunsuke Furubayashi. All rights reserved.
//

import Cocoa

class CPYSnippetWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.backgroundColor = NSColor.whiteColor()
        
    }

    // MARK: - Override Methods
    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)
        self.window?.makeKeyAndOrderFront(self)
    }
    
}
