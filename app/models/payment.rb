class Payment < ActiveRecord::Base
  belongs_to :subscription
end
