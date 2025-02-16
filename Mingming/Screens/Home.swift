//
//  Home.swift
//  Mingming
//
//  Created by Jerico Villaraza on 2/7/25.
//

import SwiftUI

struct Home: View {
    @State private var viewModel: ViewModel
    
    init() {
        _viewModel = State(initialValue: .init(dataService: .shared))
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 4.0) {
                        FilterButton("All", isActive: true)
                            .padding(.leading, (UIScreen.main.bounds.width * 0.5) + 6)
                        
                        FilterButton("Daily Habits", isActive: false)
                        
                        FilterButton("Routine", isActive: false)
                    }
                    .padding(0.5)
                }
                .padding(.top, 12)
                
                VStack(alignment: .leading, spacing: 14) {
                    ForEach(viewModel.habits) { habit in
                        HabitTile(startMonth: 2, onDelete: viewModel.onDelete)
                    }
                }
                .padding(.horizontal, 12)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 4.0) {
                    FilterButton("2025", isActive: false)
                    FilterButton("All", isActive: true)
                }
                .padding(0.5)
            }
            .padding(.leading, 12)
        }
        .customToolbar {
            HStack(alignment: .bottom, spacing: .zero) {
                Image(.toolbarLogo)
                
                Text("Mingming")
                    .font(.custom("ClickerScript-Regular", size: 22))
                    .frame(height: 18)
                    .padding(.leading, 5)
                    .padding(.bottom, 3)
                
                Spacer()
                
                HomeAddButton(home: viewModel)
            }
            .padding(.horizontal, 12)
        }
        .onAppear(perform: viewModel.onAppear)
        .customAlert(isPresented: $viewModel.isAddPresented, isOverlayShow: .constant(false)) {
            Add(viewModel: viewModel.add)
        }
        .customAlert(isPresented: $viewModel.isDeletePresented) {
            Delete(callback: viewModel.deleteButtonCallback)
        }
        .customAlert(isPresented: $viewModel.isReminderPresented) {
            Reminder()
        }
    }
}

private struct HomeAddButton: View {
    @State private var isCheckShown = false
    
    var home: Home.ViewModel
    
    func isAddDisabled() -> Bool {
        return home.add.tags.isEmpty || home.add.title.isEmpty || home.add.time.isEmpty
    }
    
    var body: some View {
        HStack {
            Button {
                home.isAddPresented.toggle()
                
                if home.isAddPresented {
                    home.add.reset()
                    withAnimation(.easeIn(duration: 1).delay(1)) {
                        isCheckShown = true
                    }
                } else {
                    isCheckShown = false
                }
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(home.isAddPresented ? .red : .black)
                    .font(.system(size: 20, weight: .medium))
                    .animation(.easeInOut(duration : 1).delay(0.5), value: home.isAddPresented)
            }
            .buttonStyle(PlainButtonStyle())
            .rotationEffect(Angle(degrees: home.isAddPresented ? -135 : 0))
            .animation(.easeInOut(duration: 1), value: home.isAddPresented)
            
            if home.isAddPresented {
                Button(action: home.onAdd){
                    Image(.check)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(isAddDisabled())
                .opacity(isCheckShown ? 1 : 0)
            }
        }
    }
}

#Preview {
    Home()
}
