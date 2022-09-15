//
//  File.swift
//  radio
//
//  Created by Joachim Dorel on 07/09/2022.
//

import Foundation

class Radio {
    let name: String
    let url: URL
    
    init(name: String, url: String) {
        self.name = name
        self.url = URL(string: url)!
    }
}
