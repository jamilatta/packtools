<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">

    <xsl:template match="article" mode="article-text-sub-articles">
        <xsl:apply-templates select="response[@xml:lang=$TEXT_LANG] | sub-article[@xml:lang=$TEXT_LANG and @article-type!='translation']"></xsl:apply-templates>
    </xsl:template>

    <xsl:template match="front-stub/aff | article/*/front/aff |front-stub/history | article/*/front/history ">
        
    </xsl:template>
    <xsl:template match="front-stub//subject | article/*/front//subject">
        <h1>
            <xsl:apply-templates select="*|text()"></xsl:apply-templates>
        </h1>
    </xsl:template>
    <xsl:template match="front-stub//article-title | article/*/front//article-title">
        <h2>
            <xsl:apply-templates select="*|text()"></xsl:apply-templates>
        </h2>
    </xsl:template>
    <xsl:template match="front-stub//trans-title | article/*/front//trans-title">
        <h3>
            <xsl:apply-templates select="*|text()"></xsl:apply-templates>
        </h3>
    </xsl:template>
    <xsl:template match="sub-article[@article-type!='translation'] | response">
        <div class="articleSection">
            <xsl:attribute name="data-anchor"><xsl:apply-templates select="." mode="data-anchor"></xsl:apply-templates></xsl:attribute>
            <a name="articleSection{$body_index + $q_back + $q_body_fn + 1 + position()}"/>
            <xsl:apply-templates select="*|text()"></xsl:apply-templates>      
        </div>
        <xsl:apply-templates select="front-stub | front" mode="generic-history"></xsl:apply-templates>
    </xsl:template>
    <xsl:template match="sub-article[@article-type!='translation'] | response" mode="data-anchor">
        <xsl:apply-templates select=".//subject"></xsl:apply-templates>
        <xsl:if test="not(.//subject)">
            <xsl:apply-templates select=".//article-title"></xsl:apply-templates>
            <xsl:if test="not(.//article-title)">
                <xsl:value-of select="@article-type"/>
                <xsl:if test="not(@article-type)">
                    <xsl:value-of select="@response-type"/>
                    <xsl:if test="not(@response-type)">
                        <xsl:value-of select="substring(.//body,1,10)"/>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="sub-article[@article-type!='translation']/*/contrib-group | response/*/contrib-group">
        <div class="contribGroup">
            <xsl:apply-templates select="contrib" mode="article-meta-contrib"/>
            <xsl:if test="contrib[*]">
                <a href="" class="outlineFadeLink" data-toggle="modal"
                    data-target="#ModalTutors{../../@id}">
                    <xsl:apply-templates select="." mode="interface">
                        <xsl:with-param name="text">About the authors</xsl:with-param>
                    </xsl:apply-templates>
                </a>
            </xsl:if>
        </div>
    </xsl:template>
</xsl:stylesheet>