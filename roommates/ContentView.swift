//
//  ContentView.swift
//  roommates
//
//  Created by Elijah Matamoros on 9/26/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        HStack{
//            CardView()
//            CardView(isFaceUp : false)
//        }
//        .foregroundColor(.orange)
//        .padding()
        LoginView()
    }
}

struct CardView: View {
    var isFaceUp : Bool = true
    var body : some View {
        // is there a difference between declaring this in the zstack vs here?
        
        let base = RoundedRectangle(cornerRadius: 10)
        ZStack {
            if isFaceUp {
                base.fill(.white)
                base.strokeBorder(lineWidth: 10)
                Text("Hello").font(.largeTitle)
            }else {
                base.fill(.orange)
            }
        }
         
    }
}













#Preview {
    ContentView()
}
