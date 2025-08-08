//
//  UpdateGoal.swift
//  Learning Journy App
//
//  Created by Wafa Awad  on 08/08/2025.
//

import SwiftUI

struct UpdateLearningGoal: View {
    @ObservedObject var vm: ViewModel  // Use the shared ViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
             
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left") // Arrow for back button
                            Text("Back")
                                .font(.title3)
                        }
                        .foregroundColor(.orangeL)
                    }
                    
                    Spacer()
                    
                    Text("Learning goal")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                      
                      
                        vm.refreshAll()

                            dismiss()
                    }) {
                        Text("Update")
                            .font(.title3)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    TextField("Swift", text: $vm.learningGoal)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(8)
                        .foregroundColor(.darkgray)
                        .overlay(Divider().background(Color.gray), alignment: .bottom)
                }
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("I want to learn it in a")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 10)
                    
                    HStack(spacing: 10) {
                        ForEach(["Week", "Month", "Year"], id: \.self) { period in
                            Button(action: {
                                vm.duration = period
                            }) {
                                Text(period)
                                    .frame(width: 70, height: 35)
                                    .background(vm.duration == period ? Color.orange : Color.gray.opacity(0.3))
                                    .foregroundColor(vm.duration == period ? .black : .orange)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

// Preview
struct UpdatePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UpdateLearningGoal(vm: ViewModel())
        }
    }
}
