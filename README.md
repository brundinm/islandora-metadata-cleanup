### *** islandora-metadata-cleanup repository ***

*MRB: Thu 02-Nov-2017*

Purpose: This repository contains items used to carry out an institutional
repository metadata cleanup operation.

Description: This repository contains workflow documentation, needed Unix
one-liner commands, XSLT (Extensible Stylesheet Language Transformations)
transform stylesheets, XSD (XML Schema Definition) schemas, and required Java
JAR (Java ARchive) files to perform a MODS (Metadata Object Description
Schema) and DC (Dublin Core) metadata cleanup operation in the Library's
former Islandora institutional repository.

The workflow sequence consisted of five distinct steps or stages:

1. Commands to batch extract MODS records from the repository
2. Commands to batch cleanup MODS and DC records
3. Commands to batch validate MODS and DC records
4. Commands to batch format and indent (pretty print) MODS and DC records
5. Commands to batch reingest and replace the MODS and DC datastreams

See the islandora-metadata-cleanup.pdf document for a detailed description of
each of the 5 steps above.

The 10 files in this repository are the following:

* cleanup_mods.xsl
    - This XSLT transform file is used in step 2 in a command to remove all of
      the empty elements and empty attributes in the MODS records.    
* dc.xsd
    - This XSD schema file is used in step 3 in a command to validate the
      the DC records; this is a local copy of a file that is referenced
      externally in the command, and so the command can be altered to utilize
      this local copy of the DC schema instead of the external schema.
* fix_mods.xsl
    - This XSLT transform file is used in step 2 in a command to fix validation
      errors as well as fix conceptual and structural errors in the MODS
      records.
* islandora-metadata-cleanup.pdf
    - This PDF fixed-layout file is used to document the 5 steps in the
      workflow, and it includes all the necessary Unix one-liner commands to 
      perform the desired MODS and DC cleanup operations.
* mods.xsd
    - This XSD schema file is used in step 3 in a command to validate the
      the MODS records; this is a local copy of a file that is referenced
      externally in the command, and so the command can be altered to utilize
      this local copy of the MODS schema instead of the external schema.
* mods_to_dc.xsl
    - This XSLT transform file is used in step 2 in a command to create full
      bibliographic DC records using the cleaned up metadata in the MODS
      records.
* README.md
    - This readme documentation file is used to provide information about each
      of the 10 files in this repository.
* saxon9he.jar
    - This Java JAR archive file is used in step 2 in a command to run the XSLT
      fix_mods.xsl stylesheet, which is an XSLT 2.0 stylesheet, so we need to
      use an XSLT processor that supports XSLT 2.0, such as the Saxon-HE XSLT
      2.0 processor (i.e., saxon9he.jar).
* serializer.jar
    - This Java JAR archive file is used indirectly in step 2 in a command to
      run the XSLT cleanup_mods.xsl stylesheet; it contains the serializer
      classes used by the xalan.jar XSLT 1.0 processor.      
* xalan.jar
    - This Java JAR archive file is used in step 2 in a command to run the
      XSLT cleanup_mods.xsl stylesheet, which is an XSLT 1.0 stylesheet, so we
      can use an XSLT 1.0 processor such as Xalan-Java (i.e., xalan.jar) or
      the C utility xsltproc.

After this metadata cleanup operation was performed, the Library later
migrated our institutional repository content from the Islandora system to
the DSpace system.  However, elements of this workflow are still useful, and
can also be modified and adapted, if we ever need to edit or validate our
DSpace items' QDC (Qualified Dublin Core) metadata.  The QDC metadata would
be exported out of DSpace, edited and validated out-of system, and then
imported back into DSpace using DSpace's SAF (Simple Archive Format) format,
with the Qualified Dublin Core metadata for each item being contained as an XML
file in each item's subdirectory in the SAF format ZIP archive directory
structure.
