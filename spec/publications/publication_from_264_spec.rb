require 'spec_helper'
require 'linkeddata'

describe 'publication from 264' do

# 264  if |b and NOT (264 ind2=(2|3) ) or if |a or |c or |f,  with or without 020a isbns

  # does it only check ind2 if |b ??
  context "ind2=0 (production)" do
    it 'need test data for 264 ind2=0' do
      fail 'need test data for 264 ind2=0'
    end
  end # ind2=0

  context "ind2=1 (publication)" do
    context "combo of |a, |b, |c, |e, or |f" do
      context "with 020a ISBN" do
        context "book with |a, |b, |c" do
          let!(:g) {
            marcxml_str =
              '<record xmlns="http://www.loc.gov/MARC21/slim">
                <leader>03956cam a2200445 i 4500</leader>
                <controlfield tag="001">17432593</controlfield>
                <controlfield tag="008">120816s2012    caua     b    001 0 eng  </controlfield>
                <datafield tag="020" ind1=" " ind2=" ">
                  <subfield code="a">9781593274252 (pbk.)</subfield>
                </datafield>
                <datafield tag="020" ind1=" " ind2=" ">
                  <subfield code="a">1593274254 (pbk.)</subfield>
                </datafield>
                <datafield tag="245" ind1="1" ind2="0">
                  <subfield code="a">Ubuntu made easy :</subfield>
                  <subfield code="b">a project-based introduction to Linux /</subfield>
                  <subfield code="c">by Rickford Grant with Phil Bull.</subfield>
                </datafield>
                <datafield tag="264" ind1=" " ind2="1">
                  <subfield code="a">San Francisco :</subfield>
                  <subfield code="b">No Starch Press,</subfield>
                  <subfield code="c">[2012]</subfield>
                </datafield>
              </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '17432593')
          }
          it '1 bf:publication' do
            expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
          end
          it 'publisher name' do
            solns = g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publisher_name.to_s).to match /^No Starch Press/
          end
          it 'place of publication' do
            solns = g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publish_place.to_s).to match /^San Francisco/
          end
          it 'no copyright date' do
            expect(g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY).size).to eq 0
          end
          it 'date of publication' do
            solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publish_date.to_s).to match /^2012$/
          end
        end  # book with |abc
        context "map with |abc, |c, 2 isbn, ind2=1,4" do
          let!(:g) {
            marcxml_str =
              '<record xmlns="http://www.loc.gov/MARC21/slim">
                <leader>01553cem a2200433 i 4500</leader>
                <controlfield tag="001">a10838962</controlfield>
                <controlfield tag="008">150115t20152015fr        e     1   fre  </controlfield>
                <datafield ind1=" " ind2=" " tag="010">
                  <subfield code="a">2015588552</subfield>
                </datafield>
                <datafield ind1=" " ind2=" " tag="020">
                  <subfield code="a">9782746735842 (hbk.)</subfield>
                </datafield>
                <datafield ind1=" " ind2=" " tag="020">
                  <subfield code="a">2746735849 (hbk.)</subfield>
                </datafield>
                <datafield ind1="1" ind2="0" tag="245">
                  <subfield code="a">Atlas mondial des femmes :</subfield>
                </datafield>
                <datafield ind1=" " ind2="1" tag="264">
                  <subfield code="a">Paris :</subfield>
                  <subfield code="b">Éditions Autrement,</subfield>
                  <subfield code="c">[2015]</subfield>
                </datafield>
                <datafield ind1=" " ind2="4" tag="264">
                  <subfield code="c">©2015</subfield>
                </datafield>
              </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'a10838962')
          }
          it '1 bf:publication' do
            fail 'should this be 1 or 2 Publications?'
            expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
          end
          it 'publisher name' do
            solns = g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publisher_name.to_s).to match /^Éditions Autrement/
          end
          it 'place of publication' do
            solns = g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publish_place.to_s).to match /^Paris/
          end
          it 'copyright date' do
            solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.copyright_date.to_s).to match /^2015$/
          end
          it 'date of publication' do
            solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publish_date.to_s).to match /^2015$/
          end
        end # map with |abc, |c, 2 isbn, ind2=1,4
      end # with 020a ISBN
      context "without 020a ISBN" do
        context "book with |a, |b, |c" do
          let!(:g) {
            marcxml_str =
              '<record xmlns="http://www.loc.gov/MARC21/slim">
                <leader>01718cam a22003617i 4500</leader>
                <controlfield tag="001">16514537</controlfield>
                <controlfield tag="008">101022s1982    is            000 0 heb  </controlfield>
                <datafield tag="245" ind1="1" ind2="0">
                  <subfield code="a">Toldot ha-beh&#x323;irot la-Keneset :</subfield>
                  <subfield code="b">boh&#x323;arim, miflagot, totsa&#x2BC;ot, memshalot /</subfield>
                </datafield>
                <datafield tag="264" ind1=" " ind2="1">
                  <subfield code="a">[Jerusalem] :</subfield>
                  <subfield code="b">Merkaz ha-Hasbarah, Sherut ha-pirsumim,</subfield>
                  <subfield code="c">1987.</subfield>
                </datafield>
              </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '17432593')
          }
          it '1 bf:publication' do
            expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
          end
          it 'publisher name' do
            solns = g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publisher_name.to_s).to match /^Merkaz ha-Hasbarah, Sherut ha-pirsumim/
          end
          it 'no place of publication' do
            solns = g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publish_place.to_s).to match /^Jerusalem/
          end
          it 'no copyright date' do
            expect(g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY).size).to eq 0
          end
          it 'date of publication' do
            solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publish_date.to_s).to match /^1987$/
          end
        end  # book with |abc
        context "book with |a, |b, |c, w 880 for 264" do
          let!(:g) {
            marcxml_str =
              '<record xmlns="http://www.loc.gov/MARC21/slim">
                <leader>01718cam a22003617i 4500</leader>
                <controlfield tag="001">16514537</controlfield>
                <controlfield tag="008">101022s1982    is            000 0 heb  </controlfield>
                <datafield tag="245" ind1="1" ind2="0">
                  <subfield code="a">Toldot ha-beh&#x323;irot la-Keneset :</subfield>
                  <subfield code="b">boh&#x323;arim, miflagot, totsa&#x2BC;ot, memshalot /</subfield>
                </datafield>
                <datafield tag="264" ind1=" " ind2="1">
                  <subfield code="6">880-04</subfield>
                  <subfield code="a">[Jerusalem] :</subfield>
                  <subfield code="b">Merkaz ha-Hasbarah, Sherut ha-pirsumim,</subfield>
                  <subfield code="c">1987.</subfield>
                </datafield>
                <datafield tag="880" ind1=" " ind2="1">
                  <subfield code="6">264-04/(2/r&#x200F;</subfield>
                  <subfield code="a">&#x200F;[&#x202A;Jerusalem&#x202C;] :&#x200F;</subfield>
                  <subfield code="b">&#x200F;&#x5DE;&#x5E8;&#x5DB;&#x5D6; &#x5D4;&#x5D4;&#x5E1;&#x5D1;&#x5E8;&#x5D4;, &#x5E9;&#x5D9;&#x5E8;&#x5D5;&#x5EA; &#x5D4;&#x5E4;&#x5E8;&#x5E1;&#x5D5;&#x5DE;&#x5D9;&#x5DD;,&#x200F;</subfield>
                  <subfield code="c">&#x200F;&#x202A;1987&#x202C;.</subfield>
                </datafield>
              </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '17432593')
          }
          it '1 bf:publication' do
            expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
          end
          it 'publisher name' do
            solns = g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY)
            expect(solns.size).to eq 2
            solns.each { |soln|
              expect(soln.publisher_name.to_s).to match /(Merkaz ha-Hasbarah, Sherut ha-pirsumim|‏מרכז ההסברה, שירות הפרסומי)/
            }
          end
          it 'place of publication' do
            solns = g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY)
            expect(solns.size).to eq 2
            solns.each { |soln|
              expect(soln.publish_place.to_s).to match /(Jerusalem)/
            }
          end
          it 'no copyright date' do
            expect(g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY).size).to eq 0
          end
          it 'date of publication' do
            solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
            fail "should both dates distill down to the same 1987 string?"
            expect(solns.size).to eq 1
            expect(solns.first.publish_date.to_s).to match /^1987$/
          end
        end  # book with |abc with 880 for 264
        context "serial with |a, |b, |c" do
          let!(:g) {
            marcxml_str =
              '<record xmlns="http://www.loc.gov/MARC21/slim">
                <leader>01727cas a2200409 i 4500</leader>
                <controlfield tag="001">17387996</controlfield>
                <controlfield tag="008">120716c20129999nyuqr p       0   a0eng  </controlfield>
                <datafield tag="245" ind1="0" ind2="0">
                  <subfield code="a">Language and communication quarterly.</subfield>
                </datafield>
                <datafield tag="264" ind1=" " ind2="1">
                  <subfield code="a">Niagara Falls, NY :</subfield>
                  <subfield code="b">Untested Ideas Research Center,</subfield>
                  <subfield code="c">[2012]-</subfield>
                </datafield>
              </record>'
            self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '17387996')
          }
          it '1 bf:publication' do
            expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
          end
          it 'publisher name' do
            solns = g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publisher_name.to_s).to match /^Untested Ideas Research Center/
          end
          it 'place of publication' do
            solns = g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publish_place.to_s).to match /^Niagara Falls, NY/
          end
          it 'no copyright date' do
            expect(g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY).size).to eq 0
          end
          it 'date of publication' do
            solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
            expect(solns.size).to eq 1
            expect(solns.first.publish_date.to_s).to match /^2012$/
          end
        end  # serial with |abc
      end # without 020a ISBN
    end # combo of |a, |b, |c, |e, or |f
  end # ind2=1

  context "ind2=2 (distribution)" do
    # bf:distribution
    it 'need test data for 264 ind2=2' do
      fail 'need test data for 264 ind2=2'
    end
  end # ind2=2

  context "ind2=3 (manufacture)" do
    # bf:manufacture
    it 'need test data for 264 ind2=3' do
      fail 'need test data for 264 ind2=3'
    end
  end # ind2=3

  context "ind2=4 (copyright date)" do
    it 'need test data for 264 ind2=4' do
      fail 'need test data for 264 ind2=4'
    end
  end # ind2=4

  context "|a only" do
    context "with 020a ISBN" do
      it 'need test data for 264 a only with 020a isbn' do
        fail 'need test data for 264 a only with 020a isbn'
      end
    end # with 020a ISBN
    context "without 020a ISBN" do
      it 'need test data for 264 a only without 020a isbn' do
        fail 'need test data for 264 a only without 020a isbn'
      end
    end # without 020a ISBN
  end # |a only

  context "|b only" do
    context "with 020a ISBN" do
      it 'need test data for 264 b only with 020a isbn' do
        fail 'need test data for 264 b only with 020a isbn'
      end
    end # with 020a ISBN
    context "without 020a ISBN" do
      it 'need test data for 264 b only without 020a isbn' do
        fail 'need test data for 264 b only without 020a isbn'
      end
    end # without 020a ISBN
  end # |b only

  context "|c only" do
    context "with 020a ISBN" do
      it 'need test data for 264 c only with 020a isbn' do
        fail 'need test data for 264 c only with 020a isbn'
      end
    end # with 020a ISBN
    context "without 020a ISBN" do
      it 'need test data for 264 c only without 020a isbn' do
        fail 'need test data for 264 c only without 020a isbn'
      end
    end # without 020a ISBN
  end # |c only

  context "|e only" do
    context "with 020a ISBN" do
      it 'need test data for 264 e only with 020a isbn' do
        fail 'need test data for 264 e only with 020a isbn'
      end
    end # with 020a ISBN
    context "without 020a ISBN" do
      it 'need test data for 264 e only without 020a isbn' do
        fail 'need test data for 264 e only without 020a isbn'
      end
    end # without 020a ISBN
  end # |e only

  context "|f only" do
    context "with 020a ISBN" do
      it 'need test data for 264 f only with 020a isbn' do
        fail 'need test data for 264 f only with 020a isbn'
      end
    end # with 020a ISBN
    context "without 020a ISBN" do
      it 'need test data for 264 f only without 020a isbn' do
        fail 'need test data for 264 f only without 020a isbn'
      end
    end # without 020a ISBN
  end # |f only

  context "none of |a, |b, |c, |e, or |f" do
    it 'need test data for 264 without |a, |b, |c, |e, or |f' do
      fail 'need test data for 264 without |a, |b, |c, |e, or |f'
    end
  end # none of |a, |b, |c, |e, or |f

end