//
//  CaseIterable++.swift of MijickCamera
//
//  Created by Tomasz Kurylik. Sending ❤️ from Kraków!
//    - Mail: tomasz.kurylik@mijick.com
//    - GitHub: https://github.com/FulcrumOne
//    - Medium: https://medium.com/@mijick
//
//  Copyright ©2024 Mijick. All rights reserved.


extension CaseIterable where Self: Equatable {
    func next() -> Self { let allCases = Self.allCases
        let index = allCases.firstIndex(of: self)!
        let nextIndex = allCases.index(after: index)
        return allCases[nextIndex == allCases.endIndex ? allCases.startIndex : nextIndex]
    }
}
