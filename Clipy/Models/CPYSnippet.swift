//
//  CPYSnippet.swift
//  Clipy
//
//  Created by 古林俊佑 on 2015/06/21.
//  Copyright (c) 2015年 Shunsuke Furubayashi. All rights reserved.
//

import Cocoa
import Realm

class CPYSnippet: RLMObject {

    // MARK: - Properties
    dynamic var index   = 0
    dynamic var enable  = true
    dynamic var title   = ""
    dynamic var content = ""
    dynamic var identifier = NSUUID().UUIDString
    dynamic var folders: RLMLinkingObjects?

    var folder: CPYFolder? {
        return folders?.arrayValue(CPYFolder.self).first
    }

    // MARK: Primary Key
    override class func primaryKey() -> String {
        return "identifier"
    }

    // MARK: - Linking Objects
    override static func linkingObjectsProperties() -> [String : RLMPropertyDescriptor] {
        return ["folders": RLMPropertyDescriptor(withClass: CPYFolder.self, propertyName: "snippets")]
    }

    // MARK: - Ignore Properties
    override static func ignoredProperties() -> [String] {
        return ["folder"]
    }
}
