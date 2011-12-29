class Address < ActiveRecord::Base
  def empty?
    attributes.slice(%w(street zip city)).values.compact.empty?
  end
end
