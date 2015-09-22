require 'linkeddata'

module InstanceHelpers

  self::INSTANCE_SPARQL_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                              SELECT DISTINCT ?instance
                                              WHERE {
                                                ?instance a bf:Instance .
                                              }")

  self::INSTANCE_OF_SPARQL_QUERY = SPARQL.parse(" PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                                  SELECT DISTINCT ?instance ?work
                                                  WHERE {
                                                    ?instance a bf:Instance .
                                                    ?instance bf:instanceOf ?work .
                                                    ?work a bf:Work .
                                                  }")

  self::INSTANCE_PROP_INSTANCE_SPARQL_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                                            SELECT DISTINCT ?instance1 ?prop ?instance2
                                                            WHERE {
                                                              ?instance1 a bf:Instance .
                                                              ?instance1 ?prop ?instance2 .
                                                              ?instance2 a bf:Instance .
                                                            }")

  self::ANNOTATION_BODY_SPARQL_QUERY = SPARQL.parse(" PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                                      SELECT DISTINCT ?annotationBody
                                                      WHERE {
                                                        ?anno a bf:Annotation .
                                                        ?anno bf:annotationBody ?annotationBody .
                                                      }")

  self::TITLE_VALUE_OF_INSTANCE_SPARQL_QUERY = SPARQL.parse(" PREFIX bf: <http://bibframe.org/vocab/>
                                                              SELECT DISTINCT ?titleValue
                                                              WHERE {
                                                                ?instance a bf:Instance .
                                                                ?instance bf:instanceTitle ?title .
                                                                ?title a bf:Title .
                                                                ?title bf:titleValue ?titleValue .
                                                              }")

  self::SUBTITLE_OF_INSTANCE_SPARQL_QUERY = SPARQL.parse("PREFIX bf: <http://bibframe.org/vocab/>
                                                          SELECT DISTINCT ?subtitle
                                                          WHERE {
                                                            ?instance a bf:Instance .
                                                            ?instance bf:instanceTitle ?title .
                                                            ?title a bf:Title .
                                                            ?title bf:subtitle ?subtitle .
                                                          }")

  def expect_instance2instance_property(graph, exp_num, exp_prop)
    solns = g.query(INSTANCE_PROP_INSTANCE_SPARQL_QUERY)
    expect(solns.size).to eq exp_num
    solns.each { |soln|
      expect(soln.prop).to eq exp_prop
    }
  end

end