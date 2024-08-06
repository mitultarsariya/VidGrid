//
//  ReelVC.swift
//  VidGrid
//
//  Created by iMac on 05/08/24.
//

import UIKit

class ReelVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var clvReelView: UICollectionView!
    
    // MARK: - Variables
    private var viewModel = ReelViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configuration()
    }
    
    private func setupCollectionView() {
        
        clvReelView.register(UINib(nibName: "MyCell", bundle: nil), forCellWithReuseIdentifier: "MyCell")
        clvReelView.dataSource = self
        clvReelView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 600)
        layout.minimumInteritemSpacing = 100
        layout.minimumLineSpacing = 100
        clvReelView.collectionViewLayout = layout
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

}

extension ReelVC {
    
    func configuration() {
        setupCollectionView()
        initViewModel()
        observeEvent()
    }
    
    func initViewModel() {
        
        viewModel.fetchReels()
    }
    
    func observeEvent() {
        
        viewModel.eventHandler = { [weak self] event in
            guard let self = self else { return }
            switch event {
            case .loading:
                debugPrint("loading...")
            case .stopLoading:
                debugPrint("Stop loading...")
            case .dataLoaded:
                debugPrint("Data loaded")
                debugPrint(self.viewModel.arrReel)
                DispatchQueue.main.async {
                    self.clvReelView.reloadData()
                }
            case .error(let error):
                debugPrint(error as Any)
            }
        }
    }
    
}

extension ReelVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.arrReel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? MyCell else { return UICollectionViewCell() }
        cell.configure(with: viewModel.arrReel[indexPath.row].arr)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 600)
    }
}

extension ReelVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard let visibleCells = clvReelView.visibleCells as? [MyCell] else { return }
        visibleCells.forEach { cell in
            cell.playNextVideo()
        }
    }
    
}
