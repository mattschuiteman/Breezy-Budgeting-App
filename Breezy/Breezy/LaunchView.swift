//
//  MotherView.swift
//  Breezy
//
//  Created by Matthew Schuiteman on 10/18/20.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            if viewRouter.currentPage == "onBoardingView" {
                OnBoardingView()
            }
            
            if viewRouter.currentPage == "breezyView"{
                BreezyHomeView()
            }
            
            if viewRouter.currentPage == "goalsView" {
                GoalsView()
                    .transition(.scale)
            }
            
            if viewRouter.currentPage == "statsView" {
                BreezyStatsView()
                    .transition(.scale)
            }
            
            if viewRouter.currentPage == "settingsView" {
                SettingsView()
            }
        }
    }
}
