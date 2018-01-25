//
//  VideoDetailViewController.swift
//  kidsTv
//
//  Created by Abdul-Aziz Gabbazov on 06.01.2018.
//  Copyright © 2018 Abdul-Aziz Gabbazov. All rights reserved.
//

import UIKit
import WebKit

class VideoDetailViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionScrollLabel: UITextView!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!

    var selectedVideo:Video?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let videoAppear = self.selectedVideo{
            
            self.titleLabel.text = videoAppear.videoTitle
            self.descriptionScrollLabel.text = videoAppear.videoDescription
            
            let width = self.view.frame.size.width
            let height = width/320 * 200
            
            // Adjust the height of the web constraint
            self.webViewHeightConstraint.constant = height
            
            let videoEmbedString = "<html><body><iframe src=\"http://www.youtube.com/embed/" + videoAppear.videoId + "\" width=\"100%\" height=\"100%\" frameborder=\"0\" allowfullscreen></iframe></body></html>"
            
            self.webView.loadHTMLString(videoEmbedString, baseURL: nil)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
