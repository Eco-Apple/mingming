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
            VStack {
                if !viewModel.tags.isEmpty {
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .center, spacing: 4.0) {
                                FilterButton("All", isActive: viewModel.selectedTagNames.contains("All")) {
                                    viewModel.selectTagName("All")
                                }
                                .padding(.leading, (UIScreen.main.bounds.width * 0.5) + 6)
                                .id("all")
                                
                                ForEach(viewModel.tags) { tag in
                                    FilterButton(tag.name, isActive: viewModel.selectedTagNames.contains(tag.name)) {
                                        viewModel.selectTagName(tag.name)
                                    }
                                }
                            }
                            .padding(0.5)
                        }
                        .defaultScrollAnchor(.trailing)
                        .padding(.top, 12)
                        .padding(.horizontal, 12)
                        .onAppear {
                            proxy.scrollTo("all")
                        }
                    }
                }
                
                List($viewModel.habits, editActions: .move) { habit in
                    HabitTile(habit: habit.wrappedValue, startMonth: 2, onDelete: viewModel.onDelete)
                        .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                        .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .onChange(of: viewModel.habits) { old, new in
                    var counter = 0
                    for habit in new {
                        habit.listOrder = counter
                        counter += 1
                    }
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 4.0) {
                    ForEach(viewModel.years, id: \.self) { year in
                        FilterButton(year, isActive: viewModel.selectedYear == year) {
                            viewModel.selectYear(year)
                        }
                    }
                    FilterButton("All", isActive: viewModel.selectedYear == "All") {
                        viewModel.selectedYear = "All"
                    }
                }
                .padding(0.5)
            }
            .padding(.leading, 12)
            .padding(.bottom, 10)
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
        .customAlert(isPresented: $viewModel.isReminderPresented, isOverlayShow: .constant(false)) {
            ForEach(viewModel.habitsToRemind) { habit in
                Reminder(habit: habit) {
                    viewModel.onRemoveReminder(habit: habit)
                }
            }
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
                    withAnimation(.easeIn(duration: 1).delay(0.5)) {
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
                Button {
                    isCheckShown = false
                    Task {
                        await home.onAdd()
                    }
                } label: {
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
