//
//  AddEntryViewModel.swift
//  AppFinances
//
//  Created by Edgar on 21/07/25.
//

class AddBudgetViewModel {
    private let service: BudgetsServiceProtocol
    private(set) var budgets: [AFBudget] = []
    weak var delegate: AddBudgetViewModelDelegate?
    
    init(service: BudgetsServiceProtocol) {
        self.service = service
    }
    
    func getBudgets(){
        Task { [weak self] in
            guard let self else {
                return
            }
            do {
                delegate?.viewModel(isLoadingBudgets: true)
                budgets = try await service.getBudgets()
                delegate?.viewModel(isLoadingBudgets: false)
            } catch {
                delegate?.viewModel(errorTitle: "Atenção", errorMessage: error.localizedDescription)
            }
        }
    }

    func createNewBudget(form: AddBudgetForm) {
        Task { [weak self] in
            guard let self else {
                return
            }
            do {
          
                delegate?.viewModel(isLoadingCreatingNewBudget: true)
                let newBudget = try await service.create(form: form)
                delegate?.viewModel(isLoadingCreatingNewBudget: false)
                getBudgets()
                delegate?.viewModel(newBudget: newBudget)
            } catch AFError.invalidForm {
                delegate?.viewModel(errorTitle: "Atenção", errorMessage: "Por favor verifique os campos do formulário.")
            } catch AFError.unauthorized {
                delegate?.viewModel(errorTitle: "Atenção", errorMessage: "Você não tem autorização para isto.")
            } catch {
                print(error)
                delegate?.viewModel(errorTitle: "Atenção", errorMessage: error.localizedDescription)
            }
            delegate?.viewModel(isLoadingCreatingNewBudget: false)
           
        }
    }
    
    func delete(id: String, index: Int){
        budgets.remove(at: index)
        Task { [weak self] in
            guard let self else {
                return
            }
            
            do {
                try await service.delete(id: id)
               
            } catch {
                print(error)
            }
        }
    }
}

protocol AddBudgetViewModelDelegate: AnyObject {
    func viewModel(isLoadingBudgets: Bool)
    func viewModel(errorTitle: String, errorMessage: String)
    func viewModel(isLoadingCreatingNewBudget: Bool)
    func viewModel(newBudget: AFBudget)
}
