class UkRegion < ActiveRecord::Base

  belongs_to :uk_country
  has_many :uk_2010_constituencies

end
