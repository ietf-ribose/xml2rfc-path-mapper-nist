require_relative "create_mapping"

def read_bibxml(file)
  # hack for broken xml files with content like:
  # <author initials='Carol' surname='O'Connor' fullname='Carol O'Connor'><organization /></author>
  "<?xml version='1.0' encoding='UTF-8'?>#{
    File.readlines(file).select { |l| l.include?('seriesInfo') || l.include?('reference') }.join}"
end

puts "reading bibxml-nist library..."
bibxml_mapping = Dir["../bibxml-nist/*"].map do |f|
  [CreateMapping.doi_from_bibxml(read_bibxml(f)), File.basename(f)]
rescue REXML::ParseException => e
  puts "content: "
  puts File.read(f)
  raise "File #{f} parsing error: #{e}"
end.to_h

puts "reading relaton-data-nist library..."
relaton_mapping = Dir["../relaton-data-nist-main/data/*"].map do |f|
  [CreateMapping.doi_from_relaton(File.read(f)), File.basename(f)]
end.to_h

puts "creating map..."
map = CreateMapping.new(bibxml_mapping, relaton_mapping)

if !ARGV.empty? && ARGV[0] == "--missing"
  map.mapping.each do |bibxml_file, relaton_file|
    puts "missing #{bibxml_file} to relaton-data-nist" if relaton_file.nil?
  end
else
  map.mapping.each do |bibxml_file, relaton_file|
    puts "#{bibxml_file} -> #{relaton_file}" unless relaton_file.nil?
  end
end
