class UkRegion < ActiveRecord::Base

  belongs_to :country, :class_name => 'UkCountry'
  has_many :constituencies, :class_name => 'Uk2010Constituencies'

end
