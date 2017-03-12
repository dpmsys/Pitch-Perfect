//
//  RecordedAudioSave.swift
//  Pitch Perfect
//
//  Created by David Mulvihill on 3/22/15.
//  Copyright (c) 2015 David Mulvihill. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathURL: URL!
    var title: String!
    
    init(filePathURL: URL!, title: String!) {
        self.filePathURL = filePathURL
        self.title = title
    }
}
