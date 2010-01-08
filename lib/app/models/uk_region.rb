class UkRegion < ActiveRecord::Base

  belongs_to :country, :class_name => 'UkCountry', :foreign_key => 'uk_country_id'
  has_many :constituencies, :class_name => 'Uk2010Constituency'

end
