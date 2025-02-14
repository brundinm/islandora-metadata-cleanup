<?xml version="1.0" encoding="UTF-8"?>

<!--
    MRB: Fri 10-Mar-2017; last revised Wed 02-Aug-2017
    - XSLT to fix the MODS validation errors, as well as the structural and
    conceptual issues with some of the elements and attributes.
    - The MODS validation errors occur in six elements: languageOfCataloging,
    name, partNumber, physicalDescription, role, and typeOfResource.
    - The structural and conceptual issues occur with the language,
    recordContentSource, role, roleTerm, and subject elements.
    - Approach to fix the validation errors and conceptual/structural issues is
    to first use an identity transform template, and then use various override
    templates to address the errors and issues.
    - Note: because the source MODS XML files are all invalid, need to use a
    non-schema-aware parser such as Saxon-HE in the transformation, as opposed
    to a schema-aware parser like Saxon-EE which won't process the source files
    because they are invalid with respect to the MODS schema.
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3"
    xpath-default-namespace="http://www.loc.gov/mods/v3">

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <!-- Remove any white-space-only text nodes -->
    <xsl:strip-space elements="*"/>

    <!-- Perform identity transform -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- *** Validation errors templates *** -->

    <!-- Validation error: Fix for the languageOfCataloging element errors; need to move content
        into new child languageTerm element -->
    <xsl:template match="mods/recordInfo/languageOfCataloging[not(languageTerm)]">
        <languageOfCataloging>
            <languageTerm authority="iso639-2b">
                <xsl:value-of select="normalize-space(.)"/>
            </languageTerm>
        </languageOfCataloging>
    </xsl:template>

    <!-- Validation error: Fix for the name element errors; need to move content into new child
        namePart element -->
    <xsl:template match="mods/name[@type='personal'][not(namePart)]/text()">
            <namePart>
                <xsl:value-of select="normalize-space(.)"/>
            </namePart>
    </xsl:template>

    <!-- Validation error: Fix for the partNumber element errors; need to remove @type attribute -->
    <xsl:template match="mods/relatedItem/titleInfo/partNumber/@type"/>

    <!-- Validation error: Fix for the physicalDescription element errors; need to remove @authority
        attribute from physicalDescription element, and move content into new child form element
        with @authority attribute with value of "local" -->
    <xsl:template match="mods/physicalDescription/@authority"/>
    <xsl:template match="mods/physicalDescription[not(form)]">
        <xsl:if test=".[not(text())]">
            <physicalDescription>
                <xsl:apply-templates select="@*|node()"/>
            </physicalDescription>
        </xsl:if>
        <xsl:if test="./text() != ''">
            <physicalDescription>
                <xsl:apply-templates select="@*|node()"/>
                <form authority="local">
                    <xsl:value-of select="./text()"/>
                </form>
            </physicalDescription>
        </xsl:if>
    </xsl:template>
    <xsl:template match="mods/physicalDescription/text()"/>

    <!-- Validation error: Fix for the role element errors; need to add a child roleTerm element -->
    <xsl:template match="mods/name/role[not(roleTerm)]">
        <role>
            <roleTerm/>
        </role>
    </xsl:template>

    <!-- Validation errors: Fix for the two typeOfResource element errors; need to correct the two strings
        from the enumerated list of values that have spaces around the hyphen -->
    <xsl:template match="mods/typeOfResource/text()">
        <xsl:if
            test="normalize-space(.) != 'sound recording - musical' and normalize-space(.) != 'sound recording - nonmusical'">
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:if>
        <xsl:if test="normalize-space(.) = 'sound recording - musical'">
            <xsl:text>sound recording-musical</xsl:text>
        </xsl:if>
        <xsl:if test="normalize-space(.) = 'sound recording - nonmusical'">
            <xsl:text>sound recording-nonmusical</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- *** Structural/conceptual issues templates *** -->

    <!-- Structural/conceptual issue: Fix for the languageOfCataloging/languageTerm element issue; need to remove the duplicate
        languageOfCataloging/languageTerm elements that contain the same content of "eng" in the text node
        after the languageOfCataloging element fix (uses Muenchian grouping) -->
    <xsl:key name="duplanguageTerm" match="recordInfo/languageOfCataloging"
        use="concat(generate-id(..), '|', .)"/>
    <xsl:template
        match="recordInfo/languageOfCataloging[not(generate-id() = generate-id(key('duplanguageTerm', concat(generate-id(..), '|', .))[1]))]"/>

    <!-- Structural/conceptual issue: Fix for the recordContentSource element issue; need to remove the duplicate
        recordContentSource elements that contain the same content of "AEGMT" in the text node (uses Muenchian grouping) -->
    <xsl:key name="duprecordContentSource" match="recordInfo/recordContentSource"
        use="concat(generate-id(..), '|', .)"/>
    <xsl:template
        match="recordInfo/recordContentSource[not(generate-id() = generate-id(key('duprecordContentSource', concat(generate-id(..), '|', .))[1]))]"/>

    <!-- Structural/conceptual issue: Fix for the roleTerm element issue; need to remove the duplicate
        roleTerm elements that contain the same content of "Faculty Advisor" in the text node (uses Muenchian grouping) -->
    <xsl:key name="duproleTerm" match="name/role"
        use="concat(generate-id(..), '|', .)"/>
    <xsl:template
        match="name/role[not(generate-id() = generate-id(key('duproleTerm', concat(generate-id(..), '|', .))[1]))]"/>
    
</xsl:stylesheet>
