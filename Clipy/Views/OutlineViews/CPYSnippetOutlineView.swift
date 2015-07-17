//
//  CPYSnippetOutlineView.swift
//  Clipy
//
//  Created by 古林　俊祐　 on 2015/07/17.
//  Copyright (c) 2015年 Shunsuke Furubayashi. All rights reserved.
//

import Cocoa

// MARK: - CPYSnippetOutlineView
class CPYSnippetOutlineView: NSOutlineView {

    // MARK: - Properties
    private var folders = CPYSnippetManager.sharedManager.loadSortedFolders()
    
    // MARK - Init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        //self.setDelegate(self)
        self.setDataSource(self)
        
        //self.registerForDraggedTypes([kDraggedDataType])
        //self.setDraggingSourceOperationMask(NSDragOperation.Move, forLocal: true)
    }
    
}

// MARK: - NSOutlineView DataSourse
extension CPYSnippetOutlineView: NSOutlineViewDataSource {
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil {
            return Int(self.folders!.count)
        } else if let folder = item as? CPYFolder {
            return Int(folder.snippets.count)
        }
        return 0
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        if let folder = item as? CPYFolder {
            return (folder.snippets.count != 0) ? true : false
        }
        return true
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil {
            return self.folders!.objectAtIndex(UInt(index))
        } else {
            if let folder = item as? CPYFolder {
                println("folder")
                return folder.snippets.sortedResultsUsingProperty("index", ascending: true).objectAtIndex(UInt(index))
            } else {
                println("non")
                return "aaa"
            }
        }
    }

}

// MARK: - NSOutlineView Delegate
extension CPYSnippetOutlineView: NSOutlineViewDelegate {
    
}