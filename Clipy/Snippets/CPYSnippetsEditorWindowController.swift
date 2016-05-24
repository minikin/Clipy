//
//  CPYSnippetsEditorWindowController.swift
//  Clipy
//
//  Created by 古林俊佑 on 2016/05/18.
//  Copyright © 2016年 Shunsuke Furubayashi. All rights reserved.
//

import Cocoa
import Realm

final class CPYSnippetsEditorWindowController: NSWindowController {

    // MARK: - Properties
    static let sharedController = CPYSnippetsEditorWindowController(windowNibName: "CPYSnippetsEditorWindowController")
    @IBOutlet weak var splitView: CPYSplitView!
    @IBOutlet weak var folderSettingView: NSView!
    @IBOutlet weak var outlineView: NSOutlineView!
    @IBOutlet var textView: CPYPlaceHolderTextView! {
        didSet {
            textView.font = NSFont.systemFontOfSize(14)
            textView.automaticQuoteSubstitutionEnabled = false
            textView.enabledTextCheckingTypes = 0
        }
    }

    private var selectedFolder: CPYFolder?
    private var selectedSnippet: CPYSnippet?
    private var folders = [CPYFolder]()
    private var folderToken: RLMNotificationToken?
    // HACK: NSOutline data source memory caputure
    // https://github.com/realm/realm-cocoa/issues/1734
    private var stronglyHeldRealmObjects = [RLMObject]()
    private var targetFolder: CPYFolder? {
        if let selectedFolder = selectedFolder { return selectedFolder }
        if let selectedSnippet = selectedSnippet, folder = selectedSnippet.folder { return folder }
        return nil
    }

    // MARK: - Window Life Cycle
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.collectionBehavior = .CanJoinAllSpaces
        self.window?.backgroundColor = NSColor(white: 0.99, alpha: 1)
        if #available(OSX 10.10, *) {
            self.window?.titlebarAppearsTransparent = true
        }

        // Realm Notification
        folderToken = CPYFolder.allObjects().sortedResultsUsingProperty("index", ascending: true).addNotificationBlock { [weak self] (results, changes, _) in
            guard let wSelf = self else { return }
            guard let results = results else { return }

            wSelf.folders = results.arrayValue(CPYFolder.self)
            wSelf.outlineView.reloadData()
        }
    }

    override func showWindow(sender: AnyObject?) {
        super.showWindow(sender)
        window?.makeKeyAndOrderFront(self)
    }
}

// MARK: - IBActions
extension CPYSnippetsEditorWindowController {
    @IBAction func addSnippetButtonTapped(sender: AnyObject) {
        guard let folder = targetFolder else { return }
        folder.addSnippet()
    }

    @IBAction func addFolderButtonTapped(sender: AnyObject) {
        CPYFolder.add()
    }

    @IBAction func deleteButtonTapped(sender: AnyObject) {

    }

    @IBAction func changeStatusButtonTapped(sender: AnyObject) {

    }

    @IBAction func settingButtonTapped(sender: AnyObject) {
        
    }
}

// MARK: - NSSplitView Delegate
extension CPYSnippetsEditorWindowController: NSSplitViewDelegate {
    func splitView(splitView: NSSplitView, constrainMinCoordinate proposedMinimumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return proposedMinimumPosition + 150
    }

    func splitView(splitView: NSSplitView, constrainMaxCoordinate proposedMaximumPosition: CGFloat, ofSubviewAt dividerIndex: Int) -> CGFloat {
        return proposedMaximumPosition / 2
    }
}

// MARK: - NSOutlineView DataSource
extension CPYSnippetsEditorWindowController: NSOutlineViewDataSource {
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil {
            return folders.count
        } else if let folder = item as? CPYFolder {
            return Int(folder.snippets.count)
        }
        return 0
    }

    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        if let folder = item as? CPYFolder {
            return (folder.snippets.count != 0)
        }
        return false
    }

    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        var returnItem: RLMObject?
        if item == nil {
            returnItem = folders[index]
        } else if let folder = item as? CPYFolder {
            returnItem = folder.snippets.sortedResultsUsingProperty("index", ascending: true).objectAtIndex(UInt(index))
        }
        // HACK: Strong hold retain count
        // https://github.com/realm/realm-cocoa/issues/1734
        if let returnItem = returnItem {
            stronglyHeldRealmObjects.append(returnItem)
        }
        return returnItem ?? ""
    }

    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        if let folder = item as? CPYFolder {
            return folder.title
        } else if let snippet = item as? CPYSnippet {
            return snippet.title
        }
        return ""
    }
}

// MARK: - NSOutlineView Delegate
extension CPYSnippetsEditorWindowController: NSOutlineViewDelegate {
    func outlineView(outlineView: NSOutlineView, willDisplayCell cell: AnyObject, forTableColumn tableColumn: NSTableColumn?, item: AnyObject) {
        guard let cell = cell as? CPYSnippetsEditorCell else { return }
        if let _ = item as? CPYFolder {
            cell.iconType = .Folder
        } else if let _ = item as? CPYSnippet {
            cell.iconType = .None
        }
    }

    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        if let folder = item as? CPYFolder {
            textView.string = ""
            folderSettingView.hidden = false
            textView.hidden = true
            selectedFolder = folder
            selectedSnippet = nil
            return true
        } else if let snippet = item as? CPYSnippet {
            textView.string = snippet.content
            folderSettingView.hidden = true
            textView.hidden = false
            selectedFolder = nil
            selectedSnippet = snippet
            return true
        }
        return false
    }

    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        guard let text = fieldEditor.string where text.characters.count != 0 else { return false }
        guard let outlineView = control as? NSOutlineView else { return false }
        guard let item = outlineView.itemAtRow(outlineView.selectedRow) else { return false }

        let realm = RLMRealm.defaultRealm()
        if let folder = item as? CPYFolder {
            realm.transaction { folder.title = text }
        } else if let snippet = item as? CPYSnippet {
            realm.transaction { snippet.title = text }
        }
        return true
    }
}
