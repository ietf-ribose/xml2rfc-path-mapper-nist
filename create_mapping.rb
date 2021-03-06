require "rexml"
require "yaml"
require_relative "mapping"

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

  def self.source_from_bibxml(content)
    REXML::Document.new(content).get_elements("reference")
      .first.attributes["target"]
  end

  def self.source_docid_from_relaton(content)
    yaml_content = YAML.load(content)
    [yaml_content["link"].select { |d| d["type"] == "doi" }.first["content"],
     yaml_content["docid"].select { |d| d["type"] == "NIST" && d.key?("primary") }.first["id"]]
  end

  def mapping
    @bibxml_mapping.map do |key, bibxml_file|
      Mapping.new(bibxml_file, @relaton_mapping[key])
    end
  end

  def lookup_source_by(doi)
    nil
  end
end
