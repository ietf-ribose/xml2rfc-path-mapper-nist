require_relative "create_mapping"

def read_bibxml(file)
  # hack for broken xml files with content like:
  # <author initials='Carol' surname='O'Connor' fullname='Carol O'Connor'><organization /></author>
  "<?xml version='1.0' encoding='UTF-8'?>#{
    File.readlines(file).select { |l| l.include?('seriesInfo') || l.include?('reference') }.join}"
end

STDERR.puts "reading bibxml-nist library..."
bibxml_mapping = Dir["/tmp/bibxml-to-relaton/bibxml-nist/*"]
                   .sort_by { |x| File.mtime(x) }.map do |f|
  [CreateMapping.source_from_bibxml(read_bibxml(f)), File.basename(f)]
rescue REXML::ParseException => e
  raise "File #{f} parsing error: #{e}"
end.to_h

STDERR.puts "reading relaton-data-nist library..."
relaton_mapping = Dir["/tmp/bibxml-to-relaton/relaton-data-nist-main/data/*"]
                    .sort_by { |x| File.mtime(x) }.map do |f|
  CreateMapping.source_docid_from_relaton(File.read(f))
end.to_h

STDERR.puts "creating map..."
map = CreateMapping.new(bibxml_mapping, relaton_mapping)

if !ARGV.empty? && ARGV[0] == "--missing"
  map.mapping.each do |bibxml_file, relaton_docid|
    puts "missing #{bibxml_file} to relaton-data-nist" if relaton_docid.nil?
  end
else
  map.mapping.each do |bibxml_file, relaton_docid|
    puts "#{bibxml_file}: #{relaton_docid}" unless relaton_docid.nil?
  end
end
