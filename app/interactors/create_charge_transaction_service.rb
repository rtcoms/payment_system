class CreateChargeTransactionService
  include Interactor::Organizer

  organize ValidateTransactionParams, ValidateMerchant, CreateTransaction
end