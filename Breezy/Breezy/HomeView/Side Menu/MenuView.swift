//
//  MenuView.swift
//  Breezy
//
//  Created by Matthew Schuiteman on 10/19/20.
//

import SwiftUI

struct MenuView : View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @FetchRequest( sortDescriptors: [NSSortDescriptor(keyPath: \Balance.amount, ascending: false)])
    
    private var balanceAmount: FetchedResults<Balance>
      
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State private var show = true
      
      var body: some View{
          
          HStack(spacing: 0){
              
              VStack(alignment: .leading){
                  
                  Image("logo")
                      .resizable()
                      .frame(width: 60, height: 60)
                      .clipShape(Circle())
                  
                  HStack(alignment: .top, spacing: 12) {
                      
                      VStack(alignment: .leading, spacing: 12) {
                        
                        ForEach(balanceAmount) {balance in
                            
                            Text("\( (balance.amount).floatToCurrency() ) in your Breezy")
                                  .font(.title3)
                                  .fontWeight(.bold)
                                  .foregroundColor(.black)
                            
                        }
                          
                          // Follow Counts...
                          
                          Divider()
                              .padding(.top,10)
                      }
                      
                      Spacer(minLength: 0)
                      
                      Button(action: {
                          
                          withAnimation{
                              
                              show.toggle()
                          }
                          
                      }) {
                          
                          Image(systemName: show ? "chevron.down" : "chevron.up")
                              .foregroundColor(Color("twitter"))
                      }
                  }
                  
                  // Different Views When up or down buttons pressed....
                  
                  VStack(alignment: .leading){
                      
                      // Menu Buttons....
                    
                 
                      
                        ForEach(menuButtons,id: \.self){menu in
                              
                              Button(action: {
                                  // switch your actions or work based on title....
                                
                                if menu == "Home" {
                                    viewRouter.currentPage = "breezyView"
                                }
                                else if menu == "Goals" {
                                    viewRouter.currentPage = "goalsView"
                                }
                            
                                
                                else if menu == "Stats" {
                                    viewRouter.currentPage = "statsView"
                                }
                              }) {
                                  
                                  MenuButton(title: menu)
                              }
                          }
                    
                  }
                    
                  
                      
                      Divider()
                          .padding(.top)
                      
                      Button(action: {
                          // switch your actions or work based on title....
                      }) {
                          
                          MenuButton(title: "Twitter Ads")
                      }
                      
                      Divider()
                      
                      Button(action: {}) {
                          
                          Text("Settings and privacy")
                              .foregroundColor(.black)
                      }
                      .padding(.top)
                      
                      Button(action: {}) {
                          
                          Text("Help centre")
                              .foregroundColor(.black)
                      }
                      .padding(.top,20)
                      
                      Spacer(minLength: 0)
                      
                      Divider()
                          .padding(.bottom)
                      
//                      HStack{
//
//                          Button(action: {}) {
//
//                              Image("help")
//                                  .renderingMode(.template)
//                                  .resizable()
//                                  .frame(width: 26, height: 26)
//                                  .foregroundColor(Color("twitter"))
//                          }
//
//                          Spacer(minLength: 0)
//
//                          Button(action: {}) {
//
//                              Image("barcode")
//                                  .renderingMode(.template)
//                                  .resizable()
//                                  .frame(width: 26, height: 26)
//                                  .foregroundColor(Color("twitter"))
//                          }
//                      }
                  }
                  // hiding this view when down arrow pressed...
                  .opacity(show ? 1 : 0)
                  .frame(height: show ? nil : 0)
                  
                  // Alternative View For Up Arrow...
                  
                  VStack(alignment: .leading){
                      
                      Button(action: {}) {
                          
                          Text("Create a new account")
                              .foregroundColor(Color("twitter"))
                      }
                      .padding(.bottom)
                      
                      Button(action: {}) {
                          
                          Text("Add an existing account")
                              .foregroundColor(Color("twitter"))
                      }
                      
                      Spacer(minLength: 0)
                  }
                  .opacity(show ? 0 : 1)
                  .frame(height: show ? 0 : nil)
                  
                  
              }
              .padding(.horizontal,20)
              // since vertical edges are ignored....
              .padding(.top,edges!.top == 0 ? 15 : edges?.top)
              .padding(.bottom,edges!.bottom == 0 ? 15 : edges?.bottom)
              // default width...
              .frame(width: UIScreen.main.bounds.width - 90)
              .background(Color.white)
              .ignoresSafeArea(.all, edges: .vertical)
              
              Spacer(minLength: 0)
          }
      }

struct FollowView : View {
      
      var count : Int
      var title : String
      
      var body: some View{
      
          HStack{
              
              Text("(count)")
                  .fontWeight(.bold)
                  .foregroundColor(.black)
              
              Text(title)
                  .foregroundColor(.gray)
          }
      }
  }
    
var menuButtons = ["Home", "Plan", "Goals", "Stats"]
  
  struct MenuButton : View {
      
      var title : String
      
      var body: some View{
          
          HStack(spacing: 15){
              
              // both title and image names are same....
              Image(title)
                  .resizable()
                  .renderingMode(.template)
                  .frame(width: 24, height: 24)
                  .foregroundColor(.gray)
              
              Text(title)
                  .foregroundColor(.black)
              
              Spacer(minLength: 0)
          }
          .padding(.vertical,12)
      }
    
  }

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
