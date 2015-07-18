//
//  CPYSnippetWindowController.swift
//  Clipy
//
//  Created by 古林俊佑 on 2015/07/14.
//  Copyright (c) 2015年 Shunsuke Furubayashi. All rights reserved.
//

import Cocoa

class CPYSnippetWindowController: NSWindowController {

    // MARK: - Properties
    @IBOutlet weak var outlineView: CPYSnippetOutlineView!
    
    private let kAddSnippetIdentifier   = "kAddSnippetIdentifier"
    private let kAddFolderIdentifier    = "kAddFolderIdentifier"
    private let kDeleteIdentifier       = "kDeleteIdentifier"
    private let kEnableIdentifier       = "kEnableIdentifier"
    private let kSettingIdentifier      = "kSettingIdentifier"
    
    // MARK: - View Life Cycle
    override func windowDidLoad() {
        super.windowDidLoad()
        self.initToolBarButtons()
        self.window?.backgroundColor = NSColor.whiteColor()
        self.window?.titlebarAppearsTransparent = true
    }

    // MARK: - Override Methods
    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)
        self.window?.makeKeyAndOrderFront(self)
    }
    
    // MARK: - Private Methods
    private func initToolBarButtons() {
        let toolBar = NSToolbar(identifier: "toolBar")
        toolBar.allowsUserCustomization = true
        toolBar.autosavesConfiguration = true
        toolBar.delegate = self
        self.window?.toolbar = toolBar
    }

}

extension CPYSnippetWindowController: NSToolbarDelegate {
    
    func toolbarAllowedItemIdentifiers(toolbar: NSToolbar) -> [AnyObject] {
        return [kAddSnippetIdentifier, kAddFolderIdentifier, kDeleteIdentifier, kEnableIdentifier, kSettingIdentifier]
    }
    
    func toolbarDefaultItemIdentifiers(toolbar: NSToolbar) -> [AnyObject] {
        return [kAddSnippetIdentifier, kAddFolderIdentifier, kDeleteIdentifier, kEnableIdentifier, kSettingIdentifier]
    }
    
    func toolbar(toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        var image: NSImage?
        var title  = ""
        var action = ""
        
        if itemIdentifier == kAddSnippetIdentifier {
            image = NSImage(named: "add_snippet")
            title = "追加"
            action = ""
        } else if itemIdentifier == kAddFolderIdentifier {
            image = NSImage(named: "add_folder")
            title = "追加"
            action = ""
        } else if itemIdentifier == kDeleteIdentifier {
            image = NSImage(named: "delete_snippet")
            title = "削除"
            action = ""
        } else if itemIdentifier == kEnableIdentifier {
            image = NSImage(named: "enable_snippet")
            title = "オン/オフ"
            action = ""
        } else if itemIdentifier == kSettingIdentifier {
            image = NSImage(named: "setting_snippet")
            title = "編集"
            action = ""
        }
        
        let imageView = NSImageView(frame: NSMakeRect(0, 0, 36, 24))
        imageView.image = image
        
        let item = NSToolbarItem(itemIdentifier: itemIdentifier)
        item.label = title
        item.target = self
        item.view = imageView
        
        return item
    }
    
}

