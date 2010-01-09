require 'open-uri'

class Uk2010Constituency < ActiveRecord::Base

  belongs_to :country, :class_name => 'UkCountry', :foreign_key => 'uk_country_id'
  belongs_to :region, :class_name => 'UkRegion', :foreign_key => 'uk_region_id'

  if defined?(FriendlyId)
    has_friendly_id :name, :use_slug => true, :strip_diacritics => true
  end

  class << self
    def find_by_postcode postcode
      name = lookup_new_name postcode
      if name.nil? || name[/Unknown postcode, or problem with lookup/]
        nil
      else
        find_by_name(name)
      end
    end
    
    def lookup_new_name postcode
      @twfy_key ||= IO.read(RAILS_ROOT+'/config/twfy_key.txt').strip      
      postcode = URI.encode(postcode)
      twfy_uri = "http://www.theyworkforyou.com/api/getConstituency?postcode=#{postcode}&future=1&output=js&key=#{@twfy_key}"
      response = open(twfy_uri).read
      result = eval(response.gsub('":"','" => "'))
      if error = result['error']
        error
      elsif name = result['name']
        name
      else
        nil
      end
    end
  end
end
