require_relative "create_mapping"

RSpec.describe CreateMapping do
  let(:doi) { "10.6028/NIST.IR.5591" }
  let(:source) { "http://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir5591.pdf" }

  let(:bibxml_mapping) {
    { doi => bibxml_filename }
  }

  let(:relaton_mapping) {
    { doi => relaton_filename }
  }

  let(:relaton_filename) { "NISTIR_5591.yaml" }
  let(:bibxml_filename) { "reference.NIST.IR.5591.xml" }

  let(:bibxml_content) do
    <<~XML
      <?xml version='1.0' encoding='UTF-8'?>
       <reference  anchor='NIST.IR.5591' target='http://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir5591.pdf'>
         <front>
           <title>Post-occupancy evaluation of the Forrestal Building</title>
           <author initials='Philip A' surname='Sanders' fullname='Philip A Sanders'>
             <organization />
           </author>
           <author initials='Belinda L' surname='Collins' fullname='Belinda L Collins'>
             <organization />
           </author>
           <date year='1995' month='May' />
         </front>
         <seriesInfo name='NIST' value='NISTIR 5591' />
         <seriesInfo name='DOI'  value='10.6028/NIST.IR.5591' />
       </reference>
    XML
  end

  let(:relaton_content) do
    <<~YAML
      ---
      id: NISTIR5591
      link:
      - content: http://nvlpubs.nist.gov/nistpubs/Legacy/IR/nistir5591.pdf
        type: doi
      docid:
      - id: NIST IR 5591
        type: NIST
        primary: true
      - id: 10.6028/NIST.IR.5591
        type: DOI
      - id: NIST.IR.5591
        type: NIST
        scope: anchor
    YAML
  end

  subject { described_class.new(bibxml_mapping, relaton_mapping) }

  it "extracts doi from bibxml file" do
    expect(described_class.doi_from_bibxml(bibxml_content)).to eq(doi)
  end

  it "extracts doi from relaton file" do
    expect(described_class.doi_from_relaton(relaton_content)).to eq(doi)
  end

  it "extracts source from bibxml file" do
    expect(described_class.source_from_bibxml(bibxml_content)).to eq(source)
  end

  it "extracts source from relaton file" do
    expect(described_class.source_from_relaton(relaton_content)).to eq(source)
  end

  it "create a map between bibxml and relaton file" do
    expect(subject.mapping).to eq({ bibxml_filename => relaton_filename })
  end
end
