
require 'linkeddata'

module WorkHelpers

  self::WORK_SPARQL_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                    SELECT DISTINCT ?work
                                    WHERE {
                                      ?work a bf:Work .
                                    }")

  self::WORK_PROP_WORK_SPARQL_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                              SELECT DISTINCT ?mainwork ?prop ?relwork
                                              WHERE {
                                                ?mainwork a bf:Work .
                                                ?mainwork ?prop ?relwork .
                                                ?relwork a bf:Work .
                                              }")

  def expect_work2work_property(graph, exp_num, exp_prop)
    solns = g.query(WORK_PROP_WORK_SPARQL_QUERY)
    expect(solns.size).to eq exp_num
    solns.each { |soln|
      expect(soln.prop).to eq exp_prop
    }
  end

end