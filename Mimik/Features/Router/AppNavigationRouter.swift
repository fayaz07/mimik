//
//  NavigationViewModel.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/06/25.
//
import Foundation

class AppNavigationRouter: ObservableObject {
    @Published var selectedSidebarRoute: SidebarRoutes? = .dashboard
}
