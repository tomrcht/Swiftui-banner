//
//  Banner.swift
//  banner-ui
//
//  Created by Tom Rochat on 02/04/2020.
//  Copyright © 2020 Tom Rochat. All rights reserved.
//

import SwiftUI

// I know this file is a mess but flemme to fix rn...

// MARK: - Banner modifications / data
struct BannerData {
    public var icon: String?
    public var message: String

    public var level: BannerLevel = .info
    public var duration: Int?
}

enum BannerLevel {
    case info, warning, success, error

    var color: Color {
        switch self {
        case .info: return .blue
        case .warning: return .orange
        case .success: return .green
        case .error: return .pink
        }
    }
}

fileprivate enum BannerConstants: CGFloat {
    case innerPadding = 10.0
    case cornerRadius = 8.0
}

// MARK: - Banner composition
fileprivate struct BannerIcon: View {
    public var name: String

    var body: some View {
        Image(systemName: name)
            .foregroundColor(.white)
    }
}

fileprivate struct BannerDescription: View {
    public var description: String

    var body: some View {
        Text(description)
            .font(.callout)
            .fontWeight(.light)
            .foregroundColor(.white)
    }
}

struct Banner: ViewModifier {
    @Binding public var data: BannerData
    @Binding public var show: Bool

    func body(content: Content) -> some View {
        ZStack {
            if show {
                VStack {
                    HStack {
                        HStack(alignment: .center, spacing: BannerConstants.innerPadding.rawValue) {
                            if data.icon != nil {
                                BannerIcon(name: data.icon!)
                            }
                            BannerDescription(description: data.message)
                        }
                        .padding(BannerConstants.innerPadding.rawValue)
                    }
                    .background(data.level.color)
                    .cornerRadius(BannerConstants.cornerRadius.rawValue)
                    .padding()

                    Spacer()
                }
                .animation(.ripple())
                .transition(.move(edge: .top))
                .onTapGesture {
                    self.show = false
                }
                .onAppear {
                    if let duration = self.data.duration {
                        guard duration > 0 else { return }

                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(duration)) {
                            withAnimation {
                                self.show = false
                            }
                        }
                    }
                }
            }

            content
        }
    }
}

// MARK: - View Extension
extension View {
    func banner(data: Binding<BannerData>, show: Binding<Bool>) -> some View {
        self.modifier(Banner(data: data, show: show))
    }
}

// MARK: - Custom animation
extension Animation {
    static func ripple() -> Animation {
        Animation.spring(dampingFraction: 0.8)
            .speed(2)
    }
}
