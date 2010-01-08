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

    create_table :uk2010_constituencies do |t|
      t.string :name
      t.string :alternate_name
      t.string :wikipedia_uri
      t.integer :uk_country_id
      t.integer :uk_region_id
    end
    
    add_index :uk_regions, :uk_country_id
    add_index :uk2010_constituencies, :uk_country_id
    add_index :uk2010_constituencies, :uk_region_id
    
  end

  def self.down
    drop_table :uk_countries
    drop_table :uk_regions
    drop_table :uk2010_constituencies
  end
end
%

puts "writing migration"
migration_file = "#{RAILS_ROOT}/db/migrate/#{version}_create_constituencies_uk_tables.rb"
File.open(migration_file, 'w') {|file| file.write(migration)}

puts "running: #{migration_file}"
puts `cd #{RAILS_ROOT}; rake db:migrate --trace`

