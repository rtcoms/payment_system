class CreateAuthorizeTransactionService
  include Interactor::Organizer

  organize ValidateAuthorizeTransactionParams, ValidateMerchant, CreateTransaction
end