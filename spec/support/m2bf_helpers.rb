# helper methods for rspec
#  These particular methods pertain to using the marc2bibframe converter code
#    from the Library of Congress, at https://github.com/lcnetdev/marc2bibframe
#  Pre-Reqs:
#  1.  https://github.com/lcnetdev/marc2bibframe  must be cloned
#  2.  location of clone repo must be in MARC2BIBFRAME_PATH
#  3.  saxon.jar must be available
#  4.  location of saxon.jar must be in SAXON_JAR_PATH
module Helpers

  MARC2BIBFRAME_PATH = CONFIG_SETTINGS['marc2bibframe_path']
  SAXON_JAR_PATH = CONFIG_SETTINGS['saxon_jar_path']
  M2BF_BASE_URI = CONFIG_SETTINGS['base_uri']

  M2BF_SCRIPT_PATH = 'bin/convert-saxon.sh'
  URI_ARG = "-u #{M2BF_BASE_URI}"
  SZN_ARG = "-s rdfxml"
  JAR_ARG = "-j #{SAXON_JAR_PATH}"

  # given a marc record as a String containing marcxml, and a name to use for the temporary output files
  # run the marc record through the marc2bibframe converter and return the result as an RDF::Graph object
  # @param [String] marcxml_str an xml representaiton of a MARC record
  # @param [String] fname the name to assign to the marcxml and rdfxml files in the tmp directory
  # @return [RDF::Graph] loaded graph object from the converter for the marc record passed in
  def marc_to_graph_m2bf(marcxml_str, fname)
    ensure_marc_parses(marcxml_str)
    marc_path = create_marcxml_file(marcxml_str, fname)
    rdfxml_path = create_rdfxml_via_marc2bibframe(marc_path)
    load_graph_from_rdfxml(rdfxml_path)
  end

  # Call the convert-saxon.sh script in the marc2bibframe converter code.
  #  Pre-Reqs:
  #  1.  https://github.com/lcnetdev/marc2bibframe  must be cloned
  #  2.  location of clone repo must be in MARC2BIBFRAME_PATH
  #  3.  saxon.jar must be available
  #  4.  location of saxon.jar must be in SAXON_JAR_PATH
  # @param [String] the path of the marcxml file
  # @return [String] the path of the rdfxml file created
  def create_rdfxml_via_marc2bibframe(marc_path)
    output_file = marc_path.gsub('marcxml', 'rdfxml')
    command = "#{MARC2BIBFRAME_PATH}/#{M2BF_SCRIPT_PATH} #{SZN_ARG} #{URI_ARG} #{JAR_ARG} #{marc_path} #{output_file}"
    `#{command}`
    output_file
  end

end
