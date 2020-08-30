//
//  ViewController.swift
//  taskapp
//
//  Created by Dan Inano on 2020/08/29.
//  Copyright © 2020 Dan Inano. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

//    データの数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int{
        return 0
    }
//    各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        再利用可能なセルを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
//    各セルを選択したときに実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
//    セルが削除可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
    }
//    　Deleteボタンが押されたときに呼び出されるメソッド
    func tableView(_ tableView: UITableView, commitEditingStyle: UITableViewCell.EditingStyle, indexPath: IndexPath){
    }
}

