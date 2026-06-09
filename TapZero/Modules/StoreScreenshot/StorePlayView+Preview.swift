//
//  StorePlayView+Preview.swift
//  TapZero
//

import SwiftfulRouting
import SwiftUI

// MARK: - Play Screen Showcase

private struct StorePlayShowcase: View {
    let localeData: StoreLocaleData

    var body: some View {
        RouterView(id: "store-play", addModuleSupport: true) { router in
            PlayBuilder.build(router: router)
        }
    }
}

// MARK: - Previews (10 Locales)

#Preview("Store Play — EN") { StoreLocalePreview(storeLocales[0]) { StorePlayShowcase(localeData: storeLocales[0]) } }
#Preview("Store Play — TR") { StoreLocalePreview(storeLocales[1]) { StorePlayShowcase(localeData: storeLocales[1]) } }
#Preview("Store Play — AR") { StoreLocalePreview(storeLocales[2]) { StorePlayShowcase(localeData: storeLocales[2]) } }
#Preview("Store Play — DE") { StoreLocalePreview(storeLocales[3]) { StorePlayShowcase(localeData: storeLocales[3]) } }
#Preview("Store Play — ES") { StoreLocalePreview(storeLocales[4]) { StorePlayShowcase(localeData: storeLocales[4]) } }
#Preview("Store Play — FR") { StoreLocalePreview(storeLocales[5]) { StorePlayShowcase(localeData: storeLocales[5]) } }
#Preview("Store Play — IT") { StoreLocalePreview(storeLocales[6]) { StorePlayShowcase(localeData: storeLocales[6]) } }
#Preview("Store Play — JA") { StoreLocalePreview(storeLocales[7]) { StorePlayShowcase(localeData: storeLocales[7]) } }
#Preview("Store Play — KO") { StoreLocalePreview(storeLocales[8]) { StorePlayShowcase(localeData: storeLocales[8]) } }
#Preview("Store Play — PT-BR") {
    StoreLocalePreview(storeLocales[9]) { StorePlayShowcase(localeData: storeLocales[9]) }
}
