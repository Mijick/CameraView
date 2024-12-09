//
//  CaseIterable++.swift of MijickCameraView
//
//  Created by Tomasz Kurylik
//    - Twitter: https://twitter.com/tkurylik
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//
//  Copyright ©2024 Mijick. Licensed under MIT License.


extension CaseIterable where Self: Equatable {
    func next() -> Self { let allCases = Self.allCases
        let index = allCases.firstIndex(of: self)!
        let nextIndex = allCases.index(after: index)
        return allCases[nextIndex == allCases.endIndex ? allCases.startIndex : nextIndex]
    }
}
