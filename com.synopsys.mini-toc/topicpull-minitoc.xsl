<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
    -| delete <linklist role="mini-toc">
    -->
  <xsl:template match="linklist[@role = 'mini-toc']"/>

  <!--
    -| delete <related-links> that contain only mini-toc links
    -->
  <xsl:template match="related-links[count(*[not(@role) or @role != 'mini-toc']) = 0]"/>

  <!--
    -| add <xref> list to end of any mini-toc containers
    -->
  <xsl:template match="*[contains(@class, '/mini-toc ') or tokenize(@outputclass, '\s+') = 'mini-toc']">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>

      <!-- create the list of links (we reuse the topicpull processing to get the link text) -->
      <xsl:variable name="links" as="element()*">
         <xsl:apply-templates select="ancestor::*[contains(@class, 'topic/topic')][1]/related-links/linklist[@role = 'mini-toc']/link"/>
      </xsl:variable>
      <xsl:if test="count($links) > 0">
        <ul class="- topic/ul " outputclass="mini-toc-list">
          <xsl:for-each select="$links">
            <li class="- topic/li ">
              <xref class="- topic/xref ">
                <xsl:apply-templates select="@href | @type"/>
                <xsl:value-of select="./linktext"/>  <!-- this should always resolve for valid links -->
              </xref>
            </li>
          </xsl:for-each>
        </ul>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>

