//
//  TapZeroApp.swift
//  TapZero
//
//  Created by Burak Gül on 9.03.2026.
//

import DependencyContainer
import DynamicColor
import SwiftfulRouting
import SwiftUI

@main
struct AppEntryPoint {
    static func main() {
        TapZeroApp.main()
    }
}

struct TapZeroApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}

private struct AppRootView: View {
    @StateObject private var languageManager: LanguageManager
    @StateObject private var networkMonitor: NetworkMonitorManager

    init() {
        // swiftlint:disable force_unwrapping
        let language = Dependencies.shared.container.resolve(LanguageManager.self)!
        self._languageManager = StateObject(wrappedValue: language)
        let monitor = Dependencies.shared.container.resolve(NetworkMonitorManager.self)!
        self._networkMonitor = StateObject(wrappedValue: monitor)
        // swiftlint:enable force_unwrapping
    }

    var body: some View {
        AppBuilder.build()
        .environment(\.locale, languageManager.locale)
        .onOpenURL { url in
            // swiftlint:disable:next force_unwrapping
            Dependencies.shared.container.resolve(DeepLinkManager.self)!.handleURL(url)
        }
        .task {
            ThemeStore.shared.applyInterfaceStyle()
        }
        .task {
            networkMonitor.startMonitoring()
        }
        .blur(radius: networkMonitor.isConnected ? 0 : 20)
        .allowsHitTesting(networkMonitor.isConnected)
        .brightness(networkMonitor.isConnected ? 0 : 0.35)
        .animation(.easeInOut(duration: 0.4), value: networkMonitor.isConnected)
        .sheet(isPresented: Binding(
            get: { !networkMonitor.isConnected },
            set: { _ in }
        )) {
            RouterView(id: "networkStatus", addModuleSupport: true) { router in
                NetworkStatusBuilder.build(router: router)
            }
            .presentationDetents([.fraction(0.55)])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(24)
            .presentationBackground(
                LinearGradient(
                    colors: [
                        TapZeroDesign.NetworkStatus.sheetGradientStart,
                        TapZeroDesign.NetworkStatus.sheetGradientEnd
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .interactiveDismissDisabled(true)
        }
    }
}
