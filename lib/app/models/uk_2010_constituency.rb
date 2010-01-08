class Uk2010Constituency < ActiveRecord::Base

  belongs_to :uk_country
  belongs_to :uk_region

end
