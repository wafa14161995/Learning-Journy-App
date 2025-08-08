//
//  ContentView.swift
//  Learning Journy App
//
//  Created by Wafa Awad  on 08/08/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Circle()
                    .fill(Color.darkGray.opacity(0.6))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Text("🔥")
                            .font(.system(size: 50))
                    )
                
            
                Group {
                    Text("Hello Learner!")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("This app will help you learn everyday")
                        .font(.system(size: 16))
                        .foregroundColor(Color.darkGray)
                } .frame(maxWidth: .infinity, alignment: .leading)
                
              
                Group {
                    Text("I want to learn")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    TextField("Swift", text: $vm.learningGoal)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)
                        .foregroundColor(.darkGray)
                        .overlay(Divider().background(Color.gray), alignment: .bottom)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
         
                Group {
                    Text("I want to learn it in a")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack {
                        ForEach(["Week", "Month", "Year"], id: \.self) { period in
                            Button(action: { vm.duration = period }) {
                                Text(period)
                                    .frame(width: 80, height: 40)
                                    .background(vm.duration == period ? Color.orange : Color.gray.opacity(0.3))
                                    .foregroundColor(vm.duration == period ? .black : .orange)
                                    .cornerRadius(10)
                            }
                        }
                }
                } .frame(maxWidth: .infinity, alignment: .leading)
             
                
             
                NavigationLink(destination: CurrentLearningDay().navigationBarBackButtonHidden(true)) {
                    Text("Start ")
                        .fontWeight(.bold)
                        .frame(maxWidth: 150, minHeight: 55)
                        .background(Color.orange)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct GreetPage_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
