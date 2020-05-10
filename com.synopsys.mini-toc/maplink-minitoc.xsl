<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="*[contains(@class, ' map/topicref ')]" mode="generate-all-links">
    <xsl:apply-templates mode="links-for-minitoc" select="."/>
    <xsl:apply-templates mode="generate-ordered-links" select="."/>
    <xsl:apply-templates mode="generate-unordered-links" select="."/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' map/topicref ')] [not(ancestor-or-self::*[contains(concat(' ', @chunk, ' '), ' to-content ')])]" mode="links-for-minitoc" name="links-for-minitoc">
    <xsl:if test="not(@processing-role = 'resource-only') and descendant::*[contains(@class, ' map/topicref ')] [@href and not(@href = '')] [not(@linking = ('none', 'sourceonly'))] [not(@processing-role = 'resource-only')]">
      <linkpool class="- topic/linkpool " role="mini-toc">
        <xsl:copy-of select="@xtrf | @xtrc | @collection-type"/>
        <xsl:apply-templates mode="recusive" select="*[contains(@class, ' map/topicref ')]"/>
      </linkpool>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>

