<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink" >
    
    <xsl:template match="*" mode="list-item">
        <li>
            <xsl:apply-templates select="*|text()"></xsl:apply-templates>
        </li>
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:param name="position"></xsl:param>
        
        <xsl:choose>
            <xsl:when test="@list-type='order'">
                <ol>
                    <xsl:apply-templates select="*">
                        <xsl:with-param name="position" select="position()"></xsl:with-param>
                    </xsl:apply-templates>
                </ol>
            </xsl:when>
            <xsl:otherwise>
                <ul>
                    <xsl:apply-templates select="*">
                        <xsl:with-param name="position" select="position()"></xsl:with-param>
                    </xsl:apply-templates>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="list-item">
        <xsl:param name="position"></xsl:param>
        
        <li>
            <xsl:apply-templates select="*|text()">
                <xsl:with-param name="position" select="position()"></xsl:with-param>
            </xsl:apply-templates>
        </li>
    </xsl:template>
    
    
</xsl:stylesheet>