require 'linkeddata'

module PublicationHelpers

  self::PUBLICATION_SPARQL_QUERY = SPARQL.parse(" PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                                  SELECT DISTINCT ?publication
                                                  WHERE {
                                                     ?instance a bf:Instance .
                                                     ?instance bf:publication ?publication .
                                                  }")

  self::PUBLISHER_NAME_SPARQL_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                                    SELECT DISTINCT ?publisher_name
                                                    WHERE {
                                                       ?instance a bf:Instance .
                                                       ?instance bf:publication ?publication .
                                                       ?publication a bf:Provider .
                                                       ?publication bf:providerName ?publisher .
                                                       ?publisher a bf:Organization .
                                                       ?publisher bf:label ?publisher_name .
                                                    }")

  self::PUBLISH_PLACE_SPARQL_QUERY = SPARQL.parse(" PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                                    SELECT DISTINCT ?publish_place
                                                    WHERE {
                                                       ?instance a bf:Instance .
                                                       ?instance bf:publication ?publication .
                                                       ?publication a bf:Provider .
                                                       ?publication bf:providerPlace ?place .
                                                       ?place a bf:Place .
                                                       ?place bf:label ?publish_place .
                                                    }")

  self::PUBLISH_DATE_SPARQL_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                                  SELECT DISTINCT ?publish_date
                                                  WHERE {
                                                     ?instance a bf:Instance .
                                                     ?instance bf:publication ?publication .
                                                     ?publication a bf:Provider .
                                                     ?publication bf:providerDate ?publish_date .
                                                  }")

  self::COPYRIGHT_DATE_SPARQL_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                                    SELECT DISTINCT ?copyright_date
                                                    WHERE {
                                                       ?instance a bf:Instance .
                                                       ?instance bf:publication ?publication .
                                                       ?publication a bf:Provider .
                                                       ?publication bf:copyrightDate ?copyright_date .
                                                    }")
end