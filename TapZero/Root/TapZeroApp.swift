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
    @State private var isNetworkSheetPresented: Bool = false

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
        .brightness(networkMonitor.isConnected ? 0 : 0.35)
        .animation(.easeInOut(duration: 0.4), value: networkMonitor.isConnected)
        .onChange(of: networkMonitor.isConnected) { _, connected in
            handleConnectionChange(connected)
        }
    }

    private func handleConnectionChange(_ connected: Bool) {
        guard let appRouter = Dependencies.shared.rootRouter else { return }
        if !connected, !isNetworkSheetPresented {
            isNetworkSheetPresented = true
            let gradient = LinearGradient(
                colors: [
                    TapZeroDesign.NetworkStatus.sheetGradientStart,
                    TapZeroDesign.NetworkStatus.sheetGradientEnd
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            let config = ResizableSheetConfig(
                detents: [.fraction(0.55)],
                dragIndicator: .hidden,
                background: .custom(gradient),
                cornerRadius: 24
            )
            appRouter.showScreen(
                .sheetConfig(config: config),
                id: "networkStatus"
            ) { router in
                NetworkStatusBuilder.build(router: router)
                    .interactiveDismissDisabled(true)
            }
        } else if connected, isNetworkSheetPresented {
            appRouter.dismissScreen()
            isNetworkSheetPresented = false
        }
    }
}
