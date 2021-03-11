//
//  ViewController.swift
//  UIcollectionViewApp
//
//  Created by Joy Massey on 28/02/21.
//

import UIKit

class ViewController: UIViewController {

    var indexRow = 1
    var bookmarkButtonClickCount = 1
    var likeButtonClickCount = 1
    @IBOutlet weak var likeCount:UILabel!
    @IBOutlet weak var label:UILabel!
    @IBOutlet weak var bookmark: UIButton!
    @IBOutlet weak var heart: UIButton!
    
  
    @IBOutlet weak var newsCollectionView: UICollectionView!
    let images = ["s1","s2","s3","s4","s5","s6"]
    override func viewDidLoad() {
        super.viewDidLoad()
        newsCollectionView.dataSource = self
        newsCollectionView.delegate = self
        // Do any additional setup after loading the view.
            }

    @IBAction func bookmarkButton(_ sender: UIButton) {
        bookmarkButtonClickCount += 1
        print(bookmarkButtonClickCount)
        if bookmarkButtonClickCount % 2 == 0 {
        let image =  UIImage(systemName:"bookmark.fill")
        bookmark.setImage(image, for: .normal)
        }
        else
        {
        
            let image =  UIImage(systemName:"bookmark")
            bookmark.setImage(image, for: .normal)
        }
        
    }
    @IBAction func likeButton(_ sender: UIButton) {
        
       likeButtonClickCount += 1
        if likeButtonClickCount % 2 == 0
        {
        let image =  UIImage(systemName:"heart.fill")
        let likeCounter = Int(likeCount.text!)! + 1
        likeCount.text = String(likeCounter)
        heart.setImage(image, for: .normal)
        }
        else
        {
            let image =  UIImage(systemName:"heart")
            let likeCounter = Int(likeCount.text!)! - 1
            likeCount.text = String(likeCounter)
            heart.setImage(image, for: .normal)
        }
    
    }
    
    @IBAction func shareButton(_ sender: UIButton) {
       
       shareImage(sender: sender, indexRow: indexRow - 1)
    }
    func shareImage(sender:UIButton,indexRow:Int){
        // Setting description
           // let firstActivityItem =  UIImage(named: "\(images[0])")

            // Setting url
            //let secondActivityItem : NSURL = NSURL(string: "http://www.google.com/")!
            
            // If you want to use an image
        
            let image : UIImage = UIImage(named: "\(images[indexRow])")!
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [image], applicationActivities: nil)
            
            // This lines is for the popover you need to show in iPad
            activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
            
            // This line remove the arrow of the popover to show in iPad
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            // Pre-configuring activity items
            activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
            ] as? UIActivityItemsConfigurationReading
            
            // Anything you want to exclude
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.postToWeibo,
                UIActivity.ActivityType.print,
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.addToReadingList,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToFacebook
            ]
            
            activityViewController.isModalInPresentation = true
        
            self.present(activityViewController, animated: true, completion: nil)
    }
}
// MARK:- UICollectionViewDataSource
extension ViewController:UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      //  print(indexRow)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        cell.newsImage.image =  UIImage(named: "\(images[indexPath.row])")
        cell.newsImage.layer.cornerRadius = 10.0
        cell.newsImage.layer.masksToBounds = true
        return cell
    }
    

}

extension ViewController:UIScrollViewDelegate,UICollectionViewDelegate
{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.newsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundIndex = round(index)
        offset = CGPoint(x: roundIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in newsCollectionView.visibleCells {
            let indexPath = newsCollectionView.indexPath(for: cell)
            print(indexPath?.row)
            indexRow = indexPath!.row
        }
    }
    
}
