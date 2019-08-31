//
//  HomeViewController.swift
//  Swift5ResultsAPI
//
//  Created by Qtech on 31/08/19.
//  Copyright © 2019 Qtech. All rights reserved.
//

import UIKit

struct Course:Decodable{
    var id:Int
    var name: String
    var link : String
    var imageUrl:String
    var number_of_lessons:Int
}

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Old Method
        /*fetchCourseJson { (courses, err) in
            if let err = err{
                print("Failed to fetch course", err)
                return
            }
            courses?.forEach({ (course) in
                print(course.name)
            })
        }*/
        
        //New Method
        fetchCourseJson { (res) in
            switch res {
            case .success(let courses):
                courses.forEach({ (course) in
                    print(course.name)
                })
            case .failure(let err):
                print("Failed to fetch courses", err)
            }
        }
    }

    //Old Method
    /*fileprivate func fetchCourseJson(completion: @escaping ([Course]?, Error?)->()){
        let urlString = "http://api.letsbuildthatapp.com/jsondecodable/courses"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            //error
            if let err = err{
                completion(nil,err)
                return
            }
            //successful
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data!)
                completion(courses, nil)
            }catch let jsonError{
                completion(nil, jsonError)
            }
            
        }.resume()
    }*/
    
    //New Method
    fileprivate func fetchCourseJson(completion: @escaping (Result<[Course], Error>)->()){
        let urlString = "http://api.letsbuildthatapp.com/jsondecodable/courses"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            //error
            if let err = err{
                completion(.failure(err))
                //completion(nil,err)
                return
            }
            //successful
            do {
                let courses = try JSONDecoder().decode([Course].self, from: data!)
                completion(.success(courses))
                //completion(courses, nil)
            }catch let jsonError{
                completion(.failure(jsonError))
                //completion(nil, jsonError)
            }
            
            }.resume()
    }
}
