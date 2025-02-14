<?xml version="1.0" encoding="UTF-8"?>

<!-- 
# DP & MRB: Fri 04-Aug-2017; last revised Wed 10-Jan-2018
# * Purpose: XSLT 1.0 stylesheet to clean up MODS records on creation or modification in
# the RO@M repository.  This two pass or two phase (i.e., multi-pass processing) XLST does
# the following:
# - removes empty elements and attributes;
# - removes <name> elements without a <namePart> child element that has text node content;
# - removes duplicate <recordContentSource> elements with a value of "AEGMT"; and
# - sorts the top-level elements so that they are in the order established by the Library
# of Congress.
# * Note: this XSLT is in version 1.0, as it needs to be processed by the Xalan-Java XSLT
# processor which is part of the Islandora stack, and the Xalan-Java XSLT processor
# implements XSLT version 1.0.
-->

<!-- Root element xsl:stylesheet with attributes to define various namespaces -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:exslt="http://exslt.org/common" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:java="http://xml.apache.org/xalan/java"
    xmlns:xalan="http://xml.apache.org/xslt">

    <!-- Element xsl:output to define the format of the MODS records output (note: @doctype-public
        attribute is a kludge so that the root mods element starts on a new line after the XML
        declaration statement [this is workaround to address an Xalan-Java XSLT processor bug]) -->
    <xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="no" indent="yes"
        xalan:indent-amount="4" doctype-public="yes"/>

    <!-- Remove any white-space-only text nodes -->
    <xsl:strip-space elements="*"/>

    <!-- First pass template to perform identity transform -->
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <!-- Second pass template to perform identity transform -->
    <xsl:template match="node()|@*" mode="mPass2">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <!-- Template to write the first pass node tree to a variable which is then
        applied to the second pass node tree -->
    <xsl:template match="/">
        <xsl:variable name="vrtfPass1Result">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:apply-templates mode="mPass2" select="exslt:node-set($vrtfPass1Result)/*"/>
    </xsl:template>

    <!-- First pass template to remove empty elements and attributes -->
    <xsl:template match="*[not(node())]"/>

    <!-- First pass template to remove the name elements without a namePart child element
        that has text node content -->
    <xsl:template match="/mods:mods/mods:name">
        <xsl:if test="./mods:namePart/text() != ''">
            <xsl:copy-of select="."/>
        </xsl:if>
    </xsl:template>

    <!-- First pass template to remove the duplicate recordInfo/recordContentSource elements with
         a text node value of "AEGMT", i.e., only the first recordContentSource element with
         a value of "AEGMT" will be retained -->
    <xsl:template
        match="/mods:mods/mods:recordInfo/mods:recordContentSource[@authority='marcorg'][text()='AEGMT']">
        <xsl:if test="not (preceding-sibling::mods:recordContentSource/text() = current()/text())">
            <xsl:copy>
                <xsl:apply-templates select="node()|@*"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <!-- Second pass template to copy output of first pass into the node tree for the second pass -->
    <xsl:template match="/*" mode="mPass2">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="mPass2"/>
        </xsl:copy>
    </xsl:template>

    <!-- Second pass variable to establish Library of Congress prescribed sort order for top-level
        elements -->
    <xsl:variable name="vOrdered"
        select="'|titleInfo|name|typeOfResource|genre|originInfo|language|physicalDescription|abstract|tableOfContents|targetAudience|note|subject|classification|relatedItem|identifier|location|accessCondition|part|extension|recordInfo|'"/>

    <!-- Second pass template to sort top-level elements in prescribed Library of Congress order -->
    <xsl:template match="/mods:mods" mode="mPass2">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*">
                <xsl:sort select="substring-before($vOrdered, concat('|',name(),'|'))"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
