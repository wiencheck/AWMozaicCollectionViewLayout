//
//  ViewController.swift
//  AWMozaicCollectionViewLayoutExample
//
//  Created by Adam Wienconek on 21/12/2020.
//

import UIKit
import AWMozaicCollectionViewLayout

class ViewController: UIViewController {
    
    lazy var colors: [UIColor] = {
        return (0...600).map { _ in UIColor.random }
    }()
    
    lazy var mozaicLayout = AWMozaicLayout(delegate: self)
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(mozaicLayout, animated: false)
        collectionView.dataSource = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath)
        
        cell.contentView.backgroundColor = colors[indexPath.row]
        return cell
    }
}

extension ViewController: AWMozaicLayoutDelegate {
    private func numberOfColumns(in collectionView: UICollectionView) -> Int {
        return collectionView.traitCollection.horizontalSizeClass == .regular ? 4 : 3
    }
    
    func collectonView(_ collectionView: UICollectionView, mozaik layout: AWMozaicLayout, geometryInfoFor section: Int) -> AWMozaicLayoutSectionGeometryInfo {
        let sectionInset: CGFloat = 8
        let interItemSpacing: CGFloat = 8
        let lineSpacing = interItemSpacing
        let numberOfColumns = self.numberOfColumns(in: collectionView)
        let cgNumberOfColumns = CGFloat(numberOfColumns)
        
        let columnWidth = (collectionView.bounds.width - (2 * sectionInset) - (cgNumberOfColumns - 1) * interItemSpacing) / cgNumberOfColumns
        let columns = Array<AWMozaicLayoutColumn>(repeating: AWMozaicLayoutColumn(width: columnWidth), count: numberOfColumns)
        // Square cells
        let rowHeight = columnWidth
                
        return AWMozaicLayoutSectionGeometryInfo(rowHeight: rowHeight,
                                                 columns: columns,
                                                 minimumInteritemSpacing: interItemSpacing,
                                                 minimumLineSpacing: lineSpacing,
                                                 sectionInset: UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset),
                                                 headerHeight: 0,
                                                 footerHeight: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, mozaik layout: AWMozaicLayout, mozaikSizeForItemAt indexPath: IndexPath) -> AWMozaicLayoutSize {
        let mod = self.numberOfColumns(in: collectionView) + 2
        let isLarge = indexPath.row % mod == 0
        return AWMozaicLayoutSize(numberOfColumns: isLarge ? 2 : 1, numberOfRows: isLarge ? 2 : 1)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
