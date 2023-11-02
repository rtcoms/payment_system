# Service to recalculate valid amount collected for a merchant
class RecalculateMerchantAmount
  include Interactor

  def call
    context.merchant.recalculate_total_charges_collected
  end
end