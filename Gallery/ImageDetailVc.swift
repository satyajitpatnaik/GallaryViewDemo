//
//  ImageDetailVc.swift
//  Gallery
//
//  Created by Satyajit Patanaik on 6/18/17.
//  Copyright © 2017 SatyajitPatnaik. All rights reserved.
//

import UIKit

class ImageDetailVc: UIViewController {

    /**
     Note: IBOutlet connections
     */
    //MARK: - IBOutlet
    @IBOutlet weak var selectedImageVw: UIImageView!
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var createdOn: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var disLikeButton: UIButton!
    
    var imageInfo : ImageInfo = ImageInfo()

    //MARK: UIViewController LIfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: imageInfo.url)!
        let placeholderImage = UIImage(named: "imageVwPlaceHolder")!
        
        self.selectedImageVw.af_setImage(withURL: url, placeholderImage: placeholderImage)
        self.lastUpdate.text = "\(imageInfo.updated_at!)"
        self.createdOn.text = "\(imageInfo.created_at!)"
        self.likeButton.setTitle("Like (\(imageInfo.lk!))", for: .normal)
        self.disLikeButton.setTitle("Dislike (\(imageInfo.disLike!))", for: .normal)
    }

    //MARK: - UIButton Actions
    
    /**
     Note: Like button action
     */
    @IBAction func likeButtonTapped(_ sender: Any) {

        var disLikeCount = Int()
        if imageInfo.disLike > 0 {
            disLikeCount = imageInfo.disLike - 1
        } else {
            disLikeCount = 0
        }

        let query = "update ImageTable set click=\(imageInfo.click!), lk=\(imageInfo.lk! + 1), dislike=\(disLikeCount), updated_at=DateTime('now') where id=\(imageInfo.id!)"
        
        DBManager.shared.updateImageInfo(query: query, ID: imageInfo.id, clickCount: imageInfo.click, likeCount: imageInfo.lk + 1, disLikeCount: imageInfo.disLike)

        self.likeButton.setTitle("Like (\(imageInfo.lk + 1))", for: .normal)
        self.disLikeButton.setTitle("Dislike (\(disLikeCount))", for: .normal)

        DBManager.shared.refreshImageInfo(withID: imageInfo.id, completionHandler: { (info) in
            imageInfo = info!
        })
    }
    
    /**
     Note: Dislike button action
     */

    @IBAction func disLikeButtonTapped(_ sender: Any) {
        var likeCount = Int()
        if imageInfo.lk > 0 {
            likeCount = imageInfo.lk - 1
        } else {
            likeCount = 0
        }
        let query = "update ImageTable set click=\(imageInfo.click!), lk=\(likeCount), dislike=\(imageInfo.disLike! + 1), updated_at=DateTime('now') where id=\(imageInfo.id!)"
        DBManager.shared.updateImageInfo(query: query, ID: imageInfo.id, clickCount: imageInfo.click, likeCount: imageInfo.lk, disLikeCount: imageInfo.disLike + 1)

        self.likeButton.setTitle("Like (\(likeCount))", for: .normal)
        self.disLikeButton.setTitle("Dislike (\(imageInfo.disLike + 1))", for: .normal)

        DBManager.shared.refreshImageInfo(withID: imageInfo.id, completionHandler: { (info) in
            imageInfo = info!
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
