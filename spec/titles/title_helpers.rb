require 'linkeddata'

module TitleHelpers

  self::UNIFORM_TITLE_QUERY = SPARQL.parse("PREFIX bf: <#{RDF::Vocab::Bibframe.to_s}>
                                            SELECT DISTINCT ?titleUri ?property ?uniformTitle
                                            WHERE {
                                              ?titleUri ?property 'Beowulf.' .
                                              ?titleUri bf:titleValue ?uniformTitle
                                            }
                                           ")
end
