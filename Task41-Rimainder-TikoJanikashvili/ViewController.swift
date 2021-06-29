//
//  ViewController.swift
//  Task41-Rimainder-TikoJanikashvili
//
//  Created by Tiko on 28.06.21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    var reminders = [Reminder]()
    
    let fileManager = FileManager.default
    
    var docuemntsDirectoryURL: URL? {
        try? fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
    }
    
    // MARK: - Life Cyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ReminderCell", bundle: nil), forCellReuseIdentifier: "ReminderCell")
        guard let contentUrls = try? fileManager.contentsOfDirectory(at: docuemntsDirectoryURL!,
                                                                     includingPropertiesForKeys: nil,
                                                                     options: [.skipsHiddenFiles])  else {return}
        
        let filtered = contentUrls.filter { $0.pathExtension == "txt" }
        
        if filtered.count > 0 {
            filtered.forEach {
                guard let content = try? String(contentsOf: $0, encoding: .utf8) else { return }
                let index = content.firstIndex(of: "\n") ?? content.endIndex
                let titleContent = content[..<index]
//                let discContent = content[content.index(after: content.startIndex)]
                reminders.append(Reminder(title: "⏰ \(titleContent)", discription: "", data: Date()))
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func add(_ sender: Any) {
        let sb = UIStoryboard(name: "AlertViewController", bundle: nil)
        if let vc = sb.instantiateViewController(identifier: "AlertViewController") as? AlertViewController {
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func notification() {
        
    }

    func show(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.sound = .default
        content.body = body

        let targetDate = Date().addingTimeInterval(4)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                  from: targetDate),
                                                    repeats: false)

        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as? ReminderCell
        cell?.setCell(item: self.reminders[indexPath.row])
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
}

extension ViewController: AlertDelegate {
    func save(title: String, contecnt: String, date: Date) {
        self.reminders.append(Reminder(title: title, discription: contecnt, data: Date()))
        
        self.tableView.reloadData()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                self.show(title: title, body: contecnt)
            }
            else if error != nil {
                print("error occurred")
            }
        })
    }
}

