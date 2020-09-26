//
//  Task.swift
//  taskapp
//
//  Created by Dan Inano on 2020/08/30.
//  Copyright © 2020 Dan Inano. All rights reserved.
//

import RealmSwift

class Task: Object {
//     管理ID プライマリーキー
    @objc dynamic var id = 0
//    タイトル
    @objc dynamic var title = ""
//    内容
    @objc dynamic var contents = ""
//    日時
    @objc dynamic var date = Date()
//    カテゴリ
    @objc dynamic var category = ""
 
//     IDをプライマリーキーとして設定
    override static func primaryKey() -> String?{
        return "id"
    }
    
}

