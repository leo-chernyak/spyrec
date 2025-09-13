import SwiftUI
import GoogleMobileAds
import UIKit

final class BannerDelegate: NSObject, BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("Banner loaded")
    }
    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        print("Banner failed: \(error)")
    }
}

struct AdBannerView: UIViewRepresentable {
    let adUnitID: String
    private let delegate = BannerDelegate()

    func makeUIView(context: Context) -> BannerView {
        // v12: BannerView(adSize:)
        let banner = BannerView(adSize: AdSizeBanner)
        banner.adUnitID = adUnitID
        banner.delegate = delegate

        // Привяжем root VC, когда вью появится
        banner.rootViewController = UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?
            .rootViewController

        // v12: Request()
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        if uiView.rootViewController == nil {
            uiView.rootViewController = UIApplication.shared
                .connectedScenes
                .compactMap { ($0 as? UIWindowScene)?.keyWindow }
                .first?
                .rootViewController
        }
    }
}
