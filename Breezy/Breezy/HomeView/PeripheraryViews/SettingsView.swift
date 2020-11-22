//
//  SettingsView.swift
//  Breezy
//
//  Created by Matthew Schuiteman on 10/13/20.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section {
                    
                    Text("Change Balance")
                    
                }.navigationTitle(Text("Settings"))
            
            }
        }
    }
}
