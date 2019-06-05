//
//  MainViewController.swift
//  Students
//
//  Created by Nathan Hedgeman on 6/4/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    

    //MARK: - Properties
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    private let studentController = StudentController()
    private var studentTableViewController: StudentTableViewController! {
        
        didSet {
            
            self.updateDataSource()
            
        }
        
    }
    
    private var students: [Student] = [] {
        
        didSet {
            
            self.updateDataSource()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.studentController.loadFromPersistentStore { (students, error) in
            if let error = error {
                print("There was an error loading students \(error)")
                return
            }
            DispatchQueue.main.async{
            self.students = students ?? []
            }
        }
    }
    
    //MARK: IBActions
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        self.updateDataSource()
        
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        self.updateDataSource()
    }
        
        
        private func updateDataSource() {
            
            var sortedAndFilteredStudents: [Student]
            
            switch self.filterSelector.selectedSegmentIndex {
            case 1:
                sortedAndFilteredStudents = self.students.filter { $0.course == "iOS"}
//                sortedAndFilteredStudents = self.students.filter({ (student) -> Bool in
//                    return student.course == "IOS"
//                })
                
            case 2:
                sortedAndFilteredStudents = self.students.filter { $0.course == "Web"}
                
            case 3:
                sortedAndFilteredStudents = self.students.filter { $0.course == "UX"}
                
            default:
                sortedAndFilteredStudents = self.students
            }
            
            if self.sortSelector.selectedSegmentIndex == 0 {
                
                sortedAndFilteredStudents = sortedAndFilteredStudents.sorted(by: { (firstStudent, secondStudent) -> Bool in
                    firstStudent.firstName < secondStudent.firstName
                })
                
            } else {
                
                sortedAndFilteredStudents = sortedAndFilteredStudents.sorted(by: { (firstStudent, secondStudent) -> Bool in
                    firstStudent.lastName < secondStudent.lastName
                })
                
            }
            self.studentTableViewController.students = sortedAndFilteredStudents
        }
    
    
    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "StudentTableEmbedSegue" {
            
            self.studentTableViewController = segue.destination as? StudentTableViewController
            
        }
        
    }
    

}
