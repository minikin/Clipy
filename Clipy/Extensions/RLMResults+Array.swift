//
//  RLMResults+Array.swift
//  Clipy
//
//  Created by 古林俊佑 on 2016/07/02.
//  Copyright © 2016年 Shunsuke Furubayashi. All rights reserved.
//

import Foundation
import Realm

extension RLMResults {
    func arrayValue<T>(_: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
}

extension RLMArray {
    func arrayValue<T>(_: T.Type) -> [T] {
        return flatMap { $0 as? T }
    }
}
