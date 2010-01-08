class UkCountry < ActiveRecord::Base

  has_many :uk_regions
  has_many :uk_2010_constituencies

end
