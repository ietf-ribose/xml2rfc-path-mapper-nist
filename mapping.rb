require "json"

class Mapping
  attr_accessor :source, :pubid

  def initialize(source, pubid)
    @source = source
    @pubid = pubid
  end

  def ==(other)
    source == other.source && pubid == other.pubid
  end

  def to_yaml
    "#{@source}: #{@pubid}"
  end

  def to_json(*_args)
    { path: "bibxml-nist/#{@source}", docid: @pubid }.to_json
  end
end
