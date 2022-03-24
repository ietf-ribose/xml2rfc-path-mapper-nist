require_relative "mapping"

RSpec.describe Mapping do
  let(:source) { "reference.NIST.SP.500-163.xml" }
  let(:pubid) { "NIST SP 500-163" }

  subject { described_class.new(source, pubid) }

  it "formats to yaml" do
    expect(subject.to_yaml).to eq("#{source}: #{pubid}")
  end

  it "formats to json" do
    expect(subject.to_json).to eq({ path: "bibxml2/_#{source}",
                                    docid: pubid }.to_json)
  end
end
