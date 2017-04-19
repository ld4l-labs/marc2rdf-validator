# helper methods for rspec
#  These particular methods pertain to using the bib2lod converter code
#    from the LD4L-Labs project, at https://github.com/ld4l-labs/bib2lod
#  Pre-Reqs:
#  1.  https://github.com/ld4l-labs/bib2lod  must be cloned
#  2.  location of clone repo must be in MARC2BIBFRAME_PATH
module Helpers

  BIB2LOD_PATH = CONFIG_SETTINGS['bib2lod_path']
  BIB2LOD_CONFIG = CONFIG_SETTINGS['bib2lod_config']

  # given a marc record as a String containing marcxml, and a name to use for the temporary output files
  # run the marc record through the converter and return the result as an RDF::Graph object
  # @param [String] marcxml_str an xml representaiton of a MARC record
  # @param [String] fname the name to assign to the marcxml and rdfxml files in the tmp directory
  # @return [RDF::Graph] loaded graph object from the converter for the marc record passed in
  def marc_to_graph_bib2lod(marcxml_str, fname)
    ensure_marc_parses(marcxml_str)
    marc_path = create_marcxml_file(marcxml_str, fname)
    ntriples_path = create_ntriples_via_bib2lod(marc_path)
    load_graph_from_ntriples(ntriples_path)
  end

  # Call the bib2lod converter code.
  # @param [String] the path of the marcxml file
  # @return [String] the path of the rdfxml file created
  def create_ntriples_via_bib2lod(marc_path)
    output_file = marc_path.gsub('marcxml', 'nt')
    command = "java -jar #{BIB2LOD_PATH}/bib2lod.jar -c #{BIB2LOD_CONFIG}"
    `#{command}`
    output_file
  end

end
