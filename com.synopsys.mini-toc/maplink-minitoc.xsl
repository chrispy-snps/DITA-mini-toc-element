<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
    -| this wedges into the "generate-all-links" template (in preprocess/maplinkImpl.xsl)
    -| to add our own child links at the end
    -->
  <xsl:template match="*[contains(@class, ' map/topicref ')]" mode="generate-all-links" priority="20">
    <!-- create the usual links (based on the args.rellinks parameter) -->
    <xsl:next-match/>

    <!-- save all child links (including @chunk="to-content" children) with @role="mini-toc" -->
    <xsl:apply-templates select="." mode="minitoc-children"/>
  </xsl:template>


  <!--
    -| this is an adaptation of the "link-to-children" template (in preprocess/maplinkImpl.xsl),
    -|  (1) that saves @chunk="to-content" children too
    -|  (2) that sets our own @role="mini-toc" value
    -->
  <xsl:template match="*" mode="minitoc-children"/>
  <xsl:template match="*[contains(@class, ' map/topicref ')]" mode="minitoc-children">
    <xsl:if test="not(@processing-role = 'resource-only') and
                  descendant::*[contains(@class, ' map/topicref ')]
                               [@href and not(@href = '')]
                               [not(@linking = ('none', 'sourceonly'))]
                               [not(@processing-role = 'resource-only')]">
      <linklist class="- topic/linklist " role="mini-toc">
        <xsl:copy-of select="@xtrf | @xtrc | @collection-type"/>
        <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="minitoc-recursive"/>
      </linklist>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' mapgroup-d/topicgroup ')]" mode="minitoc-recursive">
    <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="minitoc-recursive"/>
  </xsl:template>

  <xsl:template match="*" mode="minitoc-recursive" priority="-10">
    <xsl:apply-templates select="self::*[@href and not(@href = '')]
                                        [not(@linking = ('none', 'sourceonly'))]
                                        [not(@processing-role = 'resource-only')]"
                         mode="link">
      <xsl:with-param name="role">mini-toc</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>

