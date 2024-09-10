//
//  AMDVODPlaybackManager.swift
//
//
//

import SwiftUI
import AVKit
import Combine
import AMDVideoPlayer


/// This is a reference implementationplayback manager for Video On Demand (VOD).
///
/// This manager is designed to support the playback of one or more queued VOD
/// items. It provides example implementations of all relevant coordinator types
/// for VOD playback including:
/// - Interstitial insertion and playback during a primary program
/// - Media selection definition and selection response
/// - Picture-in-Picture support
/// - User Interface definition and updating during playback
/// - Video navigation during playback
/// - Video presentation
///
class AMDVODPlaybackManagerRefImp: AMDPlaybackManager {
    
    let userInterface: AMDVideoPlayerUIConfiguration
        
    override init() {
        userInterface = AMDVODPlaybackManagerRefImp.configureUI()
    }
    
    init(userInterface: AMDVideoPlayerUIConfiguration) {
        self.userInterface = userInterface
    }
    
    override func nextPlayerItems() -> [AVPlayerItem] {
        guard let longformURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/adv_dv_atmos/main.m3u8"),
              let shortformURL = URL(string: "http://cdnbakmi.kaltura.com/p/243342/sp/24334200/playManifest/entryId/0_uka1msg4/flavorIds/1_vqhfu6uy,1_80sohj7p/format/applehttp/protocol/http/a.m3u8"),
              let liveURL = URL(string:
              "https://s8host1.localnow.api.cms.amdvids.com/v1/master/c189661feba961c19bc5fb60b57879ee9b84548a/config10/playlist.m3u8?ads.cdnhost=s8host1.localnow.api.cms.amdvids.com&ads.playbackid=1DC746AE-9277-4C2F-8447-2CE24F0B9C26&ads.n1=rule_id&ads.v1=F0F2D67E-43F6-4794-9B68-414843159DD7-1714063134&ads.n3=qp_content_id&ads.v3=1DC746AE-9277-4C2F-8447-2CE24F0B9C26&ads.n4=content_name&ads.v4=NBC%2520Washington%2520News%2520Hyperlocal&ads.n21=w&ads.v21=1920&ads.n22=content_custom_3_param&ads.v22=channel&ads.n23=content_type&ads.v23=channel&ads.n24=ifa_type&ads.v24=idfa&ads.n25=device_model&ads.v25=iPhone&ads.n26=ip&ads.v26=108.31.220.153&ads.n27=app_version&ads.v27=6.5.7&ads.n28=app_name&ads.v28=LocalNow&ads.n29=h&ads.v29=1080&ads.n30=device_type&ads.v30=4&ads.n31=channel_title&ads.v31=NBC%2520Washington%2520News%2520Hyperlocal&ads.n32=channel_company_id&ads.v32=AMDP500448&ads.n33=content_custom_2_param&ads.v33=AMDB013249&ads.n34=channel_name&ads.v34=NBC%2520Washington%2520News%2520Hyperlocal&ads.n35=channel_language&ads.v35=English&ads.n36=url&ads.v36=&ads.n37=us_privacy&ads.v37=1YNY&ads.n38=content_custom_1_param&ads.v38=1DC746AE-9277-4C2F-8447-2CE24F0B9C26&ads.n39=channel_brand_id&ads.v39=AMDB013249&ads.n40=content_provider&ads.v40=nbc-washington-news&ads.n41=app_store_url&ads.v41=https%253A%252F%252Fapps.apple.com%252Fus%252Fapp%252Flocal-now-stream-your-city%252Fid1117556939&ads.n42=device_make&ads.v42=Apple&ads.n43=content_producer_name&ads.v43=NBCUniversal&ads.n44=did&ads.v44=B802F2AF-47C4-429D-92E9-AAE674A6C820&ads.n45=dnt&ads.v45=0&ads.n46=pos&ads.v46=midroll&ads.n47=content_livestream&ads.v47=1&ads.n48=channel_id&ads.v48=1DC746AE-9277-4C2F-8447-2CE24F0B9C26&ads.n49=channel_ext_id&ads.v49=&ads.n50=channel_corp&ads.v50=NBCUniversal&ads.n51=channel_genre&ads.v51=News&ads.n52=channel_rating&ads.v52=TV-PG&ads.n53=app_bundle&ads.v53=1117556939&ads.n54=cust_devicename&ads.v54=ios&ads.n55=network_name&ads.v55=nbc-washington-news&ads.n56=ua&ads.v56=iPhone11%252C8%2520iOS%252F17.4.1%2520CFNetwork%252F1494.0.7%2520Darwin%252F23.4.0&ads.ttd_uid2&ads.adc_token=QkFJREJDQ0FCRkRpZThpNzFDLzdELzA&ads.paln=AQzzBGQEDnuGtjKih_iO0rmv5pBQf6MI9PIn6Ue2UiM6yQ5VUNPq8f4H0JJ8JVcB0X_HUaFXuv2U9WtBzzMH2te65NXirowy6QMvj8eWJCB9S9_ezy9HWWV8VJyoGS8uNUfEaynoAWylhhY__1b5gcB-RRIuzzB4DkfFrShRK5MBWT10iHouZ-L4jl_HGADMGpmvFMuBUj4sloaTae2WgldH5uZm9Eife79vS_5dlRqeDbc9ovm6v05UKQaGy33j9D5Pb-V_sYaUefEjUJtZSz-PmjDvJqSFnECuTCj-eMbxVFH_CGv36jKdT9v77c9GL1vPKHHeX00fBxeKt5Z9x6WEod5Mtpj9RnlhB-Tg80XLA7xbs673eaFxEKLhf3QrnlcwPHKSODnhPACoJeqLOPYhGCEiqWIN5L6bHyCpYePcAylqxLAjtozT4WV319jb1EW1SvBIrkvf0QAVJBcpP7OzYwRM-tRuTT024mTdKuXhji_z5_Y3t2-kq85VSxBlsyv2GShPrW2W7RItFhcKR1zMgiWCoK4BFTu-lzmQpaTitnfMtr_zN_1l3z-M8QCRdclxMRUbKx9xCc0msp_lDroY3DWHsEMxOGlOeeIOUHWWLOIc_w2ck8tBA7jysdSSu2hf4uwdprNgsruqjvC9mEs4unayte3vhoL1AeeLlpTfe8l_qibbbMR1I5de3_t8AI6KsCxjfIKshBACnC1ikxhhz4QhbjofkV1PzX1uk251-F-CjKsjxb8P5qb4SPVxTvaWUBTq42r6yfannxIetgx9KtCHdaePlSA0a-zleHDU6ItV-OgR6UoPoEC7MyRfwZ53ujjAVYh6w-3f_q4wp_HCsHD4pKHI64qAAmfcR-gKyHoKHuHVWwlHlcTQiXYV-uXIFS8n_KrmDSaDHVjcyJNcMlb1xzhpcDzq3s91mliPrSGtNkoLovmnUWoL2y2NLbX9Z8YwUA4WJNVFZL3_sGx2U4HIAWUtNlccfZTv61uCTDTeDVDPIJzw0YB9%20HTTP/1.1")

        else {
            return []
        }
        let playerItem1 = AVPlayerItem(url: shortformURL)
        playerItem1.translatesPlayerInterstitialEvents = true
        
        let playerItem2 = AVPlayerItem(url: longformURL)
        playerItem2.translatesPlayerInterstitialEvents = true
        
        let playerItem3 = AVPlayerItem(url: liveURL)
        
        return [playerItem1, playerItem2, playerItem3]
    }
    
    private static func configureUI() -> AMDVideoPlayerUIConfiguration {
        return AMDVideoPlayerUIConfiguration()
    }
    
}


extension AMDVODPlaybackManagerRefImp: AMDContentProposalCoordinator {
    func videoPlayerAccepted(contentProposal: AVContentProposal) {
        
    }
    
    func videoPlayerRejected(contentProposal: AVContentProposal) {
        
    }
    
    func videoPlayerShouldPresent(contentProposal: AVContentProposal) -> Bool {
        return true
    }
    
}


extension AMDVODPlaybackManagerRefImp: AMDInterstitialCoordinator {
    func interstitialEvents(for playerItems: [AVPlayerItem]) -> [AVPlayerInterstitialEvent] {
        var events = interstitialPreRoll(for: playerItems)
        events.append(contentsOf: interstitialMidRoll(for: playerItems))
        return events

    }
    
    private func interstitialPreRoll(for playerItems: [AVPlayerItem]) -> [AVPlayerInterstitialEvent] {
        guard let interstitialURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")
        else { return []  }
        let primaryItem = playerItems[1]
        let event = AVPlayerInterstitialEvent(primaryItem: primaryItem, time: CMTime(seconds: 0, preferredTimescale: 1))
        event.templateItems.append(AVPlayerItem(url:interstitialURL))
        event.identifier = "MidRoll"
        event.playoutLimit = CMTime(seconds: 6, preferredTimescale: 1)
        event.resumptionOffset = .zero
        return [event]
        
    }
    
    private func interstitialMidRoll(for playerItems: [AVPlayerItem]) -> [AVPlayerInterstitialEvent] {
        let primaryItem = playerItems[1]
        let event1 = AVPlayerInterstitialEvent(primaryItem: primaryItem, time: CMTime(seconds: 15, preferredTimescale: 1))
        event1.templateItems.append(AVPlayerItem(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")!))
        event1.identifier = "MidRoll"
        event1.playoutLimit = CMTime(seconds: 5, preferredTimescale: 1)
        event1.resumptionOffset = .zero
        
        let event2 = AVPlayerInterstitialEvent(primaryItem: primaryItem, time: CMTime(seconds: 25, preferredTimescale: 1))
        event2.templateItems.append(AVPlayerItem(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!))
        event2.identifier = "MidRoll"
        event2.playoutLimit = CMTime(seconds: 5, preferredTimescale: 1)
        
        return [event1, event2]
    }
}

extension AMDVODPlaybackManagerRefImp: AMDMediaSelectionCoordinator {
    func videoPlayerSelected(_ option: AVMediaSelectionOption?, in group: AVMediaSelectionGroup) {
        
    }
}


extension AMDVODPlaybackManagerRefImp: AMDPictureInPictureCoordinator {
    
}

extension AMDVODPlaybackManagerRefImp: AMDUserInterfaceCoordinator {
    var userInterfaceConfiguration: AMDVideoPlayerUIConfiguration {
        get {
            return userInterface
        }
    }
    
    func transportBarWillTransition(to visible: Bool, using coordinator: any AVPlayerViewControllerAnimationCoordinator) {
        
    }
    
    
}

extension AMDVODPlaybackManagerRefImp: AMDVideoNavigationCoordinator {
    
}

extension AMDVODPlaybackManagerRefImp: AMDVideoPresentationCoordinator {
    
}
