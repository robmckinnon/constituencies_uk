begin
  puts `cd #{RAILS_ROOT}; ./script/generate migration create_constituencies_uk_tables`
rescue Exception => e
  puts e.to_s
end

migration_file = `ls #{RAILS_ROOT}/db/migrate/*create_constituencies_uk_tables.rb`
if migration_file && migration_file[/[^\d](\d+)_create_constituencies_uk_tables.rb/]
  version = $1
else
  version = nil
end

begin
  puts `cd #{RAILS_ROOT}; ./script/destroy migration create_constituencies_uk_tables`
rescue Exception => e
  puts e.to_s
end

migration = %Q%
class CreateConstituenciesUkTables < ActiveRecord::Migration

  # Consituency examples:
  # - Constituency: Aldershot
  # - Region: South East England
  # - Country: England
  # 
  # - Constituency: Aberavon
  # - Region: Wales
  # - Country: Wales

  def self.up
    create_table :uk_countries do |t|
      t.string :name
      t.string :wikipedia_uri
    end
      
    create_table :uk_regions do |t|
      t.string :name
      t.string :wikipedia_uri
      t.integer :uk_country_id
    end

    create_table :uk_2010_constituencies do |t|
      t.string :name
      t.string :alternate_name
      t.string :wikipedia_uri
      t.integer :uk_country_id
      t.integer :uk_region_id
    end
    
    add_index :uk_regions, :uk_country_id
    add_index :uk_2010_constituencies, :uk_country_id
    add_index :uk_2010_constituencies, :uk_region_id
    
  end

  def self.down
    drop_table :uk_countries
    drop_table :uk_regions
    drop_table :uk_2010_constituencies
  end
end
%

puts "writing migration"
migration_file = "#{RAILS_ROOT}/db/migrate/#{version}_create_constituencies_uk_tables.rb"
File.open(migration_file, 'w') {|file| file.write(migration)}

puts "running: #{migration_file}"
puts `cd #{RAILS_ROOT}; rake db:migrate --trace`

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

file = File.expand_path(File.dirname(__FILE__) + "/data/constituencies_uk_2010.tsv")
puts "loading data: #{file}"
data = IO.read(file)
load_constituencies data
