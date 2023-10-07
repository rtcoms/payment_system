class AuthorizeTransaction < Transaction
  has_one :payment, class_name: 'Payment', as: :monetizable, dependent: :destroy, required: true
end
