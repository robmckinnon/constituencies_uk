namespace :constituencies_uk do

  def add_constituency attributes, values
    constituency = nil
    region = nil

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
          unless region.uk_country_id
            region.uk_country_id = country.id
            region.save!
          end
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
      values = line.strip.split("\t")
      if first_line
        attributes = values
        first_line = false
      else
        add_constituency attributes, values
      end
    end
  end

  desc "loads constituency data"
  task :load_data => [:environment] do
    if UkCountry.count == 0
      file = File.join(File.dirname(__FILE__), "..", "data", "constituencies_uk_2010.tsv")
      puts "loading data: #{file}"
      data = IO.read(file)
      load_constituencies data
    end
  end

end
