# == Schema Information
#
# Table name: users
#
# @!attribute id
#   @return []
# @!attribute email
#   @return [String]
# @!attribute encrypted_password
#   @return [String]
# @!attribute remember_created_at
#   @return [Time]
# @!attribute created_at
#   @return [Time]
# @!attribute updated_at
#   @return [Time]
# @!attribute status
#   @return []
# @!attribute name
#   @return [String]
# @!attribute description
#   @return [String]
# @!attribute total_transaction_sum
#   @return []
# @!attribute user_type
#   @return [String]
#
class Admin < User
end
