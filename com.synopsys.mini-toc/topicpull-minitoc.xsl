<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- delete <linkpool[@role = 'mini-toc']> -->
  <xsl:template match="linkpool[@role = 'mini-toc']"/>

  <!-- delete <related-links> that only contains mini-toc links -->
  <xsl:template match="related-links[count(*[not(@role) or @role != 'mini-toc']) = 0]"/>

  <!-- add <xref> list to end of mini-toc container -->
  <xsl:template match="*[contains(@class, '/mini-toc ') or tokenize(@outputclass, '\s+') = 'mini-toc']">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>

      <!-- get the list of links (we reuse the topicpull processing to get the link text) -->
      <xsl:variable name="links" as="element()*">
        <xsl:apply-templates select="ancestor::topic[1]/related-links/linkpool[@role = 'mini-toc']/link"/>
      </xsl:variable>
      <xsl:if test="count($links) > 0">
        <ul class="- topic/ul " paginate="keep-with-previous">
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

