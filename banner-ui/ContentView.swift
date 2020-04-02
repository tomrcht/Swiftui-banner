//
//  ContentView.swift
//  banner-ui
//
//  Created by Tom Rochat on 02/04/2020.
//  Copyright © 2020 Tom Rochat. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var data = BannerData(icon: "flame.fill", message: "Shit's on fire yo", level: .error)

    @State private var show = false

    var body: some View {
        VStack {
            Button(action: {
                self.show.toggle()
            }) { Text("Open banner") }

            Button(action: {
                self.data.message = String(Int.random(in: 0...1000))
            }) { Text("Change text") }

            Button(action: {
                let i = Int.random(in: 0...3)
                switch i {
                case 0: self.data.level = .info
                case 1: self.data.level = .success
                case 2: self.data.level = .warning
                case 3: self.data.level = .error
                default: self.data.level = .info
                }
            }) { Text("Change color") }

        }
        .banner(data: $data, show: $show)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
