# == Schema Information
#
# Table name: users
#
#  id                    :bigint           not null, primary key
#  email                 :string           default(""), not null
#  encrypted_password    :string           default(""), not null
#  remember_created_at   :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  status                :enum             default("active"), not null
#  name                  :string           not null
#  description           :text
#  total_transaction_sum :decimal(, )      default(0.0), not null
#  user_type             :string           default("Merchant"), not null
#
class Admin < User
end
