//
//  videoModel.swift
//  kidsTv
//
//  Created by Abdul-Aziz Gabbazov on 06.01.2018.
//  Copyright © 2018 Abdul-Aziz Gabbazov. All rights reserved.
//

import UIKit
import Alamofire

protocol VideoModelDelegate {
    func dataReady()
//    func allDataLoaded()
}

class VideoModel: NSObject {
    
    let API_KEY = "AIzaSyCAnCVWyHPqOn5yCnaZBWLR2uHE6SEN2uc"
    let UPLOADS_PLAYLIST_ID = "PLUumXRq81CH_Y3lqig4fdqyNqdnoNzXxQ"
//    let CHANNEL_ID = "UCDG4yO6I4PjwPQmV5CjK_UA"
    var videoArray = [Video]()
    
    var nextPageToken: String?
    
    var delegate:VideoModelDelegate?
    
    func getFeedVideos(){
        // Check if next page exists
        if nextPageToken == "" {
            // Notify the delegate that all data already loaded
//            if self.delegate != nil{
//                self.delegate!.allDataLoaded()
//            }
            return
        }

        // Fetch the videos dynamically through the YouTube Data API
        Alamofire.request("https://www.googleapis.com/youtube/v3/playlistItems", method: .get, parameters: ["part":"snippet", "playlistId":UPLOADS_PLAYLIST_ID, "pageToken": nextPageToken ?? "", "key":API_KEY, "maxResults":10], encoding: URLEncoding.default, headers: nil).responseJSON {[unowned self] (response) in
        
            if let JSON = response.result.value as? [String:Any]{
                var arrayOfTheVideos = [Video]()
                
                for video in JSON["items"] as! NSArray{
                    
//                    print(JSON)
                    
                    // Remember token pointing to next page
                    self.nextPageToken = JSON["nextPageToken"] as? String
                    print(self.nextPageToken)
                    
                    // Create video object off of the JSON responce
                    let videoObject = Video()
                    videoObject.videoId = (video as! NSDictionary).value(forKeyPath: "snippet.resourceId.videoId") as! String
                    videoObject.videoTitle = (video as! NSDictionary).value(forKeyPath: "snippet.title") as! String
                    videoObject.videoDescription = (video as! NSDictionary).value(forKeyPath: "snippet.description") as! String
                    
                    if (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.maxres.url") != nil{
                        videoObject.videoThumbnailUrl = (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.maxres.url") as! String
                    }else if (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.hqdefault.url") != nil{
                        videoObject.videoThumbnailUrl = (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.hqdefault.url") as! String
                    }else if (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.sddefault.url") != nil{
                        videoObject.videoThumbnailUrl = (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.sddefault.url") as! String
                    }else if (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.mqdefault.url") != nil{
                        videoObject.videoThumbnailUrl = (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.mqdefault.url") as! String
                    }else if (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.default.url") != nil{
                        videoObject.videoThumbnailUrl = (video as! NSDictionary).value(forKeyPath: "snippet.thumbnails.default.url") as! String
                    }else{
                        
                    }
                    
                    arrayOfTheVideos.append(videoObject)
                }
                
                // When all the video objects have been constructed, assign the array to the VideoModel property
                self.videoArray.append(contentsOf: arrayOfTheVideos)
                
                // Notify the delegate that the data is ready
                if self.delegate != nil{
                    self.delegate!.dataReady()
                }
                
            }
        }
    }
}
