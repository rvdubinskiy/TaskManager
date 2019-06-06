//
//  MainViewController.swift
//  ABBYY
//
//  Created by Roman Dubinskiy on 5/31/19.
//  Copyright © 2019 Roman Dubinskiy. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController, UITextFieldDelegate {
    private var notes: Note?
    var flag: Bool = false
    var taskInfo = TaskInfo()
    var userKey = UserKey()
    var indexOfCurrentElement: Int = 0
    
    
    convenience init(with parameters: Note, index: String) {
        self.init()
        
        indexOfCurrentElement = Int(index)!
        self.notes = parameters
        
        
        setupNavigationItems()
        setupdefaultSettings()
        setupDates()
        setupCreateView()
    }
    
    func setupNavigationItems() {
        title = "Information"
        
        self.view.backgroundColor = UIColor.white
        let editButton = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(beginEditing))
        
        navigationItem.rightBarButtonItems = [editButton]
        self.toolbarItems = [UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(finishTask))
]
    }
    
    func setupdefaultSettings() {
        taskInfo.nameOfTask.textColor = UIColor.gray
        taskInfo.comment.textColor = UIColor.gray
        taskInfo.createButton.isHidden = true
        taskInfo.comment.isEditable = false
        
    }
    
    // button which changed status after click on it
    @objc func finishTask() {
        var index = UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.object(forKey: userKey.key) as? [[String]]
        
        index![indexOfCurrentElement][4] = "2"
        UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.set(index, forKey: userKey.key)
    }
    
    // navigation button "Edit" for editing task
    @objc func beginEditing() {
        taskInfo.nameOfTask.textColor = UIColor.black
        taskInfo.comment.textColor = UIColor.black
        taskInfo.comment.isEditable = true
        flag = true
        
        buttonSettings()
    }
    
    // save button settings
    func buttonSettings() {
        let button = taskInfo.createButton
        button.isHidden = false
        button.backgroundColor = UIColor.gray
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(changeDates), for: .touchUpInside)
        
    }
    
    // save all dates after editing
    @objc func changeDates() {
    
        var index = UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.object(forKey: userKey.key) as? [[String]]

        
        index![indexOfCurrentElement][1] = taskInfo.nameOfTask.text ?? "Default"
        index![indexOfCurrentElement][2] = (taskInfo.comment.text! as NSString) as String
        index![indexOfCurrentElement][4] = "1"
        
        UserDefaults.init(suiteName: "group.com.dubinskiy.abbyy")?.set(index, forKey: userKey.key)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    // set up all dated
    func setupDates() {
        taskInfo.nameOfTask.text = notes?.nameOfTask
        taskInfo.comment.text = notes?.comments
    }
    
    func setupCreateView() {
        self.view.addSubview(taskInfo.nameOfTask)
        self.view.addSubview(taskInfo.comment)
        self.view.addSubview(taskInfo.createButton)
        taskInfo.nameOfTask.delegate = self
        
        setupConstraints()
    }
    
    func setupConstraints() {
        taskInfo.nameOfTask.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        taskInfo.nameOfTask.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        taskInfo.nameOfTask.heightAnchor.constraint(equalToConstant: 50).isActive = true
        taskInfo.nameOfTask.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        //setup comments
        taskInfo.comment.topAnchor.constraint(equalTo: self.taskInfo.nameOfTask.bottomAnchor).isActive = true
        taskInfo.comment.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 22).isActive = true
        taskInfo.comment.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        taskInfo.comment.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 2/4).isActive = true
        
        //setup button - create task
        taskInfo.createButton.topAnchor.constraint(equalTo: self.taskInfo.comment.bottomAnchor).isActive = true
        taskInfo.createButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        taskInfo.createButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        taskInfo.createButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if flag {
            return true
        } else {
            return false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        taskInfo.comment.resignFirstResponder()
        return true
    }
    
}

