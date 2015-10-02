require 'linkeddata'

module PersonHelpers
  self::PERSON_SPARQL_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                              SELECT DISTINCT ?person
                                              WHERE {
                                                ?person a bf:Person .
                                              }"
                                          )

  self::PERSON_AUTHORITY_SPARQL_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                              SELECT DISTINCT ?authority
                                              WHERE {
                                                  ?s a bf:Person .
                                                  ?s bf:hasAuthority ?authority
                                              }"
                                          )
end
