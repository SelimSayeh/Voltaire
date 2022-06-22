//
//  onBoardingViewController.swift
//  Voltaire
//
//  Created by user210230 on 6/18/22.
//

import UIKit

class onBoardingViewController: UIViewController {
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBAction func nextBtn(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
            let  controller = storyboard?.instantiateViewController(withIdentifier: "HomeNC") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexpath = IndexPath (item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
        }
        
      
    }
    var slides : [onBoardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if (currentPage == slides.count - 1){
                Button.setTitle("Decouvrir", for: .normal)
            } else {
                Button.setTitle("Suivant", for: .normal)
            }
        }
    }
    

    override func viewDidLoad() {
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 3.5)) //delay splash screen
        super.viewDidLoad()
        slides = [
            onBoardingSlide(title: "THE VOLTAIRE BELLECOUR", description: "L’ergonomie au service de votre confort.", image: #imageLiteral(resourceName: "Velo1")),
            onBoardingSlide(title: "THE VOLTAIRE COURCELLE", description: "Pour votre tranquillité d’esprit.", image: #imageLiteral(resourceName: "Velo2")),
                ]
        
    }
    

   

}
extension onBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
   
    func collectionView (_ collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return slides.count
    }
    
    func  collectionView(_ collectionView:UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:onBoardingCollectionViewCell.identifier, for: indexPath)
        as! onBoardingCollectionViewCell
        cell.setup(slides[indexPath.row])//populate the label,image and description
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width )
       
    }
}
