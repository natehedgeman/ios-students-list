//
//  StudentController.swift
//  Students
//
//  Created by Nathan Hedgeman on 6/4/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation

class StudentController {
    
    private var persistentFileURL: URL? {
        
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else {return nil}
        
        return URL(fileURLWithPath: filePath)
        
    }
    
    func loadFromPersistentStore(completion: @escaping ([Student]?, Error?) -> Void) {
        
        let backgroundQueue = DispatchQueue(label: "studentQueue", attributes: .concurrent)
        
        backgroundQueue.async {
            let fm = FileManager.default
            
            guard let URL = self.persistentFileURL,
                fm.fileExists(atPath: URL.path) else {completion(nil, NSError()) ; return}
            
            do {
                
                let data = try Data(contentsOf: URL)
                let decoder = JSONDecoder()
                let students = try decoder.decode([Student].self, from: data)
                completion(students, nil)
                
            } catch {
                
                print("Error loading student data \(error)")
                completion(nil, error)
                
            }
        }
        
    }
}
