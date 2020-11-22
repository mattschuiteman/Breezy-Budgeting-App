//
//  BreezyStatsView.swift
//  Breezy
//
//  Created by Matthew Schuiteman on 10/25/20.
//

import SwiftUI

struct BreezyStatsView : View {
      
      // for future use...
      @State var width = UIScreen.main.bounds.width - 90
      // to hide view...
      @State var x = -UIScreen.main.bounds.width + 90
      
      var body: some View {
          
          ZStack(alignment: Alignment(horizontal: .leading, vertical: .center)) {
              
            StatsView(x: $x)
              
              MenuView()
                  .shadow(color: Color.black.opacity(x != 0 ? 0.1 : 0), radius: 5, x: 5, y: 0)
                  .offset(x: x)
                  .background(Color.black.opacity(x == 0 ? 0.5 : 0).ignoresSafeArea(.all, edges: .vertical).onTapGesture {
                      
                      // hiding the view when back is pressed...
                      
                      withAnimation{
                          
                          x = -width
                      }
                  })
          }
          // adding gesture or drag feature...
          .gesture(DragGesture().onChanged({ (value) in
              
              withAnimation{
                  
                  if value.translation.width > 0{
                      
                      // disabling over drag...
                      
                      if x < 0{
                          
                          x = -width + value.translation.width
                      }
                  }
                  else{
  
                      if x != -width{
                      
                          x = value.translation.width
                      }
                  }
              }
              
          }).onEnded({ (value) in
              
              withAnimation{
                  
                  // checking if half the value of menu is dragged means setting x to 0...
                  
                  if -x < width / 2{
                      
                      x = 0
                  }
                  else{
                      
                      x = -width
                  }
              }
          }))
      }
  }

struct BreezyStatsView_Previews: PreviewProvider {
    static var previews: some View {
        BreezyStatsView()
    }
}
