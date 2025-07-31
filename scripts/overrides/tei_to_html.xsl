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
  <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="no"/>
  
  <!-- Special styling for handlist, which will be rendered with datatables JS 
    framework. this code uses named templates at bottom of document-->
  <xsl:template match="/TEI[@xml:id='anc.02129']">
    <div id="metadata">
      <xsl:apply-templates select="//div1[@type='section']"></xsl:apply-templates>
    </div>
    <div class="datatable_div">
      <table class="table-sortable handlist-table">
        <thead>
          <tr class="handlist_row">
            <th class="handlist_collapse">Title</th>
            <th class="handlist_collapse">Author</th>
            <th class="handlist_collapse">Publication Date</th>
            <th class="handlist_collapse">Reading Date</th>
            <th class="handlist_collapse">Notes</th>
            <th class="handlist_collapse">Evidence</th>
            <th class="handlist_collapse">Link to Resource</th>
          </tr>
        </thead>
        <tbody>
            <xsl:for-each select="//text//bibl">
              <tr class="handlist_row handlist_data_row">
                  <!-- Title -->
                  <xsl:variable name="handlist_title">
                    <xsl:choose>
                      <xsl:when test="descendant::title[@level='a']">
                        <xsl:call-template name="periodical"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:call-template name="monograph"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <xsl:variable name="handlist_title_present">
                    <xsl:choose>
                      <xsl:when test="normalize-space($handlist_title) != ''">handlist_title</xsl:when>
                      <xsl:otherwise>handlist_collapse</xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <td class="{$handlist_title_present}">
                    <span style="display:none" aria-hidden="true">
                      <xsl:call-template name="normalize_name">
                        <xsl:with-param name="string">
                          <xsl:value-of select="$handlist_title"/>
                        </xsl:with-param>
                      </xsl:call-template>
                    </span>
                    <xsl:copy-of select="$handlist_title"/>
                </td>
                <!-- END title -->
                <td class="handlist_author"><xsl:apply-templates select="author"/></td>
                <td class="handlist_pubdate"><xsl:apply-templates select="date[@type='publicationDate']"/></td>
                <td class="handlist_readdate"><xsl:apply-templates select="date[@type='readingDate']"/></td>
                <td class="handlist_notes"><xsl:apply-templates select="note[@type='comments']"/></td>
                <td class="handlist_evidence"><xsl:apply-templates select="note[@type='source']"/></td>
                <td class="handlist_collapse">
                  <a>
                    <xsl:attribute name="href">
                      <xsl:value-of select="idno[@type='wwa']"/>
                    </xsl:attribute>
                    <xsl:value-of select="idno[@type='wwa']"/>
                  </a>
                </td>
              </tr>
            </xsl:for-each>
          
        </tbody>
        
      </table>
    </div>
    
  </xsl:template>
  
  <!-- add overrides for this section here -->
  
  <xsl:variable name="top_metadata">
    <ul>
      <!-- <li><strong>Title: </strong> <xsl:value-of select="//title[@type='main']"/></li>
      <li><strong>Creator(s): </strong> <xsl:value-of separator=", " select="//titleStmt/author"/></li> -->
     
     <!-- date -->
      <!-- <xsl:choose>
        <xsl:when test="/TEI/text/@type = 'annotations'">
          <xsl:if test="descendant::sourceDesc/bibl[not(@type='pasteon')]/date">
            <li><strong>Date: </strong>
              <xsl:value-of
                select="/TEI/teiHeader/fileDesc/sourceDesc/bibl[1][not(@type='pasteon')]/date"/>
            </li>
          </xsl:if>
        </xsl:when>
        <xsl:when test="/TEI/text/@type = 'marginalia'">
          <xsl:if test="descendant::sourceDesc/bibl[not(@type='pasteon')]/date">
            <li>
              <strong>Annotation Date: </strong>
                <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/bibl[1][not(@type='pasteon') and not(@type='base')]/date"/>
            </li>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>no date</xsl:otherwise>
      </xsl:choose> -->
     
      <!-- base document cition -->
      <!-- I think this only applies to marginalia -->
      <xsl:if test="/TEI/text/@type = 'marginalia'">
        <xsl:if test="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']">
          <xsl:choose>
            <xsl:when test="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/title[@level='j']">
              <li><strong>Base Document Citation: </strong>
              <xsl:value-of select="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/author"/>
                <xsl:text>, "</xsl:text>
                <xsl:value-of select="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/title[@level='a']"/>
                <xsl:text>," </xsl:text>
                <em><xsl:value-of select="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/title[@level='j']"/></em>
                <xsl:if test="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/biblScope[@type='vol']">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/biblScope[@type='vol']"/>
                </xsl:if>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/date"/>
                <xsl:text>)</xsl:text>
                <xsl:if test="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/biblScope[@type='pp']">
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/biblScope[@type='pp']"/>
                </xsl:if>
                <xsl:text>.</xsl:text>
              </li>
            </xsl:when>
            <xsl:otherwise>
              <li><strong>Base Document Citation: </strong>
              <xsl:value-of select="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/author"/>
                <xsl:text>, </xsl:text>
                <em><xsl:value-of select="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/title"/>
                </em>
                <xsl:if test="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/editor">
                  <xsl:text>, ed. </xsl:text>
                  <xsl:value-of select="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/editor"/>
                </xsl:if>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/pubPlace"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="descendant::sourceDesc/bibl[not(@type='pasteon')][@type='base']/date"/>
                <xsl:text>).</xsl:text>
              </li>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:if>
      
      
      <!-- <li><strong>Whitman Archive ID: </strong> <xsl:value-of select="//teiHeader/fileDesc/publicationStmt/idno"/></li> -->
      
      <li><strong>Source: </strong> 
        
        <xsl:choose>
          <xsl:when test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct[not(@type='supplied')]">
            <xsl:text>The transcription presented here is derived from </xsl:text> 
            <!-- if author -->
            <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/author">
              <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/author"/>
              <xsl:text>, </xsl:text>
            </xsl:if>
            <!-- monograph title -->
            <em><xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/title"/></em>
            <!-- if editor // todo: simplify, should work if more than 2 editors -->
            <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor">
              <xsl:text>, ed. </xsl:text>
              <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[1]"/>
              <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[2]">
                <xsl:text> and </xsl:text>
                <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr/editor[2]"/>
              </xsl:if>
            </xsl:if>
            <!-- publisher and date -->
            <xsl:text> (</xsl:text>
            <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//pubPlace"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//publisher"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//date"/>
            <xsl:text>)</xsl:text>
            <xsl:text>, </xsl:text>
            <!-- if volume -->
            <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@type='volume']">
              <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@type='volume']"/>
              <xsl:text>:</xsl:text>
            </xsl:if>
            <!-- page -->
            <xsl:value-of select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/monogr//biblScope[@unit='page']"/>
            <xsl:text>. </xsl:text>
            <!-- project -->
            <xsl:if test="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/note[@type='project']">
              <xsl:apply-templates select="TEI/teiHeader/fileDesc/sourceDesc/biblStruct/note[@type='project']"/>
            </xsl:if>
            <xsl:text> </xsl:text>
            <!-- orgname // dodo: simplify -->
            <xsl:value-of select="TEI//sourceDesc//bibl[1]/orgName"/>
            <xsl:if test="TEI//sourceDesc//bibl[2]/orgName">
              <xsl:text>; </xsl:text>
              <xsl:value-of select="TEI//sourceDesc//bibl[2]/orgName"/>
            </xsl:if>
          </xsl:when>
          <!-- orgname // not sure if this will ever hit for manuscripts -->
          <xsl:otherwise>
            <xsl:value-of select="//TEI//sourceDesc//bibl[1]/orgName"/>
            <xsl:if test="TEI//sourceDesc//bibl[2]/orgName">
              <xsl:text>; </xsl:text>
              <xsl:value-of select="TEI//sourceDesc//bibl[2]/orgName"/>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        
        <!-- orgname // todo: simplify -->
        <xsl:choose>
          <xsl:when test="count(//TEI//sourceDesc//bibl) > 1 and //tei//sourceDesc//bibl[2]/orgname">
            <xsl:if test="not(ends-with(//TEI//sourceDesc//bibl[2]/orgName, '.'))">
              <xsl:text>.</xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="not(ends-with(//TEI//sourceDesc//bibl[1]/orgName, '.'))">
              <xsl:text>.</xsl:text>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>  </xsl:text>
        
        <!-- project -->
        <xsl:apply-templates select="//TEI//sourceDesc//bibl[1]/note[@type = 'project'][not(@target)]"/>
        
        <!-- editorial statement -->
        <xsl:text> For a description of the editorial rationale behind our treatment of the manuscripts, see our </xsl:text>
        <a>
          <xsl:attribute name="href">
            <xsl:text>../about/editorial-policies#marginalia</xsl:text>
          </xsl:attribute>
          <xsl:text>statement of editorial policy</xsl:text>
        </a>
        <xsl:text>.</xsl:text>
      </li>
      
      <xsl:if test="//teiHeader/fileDesc/notesStmt/note[@type='project']">
        <li><strong>Editorial note: </strong><xsl:apply-templates select="//teiHeader/fileDesc/notesStmt/note[@type='project']"/> </li>
      </xsl:if>
      
      <!-- pulled from notebooks P5 tylesheet and refactored original comment: relatedItem section (updated 4/28/17)-->
      <xsl:if test="//sourceDesc//relatedItem">
        <li><strong>Related Item(s): </strong>
          <ul>
            <xsl:for-each select="//relatedItem[@type = 'text']">
              <li>
                <xsl:variable name="note_target"><xsl:text>#</xsl:text><xsl:value-of select="@xml:id"/></xsl:variable>
                <!-- if there is a note with a matching target, display -->
                <xsl:apply-templates select="//note[@target=$note_target]"/>
                <xsl:text> See </xsl:text>
                <a>
                  <xsl:attribute name="href" select="@target"/>
                  <xsl:value-of select="@target"/>
                </a>
                <xsl:text>.</xsl:text></li>
            </xsl:for-each>
          </ul>          
        </li>
      </xsl:if>
      
      <xsl:if test="//text//note[@type='editorial']">
        
        <li><strong>Notes written on manuscript: </strong>
          
          <xsl:for-each select="//text//note[@type='editorial']">
            <xsl:choose>
              <xsl:when test="following::note[@type='editorial'] and not(preceding::note[@type='editorial'])">On surface <xsl:value-of select="count(preceding::pb)"/><xsl:if test="substring-after(@resp,'#')=preceding::handNote[@scribeRef='#ht']/@xml:id">, in the hand of Horace Traubel</xsl:if>
                <xsl:if test="substring-after(@resp,'#')=preceding::handNote[@scribeRef='#unk']/@xml:id">, in an unknown hand</xsl:if><xsl:text>: "</xsl:text><xsl:apply-templates/><xsl:text>"; </xsl:text>
              </xsl:when>
              <xsl:when test="following::note[@type='editorial'] and preceding::note[@type='editorial']">on surface <xsl:value-of select="count(preceding::pb)"/><xsl:if test="substring-after(@resp,'#')=preceding::handNote[@scribeRef='#ht']/@xml:id">, in the hand of Horace Traubel</xsl:if>
                <xsl:if test="substring-after(@resp,'#')=preceding::handNote[@scribeRef='#unk']/@xml:id">, in an unknown hand</xsl:if><xsl:text>: "</xsl:text><xsl:apply-templates/><xsl:text>"; </xsl:text>
              </xsl:when>
              <xsl:when test="preceding::note[@type='editorial']">on surface <xsl:value-of select="count(preceding::pb)"/><xsl:if test="substring-after(@resp,'#')=preceding::handNote[@scribeRef='#ht']/@xml:id">, in the hand of Horace Traubel</xsl:if>
                <xsl:if test="substring-after(@resp,'#')=preceding::handNote[@scribeRef='#unk']/@xml:id">, in an unknown hand</xsl:if><xsl:text>: "</xsl:text><xsl:apply-templates/><xsl:text>"</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                On surface <xsl:value-of select="count(preceding::pb)"/><xsl:if test="substring-after(@resp,'#')=preceding::handNote[@scribeRef='#ht']/@xml:id">, in the hand of Horace Traubel</xsl:if>
                <xsl:if test="substring-after(@resp,'#')=preceding::handNote[@scribeRef='#unk']/@xml:id">, in an unknown hand</xsl:if><xsl:text>: "</xsl:text><xsl:apply-templates/><xsl:text>"</xsl:text>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </li>
      </xsl:if>
      
      <!-- <li><strong>Contributors to digital file: </strong> <xsl:value-of separator=", " select="//teiHeader/fileDesc/titleStmt/respStmt/persName"></xsl:value-of></li> -->
    </ul>
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
      <xsl:text>[begin surface </xsl:text>
      <!--<xsl:value-of select="count(//pb)"/>-->
      <xsl:number format="1" level="any"/>
      <xsl:text>]</xsl:text>
      
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

  <!--Named templates-->
  <xsl:template name="periodical">
    <!-- Title -->
    <xsl:if test="descendant::author != ''"><xsl:value-of select="descendant::author"/>
      <xsl:choose><xsl:when test="substring(descendant::author,string-length(descendant::author),1)='.'"><xsl:text> </xsl:text></xsl:when><xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise></xsl:choose>
    </xsl:if>
    <xsl:if test="descendant::editor[not(@role)] and descendant::author =''"><xsl:value-of select="descendant::editor[not(@role)]"/>
      <xsl:text>, ed. </xsl:text></xsl:if>
    <xsl:text>"</xsl:text>
    <xsl:value-of select="descendant::title[@level='a']"/><xsl:text>." </xsl:text>
    <xsl:if test="descendant::editor[not(@role)] and descendant::author !=''"><xsl:text>Ed. </xsl:text><xsl:value-of select="descendant::editor[not(@role)]"/><xsl:text>. </xsl:text>
    </xsl:if>
    <xsl:if test="descendant::editor[@role='translator']"><xsl:text>Trans. </xsl:text><xsl:value-of select="descendant::editor[@role='translator']"/>
      <xsl:text>. </xsl:text></xsl:if>
    <xsl:if test="descendant::edition"><xsl:value-of select="descendant::edition"/><xsl:text>. </xsl:text></xsl:if>
    <xsl:if test="descendant::pubPlace != ''">
      <xsl:text>(</xsl:text><xsl:value-of select="descendant::pubPlace"/><xsl:text>)</xsl:text>
    </xsl:if>
    <xsl:text> </xsl:text>
    <xsl:if test="descendant::title[@level='j'] != ''"><span>
      <em><xsl:value-of select="descendant::title[@level='j']"/></em>
    </span></xsl:if>
    <xsl:if test="descendant::biblScope[@type='vol']"><xsl:text> </xsl:text><xsl:value-of select="descendant::biblScope[@type='vol']"/><xsl:text>  </xsl:text></xsl:if>
    <xsl:text> </xsl:text>
    
    
    <xsl:if test="descendant::date[@type='publicationDate'] != ''">(<xsl:value-of select="descendant::date[@type='publicationDate']"/>
      <xsl:choose> 
        <xsl:when test="descendant::biblScope[@type='pages']"><xsl:text>): </xsl:text></xsl:when>
        <xsl:otherwise>). </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="descendant::biblScope[@type='pages'] != ''"><xsl:value-of select="descendant::biblScope[@type='pages']"/><xsl:text>. </xsl:text></xsl:if>
  </xsl:template>
  
  <xsl:template name="monograph">
    <!-- Title -->
    <xsl:if test="descendant::author != ''"><xsl:value-of select="descendant::author"/>
      <xsl:choose><xsl:when test="substring(descendant::author,string-length(descendant::author),1)='.'"><xsl:text> </xsl:text></xsl:when><xsl:otherwise><xsl:text>. </xsl:text></xsl:otherwise></xsl:choose>
    </xsl:if>
    <xsl:if test="descendant::editor[not(@role)] and descendant::author =''"><xsl:value-of select="descendant::editor[not(@role)]"/>
      <xsl:text>, ed. </xsl:text></xsl:if>
    <em><xsl:value-of select="descendant::title[@level='m']"/></em>
    <xsl:text>. </xsl:text>
    <xsl:if test="descendant::editor[not(@role)] and descendant::author !=''"><xsl:text>Ed. </xsl:text><xsl:value-of select="descendant::editor[not(@role)]"/><xsl:text>. </xsl:text>
    </xsl:if>
    <xsl:if test="descendant::editor[@role='translator']"><xsl:text>Trans. </xsl:text><xsl:value-of select="descendant::editor[@role='translator']"/>
      <xsl:text>. </xsl:text></xsl:if>
    <xsl:if test="descendant::edition"><xsl:value-of select="descendant::edition"/><xsl:text>. </xsl:text></xsl:if>
    <xsl:if test="descendant::pubPlace != ''">
      <xsl:value-of select="descendant::pubPlace"/>
      <xsl:text>: </xsl:text>
    </xsl:if>     
    <xsl:if test="descendant::publisher != ''">
      <xsl:value-of select="descendant::publisher"/><xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:if test="descendant::date[@type='publicationDate'] != ''"><xsl:value-of select="descendant::date[@type='publicationDate']"/>.</xsl:if>
  </xsl:template>
  
  <xsl:template name="normalize_name">
    <xsl:param name="string"/>
    
    <xsl:variable name="string_lower"><xsl:value-of select="normalize-space(translate(lower-case($string), '“‘&quot;&apos;&apos;[]{}()', ''))"/></xsl:variable>
    
    <xsl:choose>
      <xsl:when test="starts-with($string_lower, 'a ')">
        <xsl:value-of select="substring-after($string_lower, 'a ')"></xsl:value-of>
      </xsl:when>
      <xsl:when test="starts-with($string_lower, 'the ')">
        <xsl:value-of select="substring-after($string_lower, 'the ')"></xsl:value-of>
      </xsl:when>
      <xsl:when test="starts-with($string_lower, 'an ')">
        <xsl:value-of select="substring-after($string_lower, 'an ')"></xsl:value-of>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string_lower"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>



</xsl:stylesheet>
