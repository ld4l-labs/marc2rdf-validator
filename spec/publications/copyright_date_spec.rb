require 'spec_helper'
require 'linkeddata'

describe 'publication copyright dates from 260, 264' do

  # variants on date strings in 260c, 264c
  # 533d?

  # the LC xquery converter determines copyright dates from 'c' at the beginning of a pub date string.
  context "single year" do
    describe "some test" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">cdddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">c2014</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'cdddd')
      }
      it 'does something' do
        fail 'test to be implemented'
      end


    end
    describe "cdddd" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">cdddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">c2014</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'cdddd')
      }
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^2014$/
      end
    end # cdddd
    describe "cdddd." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">cdddd.</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">c2014.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'cdddd.')
      }
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^2014$/
      end
    end # cdddd.
    describe "cdddd]" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">cdddd_end_bracket</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">c2014]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'cdddd_end_bracket')
      }
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^2014$/
      end
    end # cdddd]
    describe "cdddd-" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">cdddd-</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">c1986-</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'cdddd-')
      }
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^1986$/
      end
    end # cdddd-
    describe "[cdddd]" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">brackets_cdddd-</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[c1985]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'brackets_cdddd')
      }
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^1985$/
      end
    end # [cdddd]
    describe "©dddd" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">symboldddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">©2015</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'symboldddd')
      }
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^2015$/
      end
    end # ©dddd
    describe "-cdddd." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">-cdddd.</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">-c1994.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '-cdddd.')
      }
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^1994$/
      end
    end # -cdddd.
  end
  describe "multiple dates" do
    describe "cdddd (repr. dddd)" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">cdddd_repr_dddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">c1990 (repr. 1999)</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '-cdddd_repr_dddd')
      }
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^1990$/
      end
    end # cdddd (repr. dddd)
    describe "&#xA9;dddd-cdddd." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">symboldddd-cdddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">&#xA9;1971-c1980.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'symboldddd-cdddd')
      }
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 2
        solns.each { |soln|
          expect(soln.copyright_date.to_s).to match /^(1971|1980)$/
        }
      end
    end # &#xA9;dddd-cdddd.
  end # multiple dates

  describe "year and copyright year" do
    describe "dddd, cdddd." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd_then_cdddd.</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">2012, c2001.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd_then_cdddd.')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^2012$/
      end
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^2001$/
      end
    end # dddd, cdddd.
    describe "[dddd-cdddd]" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">brackets_dddd-cdddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[1974-c1985]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'brackets_dddd-cdddd')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^1974$/
      end
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^1985$/
      end
    end # [dddd-cdddd]
    describe "[dddd]-cdddd." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">brackets_only_dddd-cdddd.</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[1986]-c2006.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'brackets_only_dddd-cdddd.')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^1986$/
      end
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^2006$/
      end
    end # [dddd]-cdddd.
    describe "[dddd] ©dddd." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">brackets_only_dddd_symbol_dddd.</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[1986] &#xA9;1985.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'brackets_only_dddd_symbol_dddd.')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^1986$/
      end
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^1985$/
      end
    end # [dddd]-©dddd.
    describe "[dddd], ©dddd." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">brackets_only_dddd_comma_symbol_dddd.</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[1986], &#xA9;1985.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'brackets_only_dddd_comma_symbol_dddd.')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^1986$/
      end
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^1985$/
      end
    end # [dddd]-©dddd.
    describe "cdddd (repr. dddd)" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">cdddd_repr_dddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">c1990 (repr. 1999)</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '-cdddd_repr_dddd')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^1999$/
      end
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /^1990$/
      end
    end # cdddd (repr. dddd)
  end # year and copyright year

end