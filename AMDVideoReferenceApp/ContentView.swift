//
//  ContentView.swift
//  AMDVideoReferenceApp
//
//  Created by Erik Heath Thomas on 8/26/24.
//

import SwiftUI
import AMDVideoPlayer

struct ContentView: View {
    var body: some View {
        AMDVideoPlayer(playbackManager: AMDVODPlaybackManagerRefImp())
    }
}

#Preview {
    ContentView()
}
