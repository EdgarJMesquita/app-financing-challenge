//
//  SearchState.swift
//  AppFinances
//
//  Created by Edgar on 14/07/25.
//


enum SearchState {
    case loading
    case empty
    case result(budget: AFBudget)
    case error(error: Error)
}
