//
//  EntriesViewModel.swift
//  AppFinances
//
//  Created by Edgar on 17/07/25.
//

import Foundation
import Combine

class AFEntriesViewModel {
    
    private let entriesService: EntryServiceProtocol
    private let budgetsService: BudgetsServiceProtocol
    
    private(set) var monthlyResume: AFMonthlyResume?
    
    weak var delegate: AFEntriesViewModelDelegate?
    
    init(entriesService: EntryServiceProtocol, budgetsService: BudgetsServiceProtocol) {
        self.entriesService = entriesService
        self.budgetsService = budgetsService
    }
    
    func load(by monthYear: AFMonthYear, withLoading: Bool = true) {
        
        Task { [weak self] in
            guard let self else {
                return
            }
            
            do {
                
                if withLoading {
                    delegate?.viewModel(isLoading: true)
                }
                
                let (budget, entries) = try await (getBudget(by: monthYear),getEntries(by: monthYear))
                
                let used: Double = entries.filter { $0.type == .expense }.reduce(0) { partialResult, entry in
                    partialResult + entry.value
                }
                
                monthlyResume = AFMonthlyResume(
                    entries: entries,
                    budget: budget,
                    used: used
                )
   
                delegate?.viewModel(isLoading: false)
   
            } catch {
                delegate?.viewModel(errorMessage: "Não foi possível carregar as informações.")
            }
        }
    }
    
    private func getBudget(by monthYear: AFMonthYear) async throws(any Error) -> AFBudget? {
        return try await budgetsService.getBudget(by: monthYear)
    }
    
    private func getEntries(by monthYear: AFMonthYear) async throws(any Error) -> [AFEntry] {
        return try await entriesService.getEntries(by: monthYear)
    }
    
    func deleteEntry(id: String, index: Int) {
        monthlyResume?.entries.remove(at: index)
        
        Task {
            try await entriesService.delete(id: id)
        }
    }
}


protocol AFEntriesViewModelDelegate: AnyObject {

    func viewModel(isLoading: Bool)
    
    func viewModel(errorMessage: String)
    
}
