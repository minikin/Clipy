//
//  CPYFolder.swift
//  Clipy
//
//  Created by 古林俊佑 on 2015/06/21.
//  Copyright (c) 2015年 Shunsuke Furubayashi. All rights reserved.
//

import Cocoa
import Realm

class CPYFolder: RLMObject {

    // MARK: - Properties
    dynamic var index       = 0
    dynamic var enable      = true
    dynamic var title       = ""
    dynamic var snippets    = RLMArray(objectClassName: CPYSnippet.className())

    var lastSnippet: CPYSnippet? {
        return snippets.sortedResultsUsingProperty("index", ascending: true).lastObject() as? CPYSnippet
    }
    static var lastFolder: CPYFolder? {
        return CPYFolder.allObjects().sortedResultsUsingProperty("index", ascending: true).lastObject() as? CPYFolder
    }

    // MARK: - Ignore Properties
    override static func ignoredProperties() -> [String] {
        return ["lastSnippet", "lastFolder"]
    }
}

// MARK: - Add Snippet
extension CPYFolder {
    func addSnippet() {
        guard let realm = realm where !invalidated else { return }

        let snippet = CPYSnippet()
        snippet.title = "untitled snippet"
        snippet.index = lastSnippet?.index ?? -1
        snippet.index += 1

        realm.transaction { snippets.addObject(snippet) }
    }
}

// MARK: - Add Folder
extension CPYFolder {
    static func add() {
        let folder = CPYFolder()
        folder.title = "untitled folder"
        folder.index = CPYFolder.lastFolder?.index ?? -1
        folder.index += 1

        let realm = RLMRealm.defaultRealm()
        realm.transaction { realm.addObject(folder) }
    }
}
