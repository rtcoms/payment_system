class RecalculateMerchantAmount
  include Interactor

  def call
    context.merchant.recalculate_total_charges_collected
  end
end