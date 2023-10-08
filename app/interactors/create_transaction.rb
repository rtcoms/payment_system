class CreateTransaction
  include Interactor

  def call
    context.form.save
  end
end