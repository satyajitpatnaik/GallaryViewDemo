//
//  ViewController.swift
//  Gallery
//
//  Created by Satyajit Patanaik on 6/18/17.
//  Copyright © 2017 SatyajitPatnaik. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController, RAReorderableLayoutDelegate, RAReorderableLayoutDataSource {

    var imageInfo: [ImageInfo]!
    
    /**
     Note: Image information UICollectionView.
     */
    
    @IBOutlet weak var collectionView: UICollectionView!

    
    //MARK: UIViewController LIfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let nib = UINib(nibName: "ImageInfoColCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageInfo = []
        /**
         Note: Get All Image Info.
         */
        imageInfo = DBManager.shared.loadAllImageInfo()
        
        collectionView.reloadData()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset = UIEdgeInsetsMake(topLayoutGuide.length, 0, 0, 0)
    }
    
    // RAReorderableLayout delegate datasource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let threePiecesWidth = floor(screenWidth / 3.0 - ((2.0 / 3) * 2))
        let twoPiecesWidth = floor(screenWidth / 2.0 - (2.0 / 2))
        if (indexPath as NSIndexPath).section == 0 {
            return CGSize(width: threePiecesWidth, height: threePiecesWidth)
        }else {
            return CGSize(width: twoPiecesWidth, height: twoPiecesWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 2.0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageInfoColCell", for: indexPath) as! ImageInfoColCell
        
        let imageInformation : ImageInfo = imageInfo[indexPath.row]
        let url = URL(string: imageInformation.url)!
        let placeholderImage = UIImage(named: "imageVwPlaceHolder")!
        
        cell.imageView.af_setImage(withURL: url, placeholderImage: placeholderImage)

        return cell
    }
        
    
    func scrollTrigerPaddingInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(collectionView.contentInset.top, 0, collectionView.contentInset.bottom, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageInfor : ImageInfo = imageInfo[indexPath.row]
        
        let query = "update ImageTable set click=\(imageInfor.click! + 1), lk=\(imageInfor.lk!), dislike=\(imageInfor.disLike!), updated_at=DateTime('now') where id=\(imageInfor.id!)"
        
        DBManager.shared.updateImageInfo(query: query, ID: imageInfor.id, clickCount: imageInfor.click + 1, likeCount: imageInfor.lk, disLikeCount: imageInfor.disLike)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImageDetailVc") as? ImageDetailVc
        viewController?.imageInfo = imageInfor
        self.navigationController?.pushViewController(viewController!, animated: true)
        
    }
}



