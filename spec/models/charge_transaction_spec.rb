require 'rails_helper'
require_relative 'shared/validate_reference_transaction_spec'

RSpec.describe ChargeTransaction, type: :model do
  subject { build(:charge_transaction) }

  it { should belong_to(:merchant) }
  it { should have_one(:payment).dependent(:destroy).required }

  it_behaves_like 'validate_reference_transaction'
end
