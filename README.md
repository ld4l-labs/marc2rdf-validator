[![Dependency Status](https://gemnasium.com/sul-dlss/bibframe-work-validation.svg)](https://gemnasium.com/sul-dlss/bibframe-work-validation)
[![Dependency Status](https://gemnasium.com/sul-dlss/marc-to-bibframe-validation.svg)](https://gemnasium.com/sul-dlss/marc-to-bibframe-validation)

# Marc to Bibframe Validation

This project is focused on validating particulars of bibframe graphs produced from MARC data.  Ruby RSpec is used as a means of validating the properties of data in the Bibframe model.  We want evaluation code that can be run against bibframe resources to determine the quality of the conversion process.

This project should help us evaluate the quality of bibframe produced by different converters. https://github.com/lcnetdev/marc2bibframe is the current reference implementation, but we expect other converters will appear.  This project provides a framework for calling external converter code to convert a single MARC record to an RDF::Graph object; the framework then provides tests for evaluating the resulting graph.

# Approach

In order to make these tests agnostic for marc -> bibframe processing, the idea is that a helper method will be provided to get from an inline (known) marc record (as marcxml) to an RDF::Graph object holding bibframe triples.

For example, look at spec/support/m2bf_xquery_helpers.rb.  This class provides the marc_to_graph_m2bf_xquery method.

# Install and Configure
To run the specs, the config.yml file must have the appropriate configuration information for the helper method that will be used.

For example, a config.yml to use the marc_to_graph_m2bf_xquery method is:

    # configuration settings for bibframe validation
    helper_method: marc_to_graph_m2bf_xquery

    # Settings for marc2bibframe LoC xquery converter
    #   see spec/support/m2bf_xquery_helpers.rb
    # location of clone repo from git@github.com:lcnetdev/marc2bibframe.git
    marc2bibframe_path: /path/to/marc2bibframe
    # location of saxon jar
    saxon_jar_path: /path/to/saxon.jar
    # base URI to use for fake urls created
    base_uri: http://example.org/

You may also need to make local changes to marc2bibframe/bin/convert-saxon.sh:

- Replace all `readlink -e $1` with just '$1'
```
#MARCPATH=`readlink -e $1`
MARCPATH=$1
```
- Replace all `readlink -e $2` with just '$2'
```
#OUTPUT=`readlink -f $2`
OUTPUT=$2
```
- Add the argument 'usebnodes=false' (or `true` if you want blank nodes) to the java command:
```
BN_ARG='usebnodes=false'
```
```
java -cp $SAXON_JAR net.sf.saxon.Query $MYDIR/../xbin/saxon.xqy marcxmluri="$MARCPATH" baseuri="$BASEURI" serialization="$SERIALIZATION" usebnodes=false 1>$OUTPUT
```
In order to suppress the xquery error messages, in /marc2bibframe/xbin/saxon.xqy (: comment out :) all the lines with 'declare option saxon:default'

The helper_method property is required by the individual specs; the other properties are specific to the m2bf_xquery_helpers: https://github.com/sul-dlss/marc-to-bibframe-validation/blob/master/spec/support/m2bf_xquery_helpers.rb#L11-L13:

    MARC2BIBFRAME_PATH = CONFIG_SETTINGS['marc2bibframe_path']
    SAXON_JAR_PATH = CONFIG_SETTINGS['saxon_jar_path']
    BASE_URI = CONFIG_SETTINGS['base_uri']

# The specs

Given known marc data, we should be able to describe exactly what we expect to be present in bibframe.

For example, we may know that a certain marc record should produce 4 works, with one instance for each work.  Another marc record might have only 1 work and 1 instance.

We also know that we would like to reconcile a work generated by a converter against existing works in existing RDF data, so data that facilitates this (e.g. standard numbers, titles, creators, publisher, pub date ...) is highly desirable as well.  Given specific marc data, we can test for specific information in titles, standard numbers, etc. in the produced bibframe graph.

# The data

See spec/fixtures

xxx.marcxml are MARC records from Stanford - provided for reference and for use by conversion programs.

xxx.rdfxml is the output from https://github.com/lcnetdev/marc2bibframe run against the .marcxml records

xxx.ttl is a turtle representation of the same data as the .rdfxml file -- provided for human readability.

The specific marc records were chosen to try to exercise different wrinkles in work/instance information present in a single marc record.  As new work-instance wrinkles are surfaced, marc records and specs should be added to the project.

# Importing LoC Bib marcxml Records via SRU

1. Create a csv documents in the /docs folder:
    /import/m2b-classes.csv
        With header columns 'className' and 'bibid'
    /import/m2b-properties.csv
        With header columns 'propertyName' and 'bibid'

2. From within the /lib folder:

```bash
 'ruby m2b_csv.rb'
```
  and marcxml records from the LoC SRU service will be written to spec/fixtures/loc/(className|propertyName)/(bibid).marcxml.

# Working with other converters

1. Create a xxx_helper.rb file in the spec/support folder:

    Module Helpers
        def marc_to_graph_my_converter(marcxml_str, param)
          a = method1
          graph = method2(a)
        end

        def method1
        end

        def method2
        end
    end

2. Have a method in your xxx_helper.rb file that takes marcxml as a string, a second argument (which can be ignored or used), and returns an RDF::Graph object loaded with the bibframe triples created by the converter for the passed marc.
3. Require your new helper file in spec/spec_helper.rb
4. config.yml should work when your method name from 2. is used as the value for helper_method.  If you need additional information (e.g. path to your converter), add it to config.yml and access the info via CONFIG_SETTINGS in your helper file.

spec/support/m2bf_xquery_helpers.rb is an exemplar.

# Contributing

1. Fork the repository.
2. Create a branch in your fork for your edits.
3. Create a new Pull Request.  (https://help.github.com/articles/using-pull-requests/)
    - be clear about what problem the pull request is addressing
