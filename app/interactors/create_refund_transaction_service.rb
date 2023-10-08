class CreateRefundTransactionService
  include Interactor::Organizer

  organize ValidateTransactionParams, ValidateMerchant, CreateTransaction, RecalculateMerchantAmount
end