class Uk2010Constituency < ActiveRecord::Base

  belongs_to :country, :class_name => 'UkCountry'
  belongs_to :region, :class_name => 'UkRegion'

end
