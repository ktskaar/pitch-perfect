//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Kirk Skaar on 05/25/2015.
//  Copyright (c) 2015 SixOneZero. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init (filePathURL: NSURL, title: String) {
        self.filePathUrl = filePathURL
        self.title = title
    }
}