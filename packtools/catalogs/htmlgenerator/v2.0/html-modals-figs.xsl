<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    <xsl:template match="fig | fig-group" mode="modal">
        <div class="modal fade ModalFigs" id="ModalFig{@id}" tabindex="-1" role="dialog" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">
                            <span aria-hidden="true">&#xd7;</span>
                            <span class="sr-only">
                                <xsl:apply-templates select="." mode="interface">
                                    <xsl:with-param name="text">Close</xsl:with-param>
                                </xsl:apply-templates>
                            </span>
                        </button>
                        <!-- FIXME -->
                        <a class="link-newWindow showTooltip" target="_blank" data-placement="left">
                            <xsl:attribute name="title"><xsl:apply-templates select="." mode="interface">
                                <xsl:with-param name="text">Open new window</xsl:with-param>
                            </xsl:apply-templates></xsl:attribute>
                            <xsl:attribute name="href"><xsl:apply-templates select="." mode="file-location"/></xsl:attribute>
                            
                            <span class="sci-ico-newWindow"></span>
                        </a>
                        
                    </div>
                    <div class="modal-body">
                        <xsl:choose>
                            <xsl:when test="fig">
                                <xsl:apply-templates select="fig"/>
                            </xsl:when>
                            <xsl:when test="graphic">
                                <xsl:apply-templates select="graphic"></xsl:apply-templates>
                            </xsl:when>
                            <xsl:apply-templates select="attrib"></xsl:apply-templates>
                            
                        </xsl:choose>
                    </div>
                    <div class="modal-footer">
                        <h4 class="modal-title"><span class="sci-ico-fileFormula"></span> <xsl:apply-templates select="." mode="label-caption"></xsl:apply-templates></h4>
                        
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    
    
</xsl:stylesheet>
