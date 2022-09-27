<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:whitman="http://www.whitmanarchive.org/namespace"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0"
  exclude-result-prefixes="xsl tei xs whitman">
  
  <!-- ==================================================================== -->
  <!--                             IMPORTS                                  -->
  <!-- ==================================================================== -->
  
  <xsl:import href="../.xslt-datura/tei_to_html/tei_to_html.xsl"/>
  <xsl:import href="../../../whitman-scripts/scripts/archive-wide/overrides.xsl"/>
  
  <!-- For display in TEI framework, have changed all namespace declarations to http://www.tei-c.org/ns/1.0. If different (e.g. Whitman), will need to change -->
  <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
  
  <!-- add overrides for this section here -->
  
  <xsl:variable name="top_metadata">
    <ul><li>Metadata for Marginalia goes here</li></ul>
  </xsl:variable>

    <!-- PB's -->
  
  <!-- todo: check to see if this still needs to be specific, or if I could add more classes to datura -->
  <xsl:template match="pb">
    <!-- grab the figure id from @facs, and if there is a .jpg, chop it off
          note: I previously also looked at xml:id for figure ID, but that's 
          incorrect -->
    <xsl:variable name="figure_id">
      <xsl:variable name="figure_id_full">
        <xsl:value-of select="normalize-space(@facs)"/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="ends-with($figure_id_full, '.jpg') or ends-with($figure_id_full, '.jpeg')">
          <xsl:value-of select="substring-before($figure_id_full, '.jp')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$figure_id_full"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <span>
      <xsl:attribute name="class">
        <xsl:text>hr </xsl:text>
        <xsl:call-template name="add_attributes"></xsl:call-template>
      </xsl:attribute>
      &#160;
      <!-- if pb/@xml:id begins with "leaf" add language that looks like leaf 1 recto, leaf 1 verso, leaf 2 recto, etc -->
      <xsl:if test="starts-with(@xml:id,'leaf')">
        <xsl:variable name="id" select="@xml:id"/>
        <xsl:variable name="page"><xsl:value-of select="xs:decimal(substring(substring-after(@xml:id,'leaf'),1,3))"/></xsl:variable>
        <xsl:variable name="last_character" select="substring(@xml:id,8,8)"/>
        <xsl:variable name="rectoverso">
          <xsl:choose>
            <xsl:when test="$last_character = 'r'">recto</xsl:when>
            <xsl:when test="$last_character = 'v'">verso</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:text>[begin leaf </xsl:text>
        <xsl:value-of select="$page"></xsl:value-of>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$rectoverso"/>
        <xsl:text>]</xsl:text>
      </xsl:if>
    </span>
    <xsl:if test="$figure_id != ''">
      <span>
        <xsl:attribute name="class">
          <xsl:text>pageimage</xsl:text>
        </xsl:attribute>
        <a>
          <xsl:attribute name="href">
            <xsl:call-template name="url_builder">
              <xsl:with-param name="figure_id_local" select="$figure_id"/>
              <xsl:with-param name="image_size_local" select="$image_large"/>
              <xsl:with-param name="iiif_path_local" select="$collection"/>
            </xsl:call-template>
          </xsl:attribute>
          <xsl:attribute name="rel">
            <xsl:text>prettyPhoto[pp_gal]</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="title">
            <xsl:text>&lt;a href=&#34;</xsl:text>
            <xsl:call-template name="url_builder_escaped">
              <xsl:with-param name="figure_id_local" select="$figure_id"/>
              <xsl:with-param name="image_size_local" select="$image_large"/>
              <xsl:with-param name="iiif_path_local" select="$collection"/>
            </xsl:call-template>
            <xsl:text>" target="_blank" &gt;open image in new window&lt;/a&gt;</xsl:text>
          </xsl:attribute>
          
          <img>
            <xsl:attribute name="src">
              <xsl:call-template name="url_builder">
                <xsl:with-param name="figure_id_local" select="$figure_id"/>
                <xsl:with-param name="image_size_local" select="$image_thumb"/>
                <xsl:with-param name="iiif_path_local" select="$collection"/>
              </xsl:call-template>
            </xsl:attribute>
            <xsl:attribute name="class">
              <xsl:text>display&#160;</xsl:text>
            </xsl:attribute>
          </img>
        </a>
      </span>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
