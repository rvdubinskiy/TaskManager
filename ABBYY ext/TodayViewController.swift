//
//  TodayViewController.swift
//  ABBYY ext
//
//  Created by Roman Dubinskiy on 6/4/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    lazy var button: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(goToMainApp), for: .touchDown)
        return button
    }()
    // label which called up a name of task
    var nameOfTaskLabel = OwnLabel()
    // label which called up comments for task
    var commentsLabel = OwnLabel()
    // label which called up time
    var time = OwnLabel()
    // label which called up a status
    var status = OwnLabel()
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(nameOfTaskLabel.label)
        view.addSubview(time.label)
        view.addSubview(commentsLabel.label)
        view.addSubview(status.label)
        view.addSubview(button)
        setupSettingsForElements()
        
        setupConstraints()
    }
    
    @objc func goToMainApp() {
        extensionContext?.open(NSURL(string: "abbyy://more")! as URL, completionHandler: nil)
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        view.addSubview(nameOfTaskLabel.label)
        view.addSubview(time.label)
        view.addSubview(commentsLabel.label)
        view.addSubview(status.label)
        view.addSubview(button)
        setupSettingsForElements()
        
        setupConstraints()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    
    // set up settings main frame
    func setupSettingsForElements() {
        var note = [String]()
        nameOfTaskLabel.label.font = UIFont.boldSystemFont(ofSize: 25)
        time.label.font = UIFont.systemFont(ofSize: 15)
        commentsLabel.label.font = UIFont.systemFont(ofSize: 15)
        status.label.font = UIFont.systemFont(ofSize: 15)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let currentDateString: String = dateFormatter.string(from: Date())
        var tempString = String()
        var timeForCompare = String()
        
        var dates = UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.object(forKey: "def1") as! [[String]] ?? [[""]]
        dates.reverse()

        // тут сортировка для отображения ближайшей задачи, у которой не стоит статус "done"
        for item in 0..<dates.count {
            // тут я сравниваю по дням + статус
            if dates[item][5] >= tempString && dates[item][4] == "0"{
                // тут сравниваю по времени(часы, минуты и секунды), чтобы получить свежий невыолненный таск
                if dates[item][2] > timeForCompare {
                    tempString = dates[item][5]
                    timeForCompare = dates[item][2]
                    note = SetParameters(tempString: tempString, timeForCompare: timeForCompare, dates: dates, item: item)
                }
            } else if dates[item][5] >= tempString && dates[item][4] == "1" {
                // тут аналогично, но для другого статуса.
                if dates[item][2] > timeForCompare {
                    tempString = dates[item][5]
                    timeForCompare = dates[item][2]
                    note = SetParameters(tempString: tempString, timeForCompare: timeForCompare, dates: dates, item: item)
                }
            } else {
                note.append("1")
                note.append("Надеюсь")
                note.append("сейчас")
                note.append("все")
                note.append("окей")
                note.append("1")
            }
        }
        
        
        if dates.count != 0 {
            
            if currentDateString > note[5] && note[3] == "new"{
                nameOfTaskLabel.label.text = note[1]
                time.label.text = currentDateString
                commentsLabel.label.text = note[4]
                status.label.text = note[3]
            } else if currentDateString > note[5] && note[3] == "in the process" {
                nameOfTaskLabel.label.text = note[1]
                time.label.text = currentDateString
                commentsLabel.label.text = note[4]
                status.label.text = note[3]
            } else if currentDateString == note[5] && (note[3] == "new" || note[3] == "in the process") {
                nameOfTaskLabel.label.text = note[1]
                time.label.text = note[2]
                commentsLabel.label.text = note[4]
                status.label.text = note[3]
            } else {
                nameOfTaskLabel.label.text = "dude"
                time.label.text = "trust"
                commentsLabel.label.text = "no"
                status.label.text = "one!"
            }
        } else {
            nameOfTaskLabel.label.text = "dude"
            time.label.text = "trust"
            commentsLabel.label.text = "no"
            status.label.text = "oneры"
        }
        
        
        UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.set(note, forKey: "widjetDate")
        
    }
    
    // тут считаю максимально подходящую
    func SetParameters(tempString: String, timeForCompare: String, dates: [[String]],  item: Int) -> [String] {
        var notes = [String]()
        notes.append(dates[item][0])
        notes.append(dates[item][1])
        notes.append(dates[item][3])
        notes.append(GetStatusFromInt(intStatus: dates[item][4]))
        notes.append(timeForCompare)
        notes.append(tempString)
        return notes
    }
    
    // get status from string format as int
    func GetStatusFromInt(intStatus: String) -> String {
        
        switch intStatus {
        case "0":
            return "new"
        case "1":
            return "in the process"
        case "2":
            return "done"
        default:
            return "nnnnew"
        }
    }
    
    func setupConstraints() {
        // bounds for button
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        // bounds for name of task label
        nameOfTaskLabel.label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        nameOfTaskLabel.label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        nameOfTaskLabel.label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameOfTaskLabel.label.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 5/10).isActive = true
        
        
        // bounds for time label
        time.label.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        time.label.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12).isActive = true
        time.label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        time.label.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 3/10).isActive = true
        
        // bounds for comments label
        commentsLabel.label.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        commentsLabel.label.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        commentsLabel.label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        commentsLabel.label.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2).isActive = true

        // bounds for status label
        status.label.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        status.label.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        status.label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        status.label.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 3/10).isActive = true
    }
    
}
