//
//  View++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


import SwiftUI

// MARK: - Is Active Modifier
extension View {
    @ViewBuilder func isActive(_ value: Bool) -> some View { ZStack {
        if value { self }
    }}
    @ViewBuilder func isActiveStackElement(_ value: Bool) -> some View {
        if value { self }
    }
}

// MARK: - Erased Modifier
extension View {
    func erased() -> AnyView { .init(self) }
}

// MARK: - Returning Self
extension View {
    func setAndReturnSelf(_ body: (inout Self) -> Void) -> Self {
        var result = self
        body(&result)
        return result
    }
}
