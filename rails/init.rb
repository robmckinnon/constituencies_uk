require 'constituencies_uk'

def add_constituency attributes, values
  constituency = nil
  attributes.each_with_index do |attribute, index|
    value = values[index]
    case attribute
      when 'name'
        puts "loading: #{value}"
        constituency = Uk2010Constituency.find_or_create_by_name(value)
      when 'region'
        region = UkRegion.find_or_create_by_name(value)
        constituency.uk_region_id = region.id
      when 'country'
        country = UkCountry.find_or_create_by_name(value)
        constituency.uk_country_id = country.id
      when 'alternate_name'
        constituency.alternate_name = value
      when 'wikipedia_uri'
        constituency.wikipedia_uri = value
    end
  end
  constituency.save!
end

def load_constituencies data
  attributes = []
  first_line = true
  data.each_line do |line|
    if first_line
      attributes = line.split("\t")
      first_line = false
    else
      add_constituency attributes, line.split("\t")
    end
  end
end

if UkCountry.count == 0
  file = File.join(File.dirname(__FILE__), "..", "data", "constituencies_uk_2010.tsv")
  puts "loading data: #{file}"
  data = IO.read(file)
  load_constituencies data
end
