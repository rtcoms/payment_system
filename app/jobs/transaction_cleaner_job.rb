class TransactionCleanerJob < ApplicationJob
  queue_as :default

  def perform
    GoodJob.logger.info "CLEANING TRANSACTION: #{Time.now}"
    Transaction.where('created_at <= ?', 1.hour.ago).discard_all
  end
end
