require 'spec_helper'
require 'linkeddata'

describe 'publication dates (NOT copyright)' do

  # variants on date strings in 260c, 264c
  # 533d?

  context "single year" do
    describe "dddd" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">2014</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^2014$/
      end
    end # dddd
    describe "dddd." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd.</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">2014.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd.')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^2014$/
      end
    end # dddd.
    describe "dddd-" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd-</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">2014-</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd-')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^2014$/
      end
    end # dddd-
    describe "dddd]" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd_end_bracket</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">2014]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd_end_bracket')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^2014$/
      end
    end # dddd]
    describe "dddd?]" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd_question_end_bracket</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">2014?]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd_question_end_bracket')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^2014$/
      end
    end # dddd?]
    describe "dddd ;" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd_semicolon</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">1939 ;</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd_semicolon')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^1939$/
      end
    end # dddd ;
    describe "[dddd]" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">brackets</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[2014]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'brackets')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^2014$/
      end
    end # [dddd]
    describe "[dddd?]" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">brackets_question_mark</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[2012?]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'brackets_question_mark')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^2012$/
      end
    end # [dddd?]
    describe "[dddd?]." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">brackets_question_mark.</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[2012?].</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'brackets_question_mark.')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^2012$/
      end
    end # [dddd?].

    describe "pdddd." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">pdddd.</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">p1978.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'pdddd.')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^1978$/
      end
    end # pdddd.
  end # single year

  context "year range" do
    describe "dddd-dddd" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd-dddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">1839-1950</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd-dddd')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to be > 2
      end
    end # dddd-dddd
    describe "dddd-dddd." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd-dddd.</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">1839-1950.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd-dddd.')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to be > 2
      end
    end # dddd-dddd.
    describe "[dddd-dddd]" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">brackets_dddd-dddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[1992-2005]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'brackets_dddd-dddd')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to be > 2
      end
    end # [dddd-dddd]
    describe "[dddd?-dddd?]" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">brackets_question_marks_dddd-dddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[1970?-1983?]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'brackets_question_marks_dddd-dddd')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to be > 2
      end
    end # [dddd?-dddd?]
  end # year range

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

  context "mult years" do
    describe "[dddd], pdddd." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd_pdddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[1989], p1987.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd_pdddd')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 2
        solns.each { |soln|
          expect(soln.publish_date.to_s).to match /^(1989|1987)$/
        }
      end
    end # [dddd], pdddd.
    describe "dddd, dddd printing." do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd_dddd_printing</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">1958, 1961 printing.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd_dddd_printing')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 2
        solns.each { |soln|
          expect(soln.publish_date.to_s).to match /^(1958|1961)$/
        }
      end
    end # dddd, dddd printing.
  end # mult years

  context "other calendars" do
    describe "[ddd i.e. dddd]" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">ddd_i_e_dddd.</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">[766 i.e. 2006]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'ddd_i_e_dddd')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^2006$/
      end
    end # [ddd i.e. dddd]
    describe "dddd [dddd]" do
      let!(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">dddd_brackets_dddd</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1="1" ind2="0" tag="245">
              <subfield code="a">copyright date</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="c">1123 [1948]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'dddd_brackets_dddd')
      }
      it 'date of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /^1948$/
      end
    end # dddd [dddd]
  end # other calendars

end