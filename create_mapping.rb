require "rexml"
require "yaml"

SOURCE="bibxml-nist"
DESTINATION="relaton-data-nist-main"

class CreateMapping
  attr_accessor :bibxml_mapping, :relaton_mapping

  def initialize(bibxml_mapping, relaton_mapping)
    @bibxml_mapping = bibxml_mapping
    @relaton_mapping = relaton_mapping
  end

  def self.doi_from_bibxml(content)
    REXML::Document.new(content).get_elements("reference/seriesInfo")
      .select { |e| e.attributes["name"] == "DOI" }.first.attributes["value"]
  end

  def self.doi_from_relaton(content)
    YAML.load(content)["docid"].select { |d| d["type"] == "DOI" }.first["id"]
  end

  def mapping
    @bibxml_mapping.map do |doi, bibxml_file|
      [bibxml_file, @relaton_mapping[doi]]
    end.to_h
  end

  def lookup_source_by(doi)
    nil
  end
end
