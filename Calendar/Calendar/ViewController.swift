//
//  ViewController.swift
//  Calendar
//
//  Created by 黄穆斌 on 16/11/11.
//  Copyright © 2016年 Myron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Habit(entity: <#T##NSEntityDescription#>, insertInto: <#T##NSManagedObjectContext?#>)
        collectionView.initDeploy(delegate: self)
        //collectionView.scrollToItem(at: IndexPath(row: 0, section: 5000), at: UICollectionViewScrollPosition.top, animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //collectionView.scrollToItem(at: IndexPath(item: 0, section: collectionView.origin), at: .top, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var collectionView: LoopCollectionView!

}

extension ViewController: LoopCollectionViewDelegate {
    
    func loopCollection(loopView: LoopCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func loopCollection(loopView: LoopCollectionView, cellForItem cell: LoopCollectionViewCell, atSection section: Int, row: Int) {
        cell.label.text = "\(cell.section) - \(cell.row)"
    }
    
    func loopCollection(loopView: LoopCollectionView, willDisplay cell: LoopCollectionViewCell, atSection section: Int, row: Int) {
        cell.label.text = "\(cell.section) - \(cell.row)"
    }
    
    func loopCollection(loopView: LoopCollectionView, headerForItem header: UICollectionReusableView, atSection section: Int) {
        header.backgroundColor = UIColor.blue
    }
    
    func loopCollection(loopView: LoopCollectionView, willDisplayHeader header: UICollectionReusableView, atSection section: Int) {
        header.backgroundColor = UIColor.blue
    }
    
    func loopCollection(loopView: LoopCollectionView, layout: UICollectionViewLayout, sizeForItemAtSection section: Int, row: Int) -> CGSize {
        return CGSize(width: 100, height: 50)
    }
    
    func loopCollection(loopView: LoopCollectionView, layout: UICollectionViewLayout, sizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 500, height: 60)
    }
    
}
