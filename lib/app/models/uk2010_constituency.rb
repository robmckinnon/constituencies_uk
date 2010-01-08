class Uk2010Constituency < ActiveRecord::Base

  belongs_to :country, :class_name => 'UkCountry', :foreign_key => 'uk_country_id'
  belongs_to :region, :class_name => 'UkRegion', :foreign_key => 'uk_region_id'

end
