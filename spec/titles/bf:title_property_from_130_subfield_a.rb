require 'spec_helper'
require 'linkeddata'

# X30, 240, etc. - Uniform titles - R1

describe 'bf:title from uniform title' do
  context '$a or $t - Uniform title (NR)' do
    let!(:g) {
      marcxml =
      '<record xmlns="http://www.loc.gov/MARC21/slim">
        <leader>01033cam a22002891  4500</leader>
        <controlfield tag="001">130a_only</controlfield>
        <controlfield tag="008">860506s1957    nyua     b    000 0 eng  </controlfield>
        <datafield ind1="0" ind2=" " tag="130">
          <subfield code="a">Beowulf.</subfield>
        </datafield>
        <datafield ind1="1" ind2="0" tag="245">
          <subfield code="a">IGNORE</subfield>
          <subfield code="c">IGNORE</subfield>
        </datafield>
      </record>'
      self.send(MARC2BF_GRAPH_METHOD, marcxml, '130_subfield_a_uniform_title')
    }
    # THE LD4L TAG SHOULD NOT NECESSARILY APPLY HERE (PENDING SPEC) USED FOR TAGGING EXAMPLE ONLY
    it 'should have a literal "Beowulf."', bf2: true, ld4l: true do
      # puts "#{g.to_ttl}"
      # puts "#{g.query(WorkHelpers::UNIFORM_TITLE_QUERY).to_tsv}"
      expect(g.query(TitleHelpers::UNIFORM_TITLE_QUERY).to_tsv).to include("Beowulf.")
    end
    it 'should have a bf:title property', bf2: true do
      expect(g.query(TitleHelpers::UNIFORM_TITLE_QUERY).to_tsv).to include("<http://bibframe.org/vocab/title>")
    end
  end
end
