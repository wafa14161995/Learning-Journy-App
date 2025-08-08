//
//  CurrentLearningDay.swift
//  Learning Journy App
//
//  Created by Wafa Awad  on 08/08/2025.
//

import SwiftUI

struct CurrentLearningDay: View {
    @StateObject private var vm = ViewModel()
     let daysOfWeek = ViewModel.capitalizedFirstThreeLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack {
            HStack {
                Text(vm.getFormattedDate(vm.date))
                    .foregroundColor(.gray.opacity(0.4))
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }

            HStack {
                Text(vm.learningGoal)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                NavigationLink(destination: UpdateLearningGoal(vm: vm).navigationBarBackButtonHidden(true)) {
                    Circle()
                        .fill(Color.darkGray.opacity(0.6))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text("🔥")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        )
                }
                
                 

                
                
            }
            .padding(.horizontal)
            .padding(.bottom, 10)

            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 390, height: 240)
                        .cornerRadius(9)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )

                    VStack {
                        HStack(spacing: 150) {
                            HStack {
                                Text(vm.formattedDate(vm.date))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            HStack(spacing: 20) {
                                Button(action: { vm.changeWeek(by: -1) }) {
                                    Image(systemName: "chevron.backward")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.orange)
                                }
                                Button(action: { vm.changeWeek(by: 1) }) {
                                    Image(systemName: "chevron.forward")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.orange)
                                }
                            }
                        }

                        HStack {
                            LazyVGrid(columns: Array(columns.prefix(7)), content: {
                                ForEach(0..<7, id: \.self) { index in
                                    let day = vm.getDateForDay(index) // Using ViewModel's date method
                                    let isToday = Calendar.current.isDateInToday(day)
                                    let status = vm.dateStatuses[day] ?? "none"
                                    let isLearned = status == "learned"
                                    let isFrozen = status == "frozen"

                                    VStack(spacing: 14) {
                                        Text(daysOfWeek[index])
                                            .font(.system(size: 12))
                                            .bold()
                                            .foregroundColor(isToday ? Color.white : Color.gray.opacity(0.4))

                                        Text(day.formatted(.dateTime.day()))
                                            .font(.system(size: 19))
                                            .foregroundColor(isToday ? Color.orange : Color.white)
                                            .bold()
                                            .background(
                                                Circle()
                                                    .fill(isLearned ? Color.learned: isFrozen ? Color.blue.opacity(0.2) : Color.clear)
                                                    .frame(width: 35, height: 35)
                                            )
                                    }
                                }
                            })
                        }

                        Divider()
                            .background(Color.gray)
                            .frame(width: 390)
                            .padding(.vertical, 10)

                        HStack {
                            VStack {
                                Text("\(vm.streakCount)🔥")
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text("Day streak")
                                    .font(.subheadline)
                                    .foregroundColor(.gray.opacity(0.4))
                            }
                            Divider()
                                .background(Color.gray)
                                .frame(height: 60)
                                .padding(.horizontal, 50)
                            VStack {
                                Text("\(vm.freezeCount)🧊")
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text("Day freezed")
                                    .font(.subheadline)
                                    .foregroundColor(.gray.opacity(0.4))
                            }
                        }
                    }
                }
            }
            .onAppear(perform: vm.updateCalendarDays)

            Button(action: vm.toggleLogDay) {
                Circle()
                    .fill(vm.dayFrozen ? Color.darkBlue : (vm.dayLogged ? Color.learned : Color.orangeL))
                    .frame(width: 300, height: 300)
                    .overlay(
                        Text(vm.dayFrozen ? "Day Frozen" : (vm.dayLogged ? "Learned Today" : "Log today as Learned"))
                            .foregroundColor(vm.dayFrozen ? .blue : (vm.dayLogged ? .orange : .black)) // Change font color based on status
                            .font(.largeTitle)
                            .bold()
                    )
            }
            .disabled(vm.dayFrozen)

            Button(action: vm.toggleFreezeDay) {
                RoundedRectangle(cornerRadius: 10)
                    .fill((vm.dayLogged || vm.dayFrozen) ? Color.darkGray : Color.babyBlue) // Gray background if day is logged or frozen
                    .frame(width: 150, height: 50)
                    .overlay(
                        Text("Freeze day")
                            .foregroundColor((vm.dayLogged || vm.dayFrozen) ? .freezeFont : .blue) // Gray text if day is logged or frozen
                            .font(.headline)
                    )
            }
            .disabled(vm.dayLogged || vm.dayFrozen)
    

            Text("\(vm.freezeCount) out of \(vm.maxFreezesPerMonth) freezes used")
                .font(.footnote)
                .foregroundColor(.gray.opacity(0.6))
       

            Spacer()
        }
       
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct LogdayPage_Previews: PreviewProvider {
    static var previews: some View {
        CurrentLearningDay()
    }
}
