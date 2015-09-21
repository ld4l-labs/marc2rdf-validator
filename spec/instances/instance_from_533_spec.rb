require 'spec_helper'
require 'linkeddata'

describe 'instance from 533 (related reproduction)' do
  # each 533 with |b, |c, |d, |e, |m or |n

  context "|b" do
    it 'need test data for 533 b only' do
      fail 'need test data for 533 b only'
    end
  end # |b

  context "|c" do
    it 'need test data for 533 c only' do
      fail 'need test data for 533 c only'
    end
  end # |c

  context "|d" do
    it 'need test data for 533 d only' do
      fail 'need test data for 533 d only'
    end
  end # |d

  context "|e" do
    it 'need test data for 533 e only' do
      fail 'need test data for 533 e only'
    end
  end # |e

  context "|m" do
    it 'need test data for 533 m only' do
      fail 'need test data for 533 m only'
    end
  end # |m

  context "|n" do
    it 'need test data for 533 n only' do
      fail 'need test data for 533 n only'
    end
  end # |n

  context "combo of some of |b, |c, |d, |e, |m or |n" do
    context "533 + 260" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">533combo_260</controlfield>
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
            <datafield ind1=" " ind2=" " tag="533">
              <subfield code="a">Electronic reproduction.</subfield>
              <subfield code="b">Boston, Mass. :</subfield>
              <subfield code="c">Safari Books Online,</subfield>
              <subfield code="d">2008.</subfield>
              <subfield code="n">Mode of access:  World Wide Web.</subfield>
              <subfield code="n">Available to subscribing institutions.</subfield>
              <subfield code="7">s2008    maun s</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '533combo_260')
      }
      it '2 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
      end
      it '2 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
      end
      it 'single Work or relationship between Instances or between Works' do
        num_works = g.query(WorkHelpers::WORK_SPARQL_QUERY).size
        expect(num_works).to be >= 1
        if num_works > 1
          num_work_rels = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY).size
          num_instance_rels = g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size
          expect(num_work_rels + num_instance_rels).to be > 0
        end
      end
      it 'no direct relationship between Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
      end
    end # 533 + 260
    context "533 + 260 + 020s" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>06174nam a2200445Ia 4500</leader>
            <controlfield tag="001">533combo_260_020s</controlfield>
            <controlfield tag="008">080813s2008    njua    s     001 0 eng d</controlfield>
            <datafield ind1=" " ind2=" " tag="020">
              <subfield code="a">9780470149263</subfield>
            </datafield>
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
            <datafield ind1=" " ind2=" " tag="533">
              <subfield code="a">Electronic reproduction.</subfield>
              <subfield code="b">Boston, Mass. :</subfield>
              <subfield code="c">Safari Books Online,</subfield>
              <subfield code="d">2008.</subfield>
              <subfield code="n">Mode of access:  World Wide Web.</subfield>
              <subfield code="n">Available to subscribing institutions.</subfield>
              <subfield code="7">s2008    maun s</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '533combo_260_020s')
      }
      it '2 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
      end
      it '2 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
      end
      it 'single Work or relationship between Instances or between Works' do
        num_works = g.query(WorkHelpers::WORK_SPARQL_QUERY).size
        expect(num_works).to be >= 1
        if num_works > 1
          num_work_rels = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY).size
          num_instance_rels = g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size
          expect(num_work_rels + num_instance_rels).to be > 0
        end
      end
      it 'no direct relationship between Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
      end
    end # 533 + 260 + 020s
    context "533 + 260 + 300 serial" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01384cas a22003377a 4500</leader>
            <controlfield tag="001">533combo_260_300_serial</controlfield>
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
            <datafield tag="300" ind1=" " ind2=" ">
              <subfield code="a">v. ;</subfield>
              <subfield code="c">29 cm.</subfield>
            </datafield>
            <datafield tag="533" ind1=" " ind2=" ">
              <subfield code="a">Microfiche.</subfield>
              <subfield code="m">1994/95-</subfield>
              <subfield code="b">New Delhi :</subfield>
              <subfield code="c">Library of Congress Office ;</subfield>
              <subfield code="b">Washington, D.C. :</subfield>
              <subfield code="c">Library of Congress Photoduplication Service,</subfield>
              <subfield code="d">1995-</subfield>
              <subfield code="e">microfiches.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '533combo_260_300_serial')
      }
      it '2 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
      end
      it '2 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
      end
      it 'single Work or relationship between Instances or between Works' do
        num_works = g.query(WorkHelpers::WORK_SPARQL_QUERY).size
        expect(num_works).to be >= 1
        if num_works > 1
          num_work_rels = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY).size
          num_instance_rels = g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size
          expect(num_work_rels + num_instance_rels).to be > 0
        end
      end
      it 'no direct relationship between Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
      end
    end # 533 + 260 + 300 serial
    context "533 + 260 + 300 recording" do
      let(:g) {
        marcxml_str =
          '<record xmlns="http://www.loc.gov/MARC21/slim">
            <leader>01779cim a2200373 a 4500</leader>
            <controlfield tag="001">533combo_260_300_recording</controlfield>
            <controlfield tag="008">931119s1958    dcunnn         f    eng  </controlfield>
            <datafield tag="245" ind1="1" ind2="0">
              <subfield code="a">Eudora Welty reading three of her short stories</subfield>
              <subfield code="h">[sound recording].</subfield>
            </datafield>
            <datafield tag="260" ind1=" " ind2=" ">
              <subfield code="c">1958.</subfield>
            </datafield>
            <datafield tag="300" ind1=" " ind2=" ">
              <subfield code="a">1 sound tape reel (ca. 67 min.) :</subfield>
              <subfield code="b">analog, 7 1/2 ips, 2 track, mono. ;</subfield>
              <subfield code="c">10 in.</subfield>
            </datafield>
            <datafield tag="533" ind1=" " ind2=" ">
              <subfield code="a">Preservation master.</subfield>
              <subfield code="b">Washington, D.C. :</subfield>
              <subfield code="c">Library of Congress Magnetic Recording Laboratory,</subfield>
              <subfield code="d">1973.</subfield>
              <subfield code="e">1 sound tape reel : analog, 7 1/2 ips, 2 track, mono. ; 10 in.</subfield>
            </datafield>
          </record>'
        self.send(MARC2BF_GRAPH_METHOD, marcxml_str, '533combo_260_300_recording')
      }
      it '2 Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_SPARQL_QUERY).size).to eq 2
      end
      it '2 instanceOf' do
        expect(g.query(InstanceHelpers::INSTANCE_OF_SPARQL_QUERY).size).to eq 2
      end
      it 'single Work or relationship between Instances or between Works' do
        num_works = g.query(WorkHelpers::WORK_SPARQL_QUERY).size
        expect(num_works).to be >= 1
        if num_works > 1
          num_work_rels = g.query(WorkHelpers::WORK_PROP_WORK_SPARQL_QUERY).size
          num_instance_rels = g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size
          expect(num_work_rels + num_instance_rels).to be > 0
        end
      end
      it 'no direct relationship between Instances' do
        expect(g.query(InstanceHelpers::INSTANCE_PROP_INSTANCE_SPARQL_QUERY).size).to eq 0
      end
    end # 533 + 260 + 300 recording
  end # combo

  context "none of |b, |c, |d, |e, |m or |n" do
    it 'need test data for 533 without |b, |c, |d, |e, |m or |n' do
      fail 'need test data for 533 without of |b, |c, |d, |e, |m or |n'
    end

  end # none of |b, |c, |d, |e, |m or |n
end