class UkCountry < ActiveRecord::Base

  has_many :regions, :class_name => 'UkRegion'
  has_many :constituencies, :class_name => 'Uk2010Constituency'

end
