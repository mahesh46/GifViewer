//
//  GifModel.swift
//  GifViewer
//
//  Created by Administrator on 05/03/2019.
//  Copyright © 2019 mahesh lad. All rights reserved.
//


import Foundation
import UIKit

class object : Decodable {
   var data : [data]
}

class data : Decodable {
    var id : String
    var images : images
    var title: String
}

class images : Decodable {
    var original : original
    var preview_gif : preview_gif
}

class preview_gif : Decodable {
     var url : String
}

class original : Decodable {
    var url : String
    var width : String
    var height : String
    var mp4 : String
    
}
class GifModel  {
    
    var title : String
    var url : String
    var width : String
    var height : String
    var id: String
    var mp4 : String
    var previewUrl : String
    
    init(title: String, url: String, width: String, height: String, id: String, mp4 : String, previewUrl : String) {
        
        self.title = title
        self.url = url
        self.width = width
        self.height = height
        self.id = id
        self.mp4 = mp4
        self.previewUrl = previewUrl
    }
}
