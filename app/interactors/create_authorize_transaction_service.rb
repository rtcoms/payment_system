class CreateAuthorizeTransactionService
  include Interactor::Organizer

  organize ValidateAuthorizeTransactionParams
end