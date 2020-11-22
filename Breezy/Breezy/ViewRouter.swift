//
//  ViewRouter.swift
//  Breezy
//
//  Created by Matthew Schuiteman on 10/18/20.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    
    let willChange = PassthroughSubject<ViewRouter,Never>()
    
    @Published var currentPage: String {
        didSet {
            withAnimation() {
                willChange.send(self)
            }
        }
    }
    
    init() {
        
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "onBoardingView"
        }
        
        else {
            currentPage = "breezyView"
        }
    }
}
