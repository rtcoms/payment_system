require 'rails_helper'
require_relative 'shared/validate_reference_transaction_spec'

RSpec.describe ReversalTransaction, type: :model do
  subject { build(:reversal_transaction) }

  it { should belong_to(:merchant) }
  it { should have_one(:payment).dependent(:destroy) }
  
  it_behaves_like 'validate_reference_transaction'
end
