class CreateReversalTransactionService
  include Interactor::Organizer

  organize ValidateTransactionParams, ValidateMerchant, CreateTransaction, RecalculateMerchantAmount
end