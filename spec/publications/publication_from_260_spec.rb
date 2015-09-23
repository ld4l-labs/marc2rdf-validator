require 'spec_helper'
require 'linkeddata'

describe 'publication from 260' do

# 260  if |a, |b, |c or |f,  with or without 020a isbns
# 260 (except the first one) when leader6 == 'a'  &&  leader7 == 'b', 'i' or 's'
# first of 260|261|262|264|300, with or without 020a isbns

  context "combo of |a, |b, |c, |e, or |f" do

     # 260 (except the first one) when leader6 == 'a'  &&  leader7 == 'b', 'i' or 's'

    context "|a, |b, |c" do
      context "with 020a isbn" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>06174nam a2200445Ia 4500</leader>
              <controlfield tag="001">260abc_w_020a</controlfield>
              <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
              <datafield ind1=" " ind2=" " tag="020">
                <subfield code="a">0470149264</subfield>
              </datafield>
              <datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Expert podcasting practices for dummies</subfield>
                <subfield code="h">[electronic resource] /</subfield>
                <subfield code="c">by Tee Morris, Evo Terra, and Ryan Williams.</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="260">
                <subfield code="a">Hoboken, [N.J.] :</subfield>
                <subfield code="b">Wiley Pub.,</subfield>
                <subfield code="c">c2008.</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '260abc_w_020a')
        }
        it '1 bf:publication' do
          expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
        end
        it 'publisher name' do
          solns = g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.publisher_name.to_s).to match /^Wiley Pub/
        end
        it 'place of publication' do
          solns = g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.publish_place.to_s).to match /^Hoboken, [N.J.]/
        end
        it 'copyright date' do
          solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.copyright_date.to_s).to match /2008/
        end
        it 'no providerDate' do
          expect(g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY).size).to eq 0
        end
      end # with 020a isbn
      context "without 020a isbn" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>06174nam a2200445Ia 4500</leader>
              <controlfield tag="001">260abc_no_020a</controlfield>
              <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
              <datafield ind1="1" ind2="0" tag="245">
                <subfield code="a">Expert podcasting practices for dummies</subfield>
                <subfield code="h">[electronic resource] /</subfield>
                <subfield code="c">by Tee Morris, Evo Terra, and Ryan Williams.</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="260">
                <subfield code="a">Hoboken, [N.J.] :</subfield>
                <subfield code="b">Wiley Pub.,</subfield>
                <subfield code="c">c2008.</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '260abc_no_020a')
        }
        it '1 bf:publication' do
          expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
        end
        it 'publisher name' do
          solns = g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.publisher_name.to_s).to match /^Wiley Pub/
        end
        it 'place of publication' do
          solns = g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.publish_place.to_s).to match /^Hoboken, [N.J.]/
        end
        it 'copyright date' do
          solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.copyright_date.to_s).to match /2008/
        end
        it 'no providerDate' do
          expect(g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY).size).to eq 0
        end
      end # without 020a isbn
      context "abc - Integrating (leader07 = 'i')" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>03514cai a2200661 a 4500</leader>
              <controlfield tag="001">15566467</controlfield>
              <controlfield tag="008">081223c20089999dcuuu woo     0    2eng  </controlfield>
              <datafield tag="245" ind1="0" ind2="0">
                <subfield code="a">Iraq War 2003 web archive</subfield>
                <subfield code="h">[electronic resource].</subfield>
              </datafield>
              <datafield tag="260" ind1=" " ind2=" ">
                <subfield code="a">Washington, D.C. :</subfield>
                <subfield code="b">Library of Congress,</subfield>
                <subfield code="c">2008-</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '15566467')
        }
        it '1 bf:publication' do
          expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
        end
        it 'publisher name' do
          solns = g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.publisher_name.to_s).to match /^Library of Congress$/
        end
        it 'place of publication' do
          solns = g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.publish_place.to_s).to match /^Washington, D.C./
        end
        it 'no copyright date' do
          expect(g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY).size).to eq 0
        end
        it 'providerDate' do
          solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.publish_date.to_s).to match /2008/
        end
      end # abc integrating
    end # |a, |b, |c

    context "serial 260 |a, |b" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01384cas a22003377a 4500</leader>
            <controlfield tag="001">260ab_serial</controlfield>
            <controlfield tag="008">951215c19uu9999bt ar   b    f0    0eng  </controlfield>
            <datafield tag="245" ind1="1" ind2="0">
              <subfield code="a">`Budget estimates for fiscal year ...</subfield>
              <subfield code="h">[microform] :</subfield>
              <subfield code="b">Ministry of Health &amp; Education.</subfield>
            </datafield>
            <datafield tag="260" ind1=" " ind2=" ">
              <subfield code="a">[Thimphu] :</subfield>
              <subfield code="b">National Budget &amp; Aid Co-ordination Division, Ministry of Finance, Royal Govt. of Bhutan</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '260ab_serial')
      }
      it '1 bf:publication' do
        expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
      end
      it 'publisher name' do
        solns = g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publisher_name.to_s).to match /^National Budget & Aid Co-ordination Division, Ministry of Finance, Royal Govt. of Bhuta/
      end
      it 'place of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_place.to_s).to match /^Thimphu/
      end
      it 'no copyright date' do
        expect(g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY).size).to eq 0
      end
      it 'no date of publication' do
        expect(g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY).size).to eq 0
      end
    end # serial 260 |a, |b

    context "book |a, |c" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>00595cam a2200193   4500</leader>
            <controlfield tag="001">a966189</controlfield>
            <controlfield tag="008">740726s1967    nyu           ||| | eng  </controlfield>
            <datafield ind1="1" ind2="4" tag="245">
              <subfield code="a">The grapes of wrath.</subfield>
            </datafield>
            <datafield ind1=" " ind2=" " tag="260">
              <subfield code="a">New York, Viking Press</subfield>
              <subfield code="c">[c1967]</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'a966189')
      }
      it '1 bf:publication' do
        expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
      end
      it 'no publisher name' do
        expect(g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY).size).to eq 0
      end
      it 'place of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_place.to_s).to match /^New York/
        expect(solns.first.publish_place.to_s).to match /Viking Press/
      end
      it 'copyright date' do
        solns = g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.copyright_date.to_s).to match /1967/
      end
      it 'no providerDate' do
        expect(g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY).size).to eq 0
      end
    end # book |a, |c

    context "multiple 260 - serial" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>02015cas a2200529 a 4500</leader>
            <controlfield tag="001">11485330</controlfield>
            <controlfield tag="008">921028c19899999fr br         0   b0fre c</controlfield>
            <datafield tag="245" ind1="1" ind2="0">
              <subfield code="a">Textuel.</subfield>
            </datafield>
            <datafield tag="260" ind1=" " ind2=" ">
              <subfield code="a">Paris :</subfield>
              <subfield code="b">L\'U.F.R. "Science des textes et documents",</subfield>
              <subfield code="c">1990-</subfield>
            </datafield>
            <datafield tag="260" ind1="2" ind2=" ">
              <subfield code="3">&lt;2011&gt;-2013</subfield>
              <subfield code="a">Paris :</subfield>
              <subfield code="b">UFR Lettres, Arts, Cine&#x301;ma</subfield>
            </datafield>
            <datafield tag="260" ind1="3" ind2=" ">
              <subfield code="3">2014-</subfield>
              <subfield code="a">Paris :</subfield>
              <subfield code="b">Hermann</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '11485330')
      }
      it '3 bf:publication' do
        expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 3
      end
      it 'publisher names' do
        solns = g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY)
        expect(solns.size).to eq 3
        solns.each { |soln|
          expect(soln.publisher_name.to_s).to match /^(L'U.F.R. "Science des textes et documents"|UFR Lettres, Arts, Cinéma|Hermann)/
        }
      end
      it 'place of publication' do
        solns = g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_place.to_s).to match /^Paris/
      end
      it 'no copyright date' do
        expect(g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY).size).to eq 0
      end
      it 'providerDate' do
        solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
        expect(solns.size).to eq 1
        expect(solns.first.publish_date.to_s).to match /1990/
      end
    end # multiple 260 - serial

  end # combo of |a, |b, |c, |e or |f

  context "|a only" do
    it 'need test data for 260 a only' do
      fail 'need test data for 260 a only'
    end
    context "with 020a ISBN" do

    end # with 020a ISBN
    context "without 020a ISBN" do

    end # without 020a ISBN
  end # |a only

  context "|b only" do
    it 'need test data for 260 b only' do
      fail 'need test data for 260 b only'
    end
    context "with 020a ISBN" do

    end # with 020a ISBN
    context "without 020a ISBN" do

    end # without 020a ISBN
  end # |b only

  context "|c" do
    context "with 020a ISBN" do
      it 'need test data for 260 c only with 020a isbn' do
        fail 'need test data for 260 c only with 020a isbn'
      end
    end # with 020a ISBN
    context "without 020a ISBN" do
      context "recording" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>01779cim a2200373 a 4500</leader>
              <controlfield tag="001">260c_no_020a</controlfield>
              <controlfield tag="008">931119s1958    dcunnn         f    eng  </controlfield>
              <datafield tag="245" ind1="1" ind2="0">
                <subfield code="a">Eudora Welty reading three of her short stories</subfield>
                <subfield code="h">[sound recording].</subfield>
              </datafield>
              <datafield tag="260" ind1=" " ind2=" ">
                <subfield code="c">1958.</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '260c_no_020a')
        }
        it '1 bf:publication' do
          expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
        end
        it 'no publisher name' do
          expect(g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY).size).to eq 0
        end
        it 'no place of publication' do
          expect(g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY).size).to eq 0
        end
        it 'no copyright date' do
          expect(g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY).size).to eq 0
        end
        it 'date of publication' do
          solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.publish_date.to_s).to match /^1958/
        end
      end # recording
      context "screenplay" do
        let(:g) {
          marcxml_str =
            '<record xmlns="http://www.loc.gov/MARC21/slim">
              <leader>00602nam a22001935  4500</leader>
              <controlfield tag="001">a2264379</controlfield>
              <controlfield tag="008">920421s1974    cau|||||||||||||||||||||d</controlfield>
              <datafield ind1="1" ind2="4" tag="245">
                <subfield code="a">The grapes of wrath.</subfield>
              </datafield>
              <datafield ind1=" " ind2=" " tag="260">
                <subfield code="c">1974.</subfield>
              </datafield>
            </record>'
          self.send(MARC2BF_GRAPH_METHOD, marcxml_str, 'a2264379')
        }
        it '1 bf:publication' do
          expect(g.query(PublicationHelpers::PUBLICATION_SPARQL_QUERY).size).to eq 1
        end
        it 'no publisher name' do
          expect(g.query(PublicationHelpers::PUBLISHER_NAME_SPARQL_QUERY).size).to eq 0
        end
        it 'no place of publication' do
          expect(g.query(PublicationHelpers::PUBLISH_PLACE_SPARQL_QUERY).size).to eq 0
        end
        it 'no copyright date' do
          expect(g.query(PublicationHelpers::COPYRIGHT_DATE_SPARQL_QUERY).size).to eq 0
        end
        it 'date of publication' do
          solns = g.query(PublicationHelpers::PUBLISH_DATE_SPARQL_QUERY)
          expect(solns.size).to eq 1
          expect(solns.first.publish_date.to_s).to match /^1974/
        end
      end
    end # without 020a ISBN
  end # |c only

  context "|e only" do
    # expect it NOT to trigger output
    it 'need test data for 260 e only' do
      fail 'need test data for 260 e only'
    end
    context "with 020a ISBN" do

    end # with 020a ISBN
    context "without 020a ISBN" do

    end # without 020a ISBN
  end # |e only

  context "|f" do
    it 'need test data for 260 f only' do
      fail 'need test data for 260 f only'
    end
    context "with 020a ISBN" do

    end # with 020a ISBN
    context "without 020a ISBN" do

    end # without 020a ISBN
  end # |f only

  context "none of |a, |b, |c, |e, or |f" do
    it 'need test data for 260 without |a, |b, |c, |e, or |f' do
      fail 'need test data for 260 without |a, |b, |c, |e, or |f'
    end
  end # none of |a, |b, |c, |e, or |f
end