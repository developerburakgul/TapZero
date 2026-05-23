//
//  UserAuthInfo+Firebase.swift
//  TapZero
//

import FirebaseAuth

extension UserAuthInfo {
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.isAnonymous = user.isAnonymous
        self.creationDate = user.metadata.creationDate
        self.lastSignInDate = user.metadata.lastSignInDate
        self.providerIds = user.providerData.map(\.providerID)
    }
}
