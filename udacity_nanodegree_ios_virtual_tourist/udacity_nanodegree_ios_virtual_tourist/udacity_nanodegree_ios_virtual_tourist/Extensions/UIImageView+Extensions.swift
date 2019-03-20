//
//  UIImageView+Extensions.swift
//  udacity_nanodegree_ios_virtual_tourist
//
//  Created by Eduardo Soares on 27/07/2018.
//  Copyright © 2018 Eduardo Soares. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    typealias DownloadPhotoFinished = (Data?)->Void
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit,_ result:DownloadPhotoFinished?) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
                result?(data)
//                let imageName = url.lastPathComponent
//                if let data = UIImagePNGRepresentation(image) {
//                    let filename = getDocumentsDirectory().appendingPathComponent(imageName)
//                    try? data.write(to: filename)
//                    result?(filename.path)
//                }
            }
        }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit,result:DownloadPhotoFinished?) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode,result)
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
