//
//  AlertViewController.swift
//  Task41-Rimainder-TikoJanikashvili
//
//  Created by Tiko on 28.06.21.
//

import UIKit

protocol AlertDelegate: AnyObject {
    func save(title: String, contecnt: String, date: Date)
}

class AlertViewController: UIViewController {

    // MARK: - IBoutlets
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    let fileManager = FileManager.default
    weak var delegate: AlertDelegate?
    
    var docuemntsDirectoryURL: URL? {
        try? fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
    }
    
    // MARK: - Life Cyrcle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.layer.cornerRadius = 10
//        print(docuemntsDirectoryURL!)
    }
    
    @IBAction func save(_ sender: Any) {
        let randomFileName = "\(UUID().uuidString).txt"
        guard let fileUrl = docuemntsDirectoryURL?.appendingPathComponent(randomFileName) else { return }
        let text = "\(titleTextField.text ?? " ")\n\(descriptionTextField.text ?? " ")\n\(Date()))"
        try? text.write(to: fileUrl, atomically: true, encoding: .utf8)
        self.delegate?.save(title: self.titleTextField.text ?? "", contecnt: self.descriptionTextField.text ?? "", date: Date())
        print(Date())
        self.dismiss(animated: true, completion: nil)
        
        
        let content = UNMutableNotificationContent()
        content.title = self.titleTextField.text ?? ""
        content.sound = .default
        content.body = self.descriptionTextField.text ?? ""
        
        let targetDate = Date()
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
