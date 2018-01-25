//
//  ViewController.swift
//  kidsTv
//
//  Created by Abdul-Aziz Gabbazov on 05.01.2018.
//  Copyright © 2018 Abdul-Aziz Gabbazov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VideoModelDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var videos:[Video] = [Video]()
    var selectedVideo:Video?
    let model:VideoModel = VideoModel()
    var isLoadingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.model.delegate = self
        
        // Fire off request to get videos
        model.getFeedVideos()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - VideoModel Delegate Methods
    
    func dataReady() {
        // Access the video objects that have been downloaded
        self.videos = self.model.videoArray
        
        // Tell the tableView to reload
        self.tableView.reloadData()
    }
    
    // MARK: - tableView Delegate methods
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Get the width of the screen to calculate height of the row
        return (self.view.frame.size.width / 320) * 180
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videos.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")!
        let videoTitle = videos[indexPath.row].videoTitle
        
        // Get the label for the cell
        let label = cell.viewWithTag(2) as! UILabel
        label.text = videoTitle
        

        // Construct the video thumbnail url
        let videoThumbnailUrlString = videos[indexPath.row].videoThumbnailUrl
        
        // Create an URL object
        let videoThumbnailUrl = URL(string: videoThumbnailUrlString)
        
        (cell.viewWithTag(1) as? UIImageView)?.image = videos[indexPath.row].thumbnailImage
        
        if videoThumbnailUrl != nil && (cell.viewWithTag(1) as? UIImageView)?.image == nil {
            
            // Create an URLRequest object
            let request = URLRequest(url: videoThumbnailUrl!)
            
            // Create an URLSession
            let session = URLSession.shared
            
            // Create a dataTask and pass in the request
            let dataTask = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) in
                
                DispatchQueue.main.sync {
                 
                    // Get a reference to the imageView element of the cell
                    let imageView = cell.viewWithTag(1) as? UIImageView
                    
                    // Create an Image object from the data and assign it into the imageView
                    imageView?.image = UIImage(data: data!)
                    self.videos[indexPath.row].thumbnailImage = imageView?.image
                    
                }
                
            })
            
            dataTask.resume()
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Take a note of which video user selected
        self.selectedVideo = self.videos[indexPath.row]
        
        // Call the segue
        self.performSegue(withIdentifier: "goToDetail", sender: self)
        
    }

    // Detect when user scrolls to end of table
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 {
            model.getFeedVideos()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the reference to the destination view controller
        let detailViewController = segue.destination as! VideoDetailViewController
        
        // Set the selected video property of the destination view controller
        detailViewController.selectedVideo = self.selectedVideo
    }
    
//    // Creating a Slide Menu
//    func slideMenu(){
//        sideView.layer.shadowColor = UIColor.black.cgColor
//        sideView.layer.shadowOpacity = 0.8
//        sideView.layer.shadowOffset = CGSize(width: 2, height: 0)
//
//
//    }
    
}

