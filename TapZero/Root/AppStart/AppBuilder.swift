//
//  StartScreenBuilder.swift
//  TapZero
//
//  Created by Burak Gül on 9.03.2026.
//

import SwiftfulRouting
import SwiftUI

typealias Router = SwiftfulRouting.AnyRouter

@MainActor
public enum AppBuilder {
    public static func build() -> some View {
        RouterView(id: "splash", addNavigationStack: false, addModuleSupport: true) { router in
            SplashBuilder.build(router: router)
                .onAppear { Dependencies.shared.rootRouter = router }
        }
    }
}
