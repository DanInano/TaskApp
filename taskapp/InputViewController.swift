//
//  InputViewController.swift
//  taskapp
//
//  Created by Dan Inano on 2020/08/29.
//  Copyright © 2020 Dan Inano. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextField: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!
    
    let realm = try! Realm()
    
    var task: Task!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        背景をタップしたらdissMissKeyboardメソッドを呼ぶようにうする
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextField.text = task.contents
        datePicker.date = task.date
        categoryTextField.text = task.category
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write{
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextField.text!
            self.task.date = self.datePicker.date
            self.task.category = self.categoryTextField.text!
            self.realm.add(self.task, update: .modified)
        }
        
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    func setNotification(task: Task){
        //タスクのローカル通知を設定する
        let content = UNMutableNotificationContent()
        //タイトルと内容を設定（内容がないと音のみの通知になるため「○○ナシ」を表示する　）
        if task.title == ""{
            content.title = "タイトルなし"
        }else{
            content.title = task.title
        }
        if task.contents == ""{
            content.body = "内容なし"
        }else{
            content.body = task.contents
        }
        
        content.sound = UNNotificationSound.default
        
        //ローカル通知が設定されるtrriger（日付マッチ）を作成
        let calender = Calendar.current
        let dateConponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateConponents, repeats: false)
        
        //identifer, content, torrigerからローカル通知を作成（identifierが同じ場合はローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id), content:content, trigger:trigger)
        
        //ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request){(error) in
            print (error ?? "ローカル通知登録OK")
            // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }
        
        //未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests{ (requests: [UNNotificationRequest]) in
            for request in requests{
                print("/-------")
                print(request)
                print("-------/")
            }
        }
    
    }
    
    
    
    @objc func dismissKeyboard(){
        //キーボードを閉じる
        view.endEditing(true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
