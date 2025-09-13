//
//  InterstitialManager.swift
//  SpyRecorderApp
//
//  Created by Leo Chernyak on 10/09/2025.
//


import GoogleMobileAds
import UIKit

final class InterstitialManager: NSObject, FullScreenContentDelegate {
    private let adUnitID: String
    private var interstitial: InterstitialAd?

    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
        load()
    }

    func load() {
        InterstitialAd.load(with: adUnitID, request: Request()) { [weak self] ad, error in
            guard let self else { return }
            if let ad {
                self.interstitial = ad
                ad.fullScreenContentDelegate = self
            } else {
                // Перезагружаем позже
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) { self.load() }
            }
        }
    }

    func show(from root: UIViewController?) {
        if let ad = interstitial {
            ad.present(from: root)
        } else {
            load()
        }
    }

    // MARK: FullScreenContentDelegate
    func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        load()
    }
}
