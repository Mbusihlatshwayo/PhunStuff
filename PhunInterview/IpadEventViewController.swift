//
//  IpadEventViewController.swift
//  PhunInterview
//
//  Created by Mbusi Hlatshwayo on 2/6/17.
//  Copyright © 2017 Mbusi. All rights reserved.
//

import UIKit

class IpadEventViewController: UIViewController, UIScrollViewDelegate {
    /* storyboard outlets*/
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var location1Label: UILabel!
    @IBOutlet weak var location2Label: UILabel!
    
    /* global variables to event VC*/
    var descriptionText = ""
    var phoneText = ""
    var dateText = ""
    var titleText = ""
    var location1Text = ""
    var location2Text = ""
    var imageUrlText = ""
    var starImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* create share button */
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareAction))
        navigationItem.rightBarButtonItem = shareButton
        
        /* set labels and image views from data passed from base VC*/
        dateLabel.text = dateText
        titleLabel.text = titleText
        location1Label.text = location1Text
        location2Label.text = location2Text
        descriptionLabel.text = descriptionText
        detailImage.sd_setImage(with: URL(string:imageUrlText), placeholderImage: UIImage(named: "placeholder_nomoon"), options: [.continueInBackground, .progressiveDownload])
        descriptionLabel.sizeToFit()
        myScrollView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        
        /* don't show the navigation bar only show the buttons*/
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
    }

    func shareAction(_ sender: Any) {
        
        /* create the text the user will share */
        let text = "Come to the \(titleText) on \(dateText)!!! Location: \(location1Text)"
        /* set up activity view controller */
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        /* present the VC*/
        present(activityViewController, animated: true, completion: nil)
        print(text)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /* deal with scroll animations here */
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
