class CreateAuthorizeTransactionService
  include Interactor::Organizer

  organize ValidateTransactionParams,
           ValidateMerchant,
           CreateTransaction
end