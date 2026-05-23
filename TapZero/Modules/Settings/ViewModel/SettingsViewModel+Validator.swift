//
//  SettingsViewModel+Validator.swift
//  Created by __Username__ on __Date__
//

import Combine

// MARK: - Validator
extension SettingsViewModel {

    // NOTE: Validation observer aktif edildiğinde ana ViewModel dosyasına
    // `import Combine` ve `var cancellables = Set<AnyCancellable>()` ekleyin.
    func enableValidationObserver() {
        // $somePublishedProperty
        //     .removeDuplicates()
        //     .dropFirst()
        //     .debounce(for: .seconds(0.2), scheduler: DispatchQueue.main)
        //     .sink { [weak self] newValue in
        //         self?.validateField(value: newValue)
        //     }
        //     .store(in: &cancellables)
    }

    func disableValidationObserver() {
        // cancellables.removeAll()
    }

    @discardableResult
    func validate() -> Bool {
        var result = true
        // result = validateField(value: someValue) && result
        return result
    }
}
