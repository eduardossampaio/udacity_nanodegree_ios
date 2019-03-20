//
//  StudentDAO.swift
//  On the map
//
//  Created by Eduardo Soares Sampaio on 17/07/2018.
//  Copyright © 2018 Eduardo Soares Sampaio. All rights reserved.
//

import Foundation

class StudentDAO {
    static let instance = StudentDAO()
    public var cachedStudents = [Student]()
    private init(){
    }
    
}
