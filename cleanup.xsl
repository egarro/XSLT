<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="xs"
    version="2.0">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
   
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Remove deprecated tags -->
    <xsl:template match="remoteserver"/>
    <xsl:template match="theme"/>

    <!-- Remove deprecated attributes -->
    <xsl:template match="@language"/>
    <xsl:template match="@emailName"/>
    
    <!-- Lowercase the first letter of the type attribute -->
    <xsl:template match="/form/page/group/item/@type">
        <xsl:attribute name="type">
            <xsl:choose>
                <xsl:when test="compare(.,'FRBankPinger')=0 or compare(.,'UKBankPinger')=0">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(lower-case(substring(., 1, 1)), substring(., 2))"/>
            </xsl:otherwise>    
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <!-- Round up float values -->
    <xsl:template match="width|height|textSize">
        <xsl:copy>
            <xsl:value-of select="floor(.)"/>
        </xsl:copy>    
    </xsl:template>

    <!-- Round up float values -->
    <xsl:template match="buttonPosition">
        <xsl:copy>
            <xsl:if test="contains(.,'bottom')">
                <xsl:value-of select="replace(.,'bottom','low')"/>
            </xsl:if>
            <xsl:if test="contains(.,'upper')">
                <xsl:value-of select="replace(.,'upper','up')"/>
            </xsl:if>
        </xsl:copy>    
    </xsl:template>
    
    <!-- Fix common errors -->
    <xsl:template match="validation">
        <xsl:choose>
            <xsl:when test="compare(.,'numbers')=0">
                <xsl:copy>
                    <xsl:text>numeric</xsl:text>       
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates />
                </xsl:copy>
            </xsl:otherwise>    
        </xsl:choose>    
    </xsl:template>

    <!-- Eliminate duplicated message tags -->
    <xsl:template match="onmissing|onerror">
        <xsl:copy>
            <xsl:apply-templates select="message"/>
        </xsl:copy>    
    </xsl:template>
    
    <xsl:template match="message">
        <xsl:if test="not( node-name(preceding-sibling::*)=QName('','message') )">
            <xsl:call-template name="base64Decode" />
        </xsl:if>    
    </xsl:template>
    
    <!-- Fix mandatory lowercase tags (regex, regexmessage) -->
    <xsl:template match="regEx|regExMessage|regexMessage|regExmessage">      
        <xsl:element name="{lower-case(local-name())}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>  
    
    <!-- Base64Decode old base64 encoding types (label,detailLabel,inlineLabel,placeholder,text) -->    
    <xsl:template match="label|detailLabel|inlineLabel|placeholder|text">  
          <xsl:call-template name="base64Decode" />  
    </xsl:template>  
    
    <!-- Function to Base64Decode -->        
    <xsl:template name="base64Decode">        
        <xsl:choose>
            <xsl:when test="@encoding">
                <xsl:copy>
                    <xsl:value-of select="saxon:base64Binary-to-string(xs:base64Binary(.), 'UTF8')"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates />
                </xsl:copy>
            </xsl:otherwise>    
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>