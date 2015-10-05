require 'spec_helper'
require 'linkeddata'

describe 'publication from 261, 262, 300' do

  # 260 and 264 are in separate spec files

  #261 or 262
  # first of 260|261|262|264|300, with or without 020a isbns

  context "261" do
    context "with 020a isbn" do
      it 'need test data for 261 with 020a isbn' do
        fail 'need test data for 261 with 020a isbn'
      end
    end # with 020a isbn
    context "without 020a isbn" do
      it 'need test data for 261 without 020a isbn' do
        fail 'need test data for 261 without 020a isbn'
      end
    end # without 020a isbn
  end  # 261

  context "262" do
    context "with 020a isbn" do
      it 'need test data for 262 with 020a isbn' do
        fail 'need test data for 262 with 020a isbn'
      end
    end # with 020a isbn
    context "without 020a isbn" do
      it 'need test data for 262 without 020a isbn' do
        fail 'need test data for 262 without 020a isbn'
      end
    end # without 020a isbn
  end # 262

  context "300" do
    context "with 020a isbn" do
      it 'need test data for 300 with 020a isbn' do
        fail 'need test data for 300 with 020a isbn'
      end
    end # with 020a isbn
    context "without 020a isbn" do
      context "archive collection" do
        let!(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01855cemaa22003131a 4500</leader>
              <controlfield tag="001">a4719997</controlfield>
              <controlfield tag="008">020123q14861865sa                  eng u</controlfield>
              <datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Dr. Oscar I. Norwich collection of maps of Africa and its islands,</subfield>
                <subfield code="f">1486 - ca. 1865.</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="300">
                <subfield code="a">312 items.</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'a4719997')
        }
        it 'no bf:publication' do
          expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 0
        end
      end # archive collection
      context "meeting" do
        let!(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01736cam a22003254a 4500</leader>
              <controlfield tag="001">13673856</controlfield>
              <controlfield tag="008">040528s2004    ja a     b    100 0 jpn  </controlfield>
              <datafield tag="245" ind1="1" ind2="0">
                <subfield code="a"> "Shinto&#x304;" wa do hon&#x2BE;yakusarete iru ka /</subfield>
                <subfield code="c">[henshu&#x304; Kokugakuin Daigaku 21-seiki COE Puroguramu].  </subfield>
              </datafield>
              <datafield tag="300" ind1=" " ind2=" ">
                <subfield code="a">123 p. :</subfield>
                <subfield code="b">ill. ;</subfield>
                <subfield code="c">26 cm.</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '13673856')
        }
        it 'no bf:publication' do
          expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 0
        end
      end # meeting
    end # without 020a isbn
  end # 300

end