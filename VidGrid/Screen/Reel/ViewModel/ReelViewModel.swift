//
//  ReelViewModel.swift
//  VidGrid
//
//  Created by iMac on 06/08/24.
//

import Foundation

final class ReelViewModel {
    
    var arrReel: [Reel] = []
    var eventHandler: ((_ event: Event) -> Void)?
  
    func fetchReels() {
        self.eventHandler?(.loading)
        readJSONFile { response in
            self.eventHandler?(.stopLoading)
            switch response {
            case .success(let reels):
                self.arrReel = reels
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                self.eventHandler?(.error(error))
            }
        }
    }
    
}

extension ReelViewModel {
    
    enum Event {
        case loading
        case stopLoading
        case dataLoaded
        case error(Error?)
    }
}
