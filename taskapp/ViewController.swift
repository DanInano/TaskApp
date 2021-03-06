//
//  ViewController.swift
//  taskapp
//
//  Created by Dan Inano on 2020/08/29.
//  Copyright © 2020 Dan Inano. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate


{
    
    
    @IBOutlet weak var tableView: UITableView!
    
//    Realmインスタンスを取得する
    let realm = try! Realm()
    
//    DBのタスクが格納される倉庫
//    日付の近い順でソート：昇順
//    以降内容をアップデートするとリスト内は自動的に更新される
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date",ascending: true )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        categorySearchBar.delegate = self
    }

//    データの数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int{
        return taskArray.count
    }
//    各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        再利用可能なセルを得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//        Cellに値を設定する
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from :task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell        
    }
//    検索ボタンを押した時に呼び出されるメソッド
    @IBOutlet weak var categorySearchBar: UISearchBar!
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        categorySearchBar.endEditing(true)
        let searchText = categorySearchBar.text!
        searchCategory(searchText :"\(searchText)")
    }
    
    func searchCategory(searchText :String){
        if searchText != "" {
            
            let predicate = NSPredicate(format: "category CONTAINS %@", "\(searchText)")
            taskArray = realm.objects(Task.self).filter(predicate)
        }else{
            taskArray = realm.objects(Task.self)
        }
        tableView.reloadData()
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
//            削除するタスクを取得する
            let task = self.taskArray[indexPath.row]
            
//            ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
//            データベースから削除する
            try! realm.write{
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at :[indexPath], with: .fade)
            }
            
//             未通知のローカル通知一覧をログ出力
                center.getPendingNotificationRequests{(requests: [UNNotificationRequest]) in
                for request in requests{
                print("/---------------")
                print(request)
                print("---------------/")
                }
            }
        }
    }
    
//    Segueで画面遷移するときに呼び出される
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue"{
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        }
        else{
            let task = Task()
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0{
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            
            inputViewController.task = task
        }
    }
    
    //        入力画面から帰ってきたときに TableView を更新する
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

