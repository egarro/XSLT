<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net/"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="form">
        <xsl:variable name="formPrefix" select="@formPrefix" />
        <html>
           <head>
               <title><xsl:value-of select="@formPrefix"/> Form</title>
               <link rel="stylesheet" type="text/css" href="css/HTMLForm.css" />
               <script src="js/jquery-2.1.1.js" />
               <script src="js/formValidation.js" />
               <script src="js/HTMLForm.js" />
           </head>
            <body>
                <form action="submit.php"  method="post" onsubmit="return submitForm(this);">        
                    <div class="HTMLForm">
                    <xsl:for-each select="page">
                        <div class="HTMLPage">
                            <xsl:if test="@isHidden='YES'">
                                <xsl:attribute name="style">display:none;</xsl:attribute>                        
                            </xsl:if>
                            <xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                            <xsl:for-each select="group">
                                <div class="HTMLGroup">
                                    <xsl:if test="@isHidden='YES'">
                                        <xsl:attribute name="style">display:none;</xsl:attribute>                        
                                    </xsl:if>
                                    <xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>
                                    <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                                    <xsl:if test="@title">
                                        <h3><xsl:value-of select="@title"/></h3>                        
                                    </xsl:if>
                                    <xsl:for-each select="item">
                                        <div>
                                            <xsl:if test="@isHidden='YES'">
                                                <xsl:attribute name="style">display:none;</xsl:attribute>                        
                                            </xsl:if>
                                            <xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>
                                            <xsl:attribute name="class">MM<xsl:value-of select="@type"/></xsl:attribute>
                                            <xsl:call-template name="buildItem" />   
                                        </div>
                                    </xsl:for-each>
                                </div>
                            </xsl:for-each>
                        </div>
                    </xsl:for-each>
                    <!-- Add a left side panel -->
                        <div class="HTMLPage" id="veryLastPage" name="veryLastPage">
                            <div class="HTMLGroup" id="sidePanel" name="sidePanel">
                                <div class='timer'>
                                    <div class='loadingBars'>
                                        <div class='loadingLeft'></div>
                                        <div class='loadingRight'></div>
                                    </div>
                                    <div class='timerInner'>
                                        <span>0:00</span>
                                    </div>
                                </div>
                                <div class='lineBar'>
                                    <div class='reached'></div>
                                    <div class='circleIcon'></div>
                                    <div class='errorList'></div>
                                </div>
                                <div class='errorSection'></div>
                            </div>
                        </div>
                    <input type="submit" name="submitButton" value="Submit Form" class="submitButton"/>
                    </div>
             </form>
                
             <script>
             
             function relationships() {   
             <xsl:for-each select="//form/relationships/relationship">
                 <xsl:variable name="objectType" select="substring-before(@object,'::')"/>    
                 <xsl:variable name="targetName" select="substring-after(@object,'::')"/>
                 <xsl:variable name="condition" select="./condition"/>
                         if (  <xsl:call-template name="for-each-loop"> 
                               <!-- Changing the condition statement to javascript -->
                               <xsl:with-param name="list" select="tokenize($condition,'&quot;\w+&quot;| AND | OR | BT | LT | == | != |[()\s]')" />
                               <xsl:with-param name="past-memory" select="''" />
                               <xsl:with-param name="future-memory" select="$condition" />    
                               </xsl:call-template>  ) {
                              <!-- Interpreting the tags into corresponding javascript functions -->
                             <xsl:choose>    
                                 <xsl:when test="./if/option">
                                     <xsl:text>updateItemOptions('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>','</xsl:text><xsl:value-of select='string-join(./if/option,"&apos;,&apos;")' /><xsl:text>');</xsl:text>
                                 </xsl:when>
                                 <xsl:when test="./if/tag">
                                     <xsl:text>updateItemOptionTags('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>','</xsl:text><xsl:value-of select='string-join(./if/tag,"&apos;,&apos;")' /><xsl:text>');</xsl:text>
                                 </xsl:when>
                                 <xsl:otherwise>
                                     <xsl:for-each select="./if/descendant::*">
                                        <xsl:call-template name="create-JS-function"> 
                                            <!-- Looking up matching javascript function -->
                                            <xsl:with-param name="targetName" select="$targetName" />
                                        </xsl:call-template>    
                                    </xsl:for-each>                                        
                                </xsl:otherwise>
                            </xsl:choose>  
                         }
                         <xsl:if test="./else">else {
                             <!-- Interpreting the tags into corresponding javascript functions -->
                             <xsl:choose>    
                                 <xsl:when test="./else/option">
                                     <xsl:text>updateItemOptions('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>','</xsl:text><xsl:value-of select='string-join(./else/option,"&apos;,&apos;")' /><xsl:text>');</xsl:text>
                                 </xsl:when>
                                 <xsl:when test="./else/tag">
                                     <xsl:text>updateItemOptionTags('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>','</xsl:text><xsl:value-of select='string-join(./else/tag,"&apos;,&apos;")' /><xsl:text>');</xsl:text>
                                 </xsl:when>
                                 <xsl:otherwise>
                                     <xsl:for-each select="./else/descendant::*">
                                         <xsl:call-template name="create-JS-function"> 
                                             <!-- Looking up matching javascript function -->
                                             <xsl:with-param name="targetName" select="$targetName" />
                                         </xsl:call-template>    
                                     </xsl:for-each>                                        
                                 </xsl:otherwise>
                             </xsl:choose>                             
                         }
                         </xsl:if>
             </xsl:for-each>  
             } 
             </script>    
          </body>
        </html>
    </xsl:template>


    <!-- Tags to JS Functions mapping -->
    <xsl:template name="create-JS-function">
        <xsl:param name="targetName" />
        <xsl:choose>
            <!-- show, hide and forceReceipt apply to items, groups or pages (elements) -->
            <xsl:when test="local-name()='show'">
                <xsl:text>displayElement('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>',true);</xsl:text>
            </xsl:when>
            <xsl:when test="local-name()='hide'">
                <xsl:text>displayElement('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>',false);</xsl:text>
            </xsl:when>
            <xsl:when test="local-name()='forceReceipt'">
                <xsl:text>setForceReceiptAttributeForElement('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>','</xsl:text><xsl:value-of select="." /><xsl:text>');</xsl:text>
            </xsl:when>
            <!-- All the other verbs apply to items only -->
            <xsl:when test="local-name()='evaluate'">
                <xsl:text>evaluatePredicateForItem('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>','</xsl:text><xsl:value-of select="." /><xsl:text>');</xsl:text>
            </xsl:when>
            <xsl:when test="local-name()='text'">
                <xsl:text>setTextForItem('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>','</xsl:text><xsl:value-of select="." /><xsl:text>');</xsl:text>
            </xsl:when>
            <xsl:when test="local-name()='check'">
                <xsl:text>checkItem('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>',true);</xsl:text>
            </xsl:when>
            <xsl:when test="local-name()='uncheck'">
                <xsl:text>checkItem('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>',false);</xsl:text>
            </xsl:when>
            <xsl:when test="local-name()='copy'">
                <xsl:text>copyOntoItemFromItem('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>','</xsl:text><xsl:value-of select="." /><xsl:text>');</xsl:text>
            </xsl:when>
            <xsl:when test="local-name()='submit'">
                <xsl:text>forItemSetAttributeWithValue('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>','skipSubmit',false);</xsl:text>
            </xsl:when>
            <xsl:when test="local-name()='skip'">
                <xsl:text>forItemSetAttributeWithValue('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>','skipSubmit',true);</xsl:text>
            </xsl:when>
            <xsl:when test="local-name()!='option' or local-name()!='tag'">
                <xsl:text>forItemSetAttributeWithValue('</xsl:text><xsl:value-of select="$targetName" /><xsl:text>','</xsl:text><xsl:value-of select="local-name()" /><xsl:text>','</xsl:text><xsl:value-of select="." /><xsl:text>');</xsl:text>
            </xsl:when>
            <xsl:when test="local-name()='option' or local-name()='tag'" />
            <xsl:otherwise>
                <xsl:text>alert('Unknown tag found while generating javascript functions');</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
    
    <!-- For-each loop emulator with memory -->
    <xsl:template name="for-each-loop">
        <xsl:param name="list" />
        <xsl:param name="past-memory" />
        <xsl:param name="future-memory" />
        <xsl:choose>
        <xsl:when test="count($list) &gt; 0">
            <xsl:variable name="object" select="$list[1]" />
            <xsl:choose>
                <xsl:when test="compare($object,'')!=0">
                    <xsl:call-template name="for-each-loop">
                        <xsl:with-param name="list" select="remove($list,1)"/>
                        <xsl:with-param name="past-memory" select="concat($past-memory,substring-before($future-memory,$object),concat('valueOfItem(&quot;',$object,'&quot;)'))" />
                        <xsl:with-param name="future-memory" select="substring-after($future-memory,$object)" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="for-each-loop">
                        <xsl:with-param name="list" select="remove($list,1)"/>
                        <xsl:with-param name="past-memory" select="$past-memory" />
                        <xsl:with-param name="future-memory" select="$future-memory" />
                    </xsl:call-template> 
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
             <xsl:value-of select="replace(replace(replace(replace(concat($past-memory,$future-memory),' AND ',' &amp;&amp; '),' OR ',' || '),' BT ',' &gt; '),' LT ',' &lt; ')"/>
        </xsl:otherwise>
        </xsl:choose>    
    </xsl:template>    
    
    <!-- Item Factory -->        
    <xsl:template name="buildItem"> 
        <xsl:if test="./label">
            <div>
                <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                <span>
                    <xsl:value-of select="./label"/>
                </span>    
            </div>    
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@type='localImage'">
                <div class="simpleImage">
                <img> 
                    <xsl:attribute name="src">images/<xsl:value-of select="./path"/></xsl:attribute>
                </img>
                </div>    
            </xsl:when>
            <xsl:when test="@type='zipImage'">
                <div class="simpleImage">
                <img> 
                    <xsl:attribute name="src">images/<xsl:value-of select="//form/@formPrefix"/>/<xsl:value-of select="./path"/></xsl:attribute>
                    <xsl:if test="./width">
                        <xsl:attribute name="width"><xsl:value-of select="./width" /></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="./height">
                        <xsl:attribute name="height"><xsl:value-of select="./height" /></xsl:attribute>
                    </xsl:if>
                </img>
                </div>    
            </xsl:when>
            <xsl:when test="@type='lineBlock'">
                 <div>
                     <xsl:attribute name="style">padding-top:<xsl:value-of select="./size"/>px; padding-bottom:<xsl:value-of select="./size"/>px;</xsl:attribute>
                 </div>        
            </xsl:when>
            <xsl:when test="@type='photoCapture'">
                <a>
                    <xsl:attribute name="href">javascript:openPhotoCapture(this);</xsl:attribute>   
                <div class="simpleImage">
                <img> 
                    <xsl:attribute name="src">images/camera.png</xsl:attribute>
                </img>
                </div>    
                </a>
            </xsl:when>
            <xsl:when test="@type='signatureBox'">
                <a>
                    <xsl:attribute name="href">javascript:openSignaturePanel(this);</xsl:attribute>   
                    <div class="signBox"><span>TAP HERE TO SIGN</span></div>    
                </a>
                <xsl:if test="@submitsValue='YES'">
                    <input type="hidden" value="1">
                    <xsl:choose>
                        <xsl:when test="./submitName">
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                            <xsl:attribute name="submitName"><xsl:value-of select="./submitName"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute> 
                        </xsl:otherwise>
                    </xsl:choose>    
                    </input>
                </xsl:if>
            </xsl:when>
            <xsl:when test="@type='addressField'">
                <div>
                <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                <xsl:call-template name="buildAddressComposite">
                    <xsl:with-param name="country"><xsl:value-of select="./country"/></xsl:with-param>
                </xsl:call-template>
                </div>    
            </xsl:when>
            <xsl:when test="@type='dateField'">
                <input type="date" data-role="date" data-inline="true" size="50" onchange="javascript:relationships();">
                <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="./placeholder">
                            <xsl:attribute name="placeholder"><xsl:value-of select="./placeholder"/></xsl:attribute>
                        </xsl:when>
                        <xsl:when test="./formatting">
                            <xsl:attribute name="placeholder"><xsl:value-of select="./formatting"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise />
                    </xsl:choose>
                </input>    
            </xsl:when>
            <xsl:when test="@type='label'">
                <xsl:value-of select="./text"/>          
            </xsl:when>
            <xsl:when test="@type='multilineLabel'">
                <xsl:value-of select="./text"/>          
            </xsl:when>
            <xsl:when test="@type='checkbox'">
                <input type="checkbox" value="1" onchange="javascript:relationships();">
                    <xsl:choose>
                        <xsl:when test="./submitName">
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                            <xsl:attribute name="submitName"><xsl:value-of select="./submitName"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute> 
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="@submitsValue='YES'">
                        <xsl:attribute name="submitsValue">YES</xsl:attribute> 
                    </xsl:if>
                </input>
            </xsl:when>
            <xsl:when test="@type='segmentedControl'">
                <xsl:text>SEGMENTED CONTROL ITEM - (Implemented as drop-downs for now)</xsl:text><br/>          
                <div class="dropdown"><select onchange="javascript:relationships();">
                    <xsl:choose>
                        <xsl:when test="./submitName">
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                            <xsl:attribute name="submitName"><xsl:value-of select="./submitName"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute> 
                        </xsl:otherwise>
                    </xsl:choose>                    
                    <xsl:for-each select="./tag">
                        <option>
                            <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
                            <xsl:value-of select="."/>    
                        </option>
                    </xsl:for-each> 
                </select></div>
            </xsl:when>
            <xsl:when test="@type='radioControl'">
                <xsl:choose>
                <xsl:when test="@multiple='YES'">
                    <xsl:text>MULTIPLE RADIO CONTROL!!</xsl:text>          
                </xsl:when>
                <xsl:otherwise>
                        <xsl:choose>
                        <xsl:when test="./submitName">
                            <xsl:call-template name="buildRadioControl">
                                <xsl:with-param name="tmp_name"><xsl:value-of select="./submitName"/></xsl:with-param>
                                <xsl:with-param name="option_list" select="./tag" />
                                <xsl:with-param name="with_images" select="false()" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="buildRadioControl">
                                <xsl:with-param name="tmp_name"><xsl:value-of select="@name"/></xsl:with-param>
                                <xsl:with-param name="option_list" select="./tag" />
                                <xsl:with-param name="with_images" select="false()" />
                            </xsl:call-template>
                        </xsl:otherwise>
                        </xsl:choose>
                </xsl:otherwise>                
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@type='imagePicker'">
                <xsl:choose>
                    <xsl:when test="@multiple='YES'">
                        <xsl:text>MULTIPLE RADIO CONTROL WITH IMAGES!!</xsl:text>          
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="./submitName">
                                <xsl:call-template name="buildRadioControl">
                                    <xsl:with-param name="tmp_name"><xsl:value-of select="./submitName"/></xsl:with-param>
                                    <xsl:with-param name="option_list" select="./image" />
                                    <xsl:with-param name="with_images" select="true()" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="buildRadioControl">
                                    <xsl:with-param name="tmp_name"><xsl:value-of select="@name"/></xsl:with-param>
                                    <xsl:with-param name="option_list" select="./image" />
                                    <xsl:with-param name="with_images" select="true()" />
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>                
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@type='infoButton'">
                  <button type="button">
                      <xsl:variable name="texto" select="normalize-space(./text)" />
                      <xsl:attribute name="onclick">javascript:openInfoPanelWithText(this,'<xsl:value-of select="$texto"/>');</xsl:attribute>
                      <xsl:value-of select="./defaultValue"/>
                  </button>
            </xsl:when>
            <xsl:when test="@type='dropDown'">
                <div class="dropdown"><select onchange="javascript:relationships();">
                    <xsl:choose>
                        <xsl:when test="./submitName">
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                            <xsl:attribute name="submitName"><xsl:value-of select="./submitName"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute> 
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                    <xsl:when test="./option">
                        <xsl:for-each select="./option">
                            <xsl:copy-of select="."/>    
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style">display:none;</xsl:attribute>
                        <option value=""></option>
                    </xsl:otherwise> 
                    </xsl:choose>  
                </select></div>                
            </xsl:when>
            <xsl:when test="@type='valuePicker'">
                <div class="dropdown"><select>
                    <xsl:choose>
                        <xsl:when test="./submitName">
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                            <xsl:attribute name="submitName"><xsl:value-of select="./submitName"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute> 
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="./action">
                        <!-- Matches an action to a corresponding javascript function -->
                        <xsl:call-template name="JS-function-for-action">
                            <xsl:with-param name="itemType" select="'textField'" />
                        </xsl:call-template>
                    </xsl:if>                    
                    <xsl:for-each select="./option">
                        <xsl:copy-of select="."/>    
                    </xsl:for-each> 
                </select></div>
            </xsl:when>
            <xsl:when test="@type='canadianPostalCode'">
                <input type="text" size="50" validation="canadianPostalCode" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:choose>
                        <xsl:when test="./submitName">
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                            <xsl:attribute name="submitName"><xsl:value-of select="./submitName"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute> 
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="./placeholder">
                        <xsl:attribute name="placeholder"><xsl:value-of select="./placeholder"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="./action">
                        <!-- Matches an action to a corresponding javascript function -->
                        <xsl:call-template name="JS-function-for-action">
                            <xsl:with-param name="itemType" select="'canadianPostalCode'" />
                        </xsl:call-template>
                    </xsl:if>
                </input>          
            </xsl:when>
            <xsl:when test="@type='emailPinger'">
                <input type="email" size="50" validation="email" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:choose>
                        <xsl:when test="./submitName">
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                            <xsl:attribute name="submitName"><xsl:value-of select="./submitName"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute> 
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="./placeholder">
                            <xsl:attribute name="placeholder"><xsl:value-of select="./placeholder"/></xsl:attribute>                            
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="placeholder">Email</xsl:attribute>
                        </xsl:otherwise>                   
                    </xsl:choose>
                    <xsl:if test="./action">
                        <!-- Matches an action to a corresponding javascript function -->
                        <xsl:call-template name="JS-function-for-action">
                            <xsl:with-param name="itemType" select="'emailPinger'" />
                        </xsl:call-template>
                    </xsl:if>
                </input>  
                <div class="MMbuttonField">
                <button type="button">
                    <xsl:attribute name="onclick">javascript:validateEmail('<xsl:value-of select="@name"/>')</xsl:attribute>
                    Validate email
                </button>
                </div>
            </xsl:when>
            <xsl:when test="@type='FRBankPinger'">
                <div>
                    <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                <xsl:call-template name="buildBankComposite">
                    <xsl:with-param name="country">FRA</xsl:with-param>
                </xsl:call-template>          
                </div>    
            </xsl:when>
            <xsl:when test="@type='UKBankPinger'">
                <div>
                    <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                <xsl:call-template name="buildBankComposite">
                    <xsl:with-param name="country">UK</xsl:with-param>
                </xsl:call-template>          
                </div>    
            </xsl:when>
            <xsl:when test="@type='textField'">
                <input type="text" size="50">
                    <xsl:if test="@editable='NO'">
                        <xsl:attribute name="editable">NO</xsl:attribute>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="./submitName">
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
                            <xsl:attribute name="submitName"><xsl:value-of select="./submitName"/></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute> 
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="./placeholder">
                        <xsl:attribute name="placeholder"><xsl:value-of select="./placeholder"/></xsl:attribute>
                    </xsl:if>
                    <xsl:if test="./validation">
                        <xsl:attribute name="validation"><xsl:value-of select="./validation"/></xsl:attribute>
                        <xsl:attribute name="onkeydown">javascript:filterInput(event,this);</xsl:attribute>
                        <xsl:attribute name="oninput">javascript:evaluateInput(this);</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="./action">
                        <!-- Matches an action to a corresponding javascript function -->
                        <xsl:call-template name="JS-function-for-action">
                            <xsl:with-param name="itemType" select="'textField'" />
                        </xsl:call-template>
                    </xsl:if>
                </input>          
            </xsl:when>
            <xsl:otherwise />
        </xsl:choose>
        <xsl:if test="./detailLabel">
            <div>
                  <xsl:attribute name="class">ITEMDetailLabel</xsl:attribute>
                  <span><xsl:value-of select="./detailLabel"/></span>    
            </div>    
        </xsl:if>
        <xsl:if test="./inlineLabel">
            <div>
                <xsl:attribute name="class">ITEMInlineLabel</xsl:attribute>
                <span><xsl:value-of select="./inlineLabel"/></span>    
            </div>    
        </xsl:if>
    </xsl:template>

    <!-- Action to JS function mapping -->
    <xsl:template name="JS-function-for-action">
        <xsl:param name="itemType"/>
        <xsl:choose>
            <xsl:when test="compare(./action,'itemShouldNotify:')=0">
                <xsl:attribute name="onchange">javascript:relationships();</xsl:attribute>
            </xsl:when>
            <xsl:when test="compare(./action,'UFUcreateSourceCode')=0">
                <xsl:attribute name="onchange">javascript:generateUFUSourceCode('sourceCode');</xsl:attribute>
            </xsl:when>
            <xsl:when test="compare(./action,'SumItems')=0 or compare(./action,'SumItems:')=0">
                <xsl:attribute name="onchange">javascript:sumItemsWithPredicate('<xsl:value-of select="./actionArg"/>');</xsl:attribute>
            </xsl:when>
            <xsl:when test="(string-length(./action) &gt; 9) and (substring(./action, 1, 9)='linksTo::')">
                <xsl:attribute name="linksTo"><xsl:value-of select="substring-after(./action,'::')"/></xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                Unknown action found while building <xsl:value-of select="$itemType"/> item: <xsl:value-of select="./action"/> 
            </xsl:otherwise>                    
        </xsl:choose>
    </xsl:template>

    <!-- Building a radio control -->
    <xsl:template name="buildRadioControl">
        <xsl:param name="tmp_name" />
        <xsl:param name="option_list" />
        <xsl:param name="with_images" />
        <ul>
        <xsl:for-each select="$option_list">
            <li>
                <input type="radio" onchange="javascript:relationships();">
                    <xsl:attribute name="name"><xsl:value-of select="$tmp_name"/></xsl:attribute>
                    <xsl:attribute name="id"><xsl:value-of select="concat($tmp_name,position())"/></xsl:attribute>
                    <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>   
                </input>
                <label>
                    <xsl:attribute name="for"><xsl:value-of select="concat($tmp_name,position())"/></xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="$with_images">
                            <div class="simpleImage">
                            <img> 
                                <xsl:attribute name="src">images/<xsl:value-of select="//form/@formPrefix"/>/<xsl:value-of select="."/></xsl:attribute>
                            </img>
                            </div>    
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </label>     
            </li>     
        </xsl:for-each>
        </ul>    
    </xsl:template>

    <!-- Address Factory -->        
    <xsl:template name="buildAddressComposite"> 
        <xsl:param name="country" />
        <xsl:variable name="prefix"><xsl:value-of select="./prefix"/></xsl:variable>
        <xsl:variable name="MAX_CITY_LENGTH" select="25" />
        <xsl:variable name="MAX_ADDRESS_LENGTH" select="50" />
        
        <!-- Emulated for loop for first three lines (just for fun)-->
        <xsl:variable name="count" select="3"/> 
        <xsl:for-each select="(//*)[position()&lt;=$count]"> 
            <div class="MMtextField">
            <xsl:if test="position()=1">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Address</span>    
                </div>                
            </xsl:if>            
            <input type="text" size="50" validation="lettersNumeric" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                <xsl:attribute name="name">
                    <xsl:choose>
                        <xsl:when test="$prefix=''">address<xsl:value-of select="position()"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="./prefix"/>Address<xsl:value-of select="position()"/></xsl:otherwise>
                    </xsl:choose>                
                </xsl:attribute>
                <xsl:attribute name="placeholder">Address Line <xsl:value-of select="position()"/></xsl:attribute>
                <xsl:attribute name="maxlength"><xsl:value-of select="$MAX_ADDRESS_LENGTH"/></xsl:attribute>
            </input>
            </div><br />    
        </xsl:for-each>
        
        <!-- All cases feature a city -->
        <div class="MMtextField">
        <div>
            <xsl:attribute name="class">ITEMLabel</xsl:attribute>
            <span>City</span>    
        </div>        
        <input type="text" size="50" validation="names" placeholder="City" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
            <xsl:attribute name="name">
                <xsl:choose>
                    <xsl:when test="$prefix=''">city</xsl:when>
                    <xsl:otherwise><xsl:value-of select="./prefix"/>City</xsl:otherwise>
                </xsl:choose>                
            </xsl:attribute>
            <xsl:attribute name="maxlength"><xsl:value-of select="$MAX_CITY_LENGTH"/></xsl:attribute>
        </input>
        </div><br/>
        
        
        <xsl:choose>
            <xsl:when test="$country='CANADA' or $country='CA'">
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Canadian Postal Code</span>    
                </div>
                <input type="text" size="50" validation="canadianPostalCode" placeholder="Canadian Postal Code" maxlength="7" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">postalCode</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>PostalCode</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/> 
                <!-- StateProv specific choices for Canada -->
                <div class="MMdropDown">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Province</span>    
                </div>
                <div class="dropdown"><select>
                    <option value="AB">Alberta</option>
                    <option value="BC">British Columbia</option>
                    <option value="MB">Manitoba</option>
                    <option value="NB">New Brunswick</option>
                    <option value="NL">Newfoundland and Labrador</option>
                    <option value="NT">Northwest Territories</option>
                    <option value="NS">Nova Scotia</option>
                    <option value="NU">Nunavut</option>
                    <option value="ON">Ontario</option>
                    <option value="PE">Prince Edward Island</option>
                    <option value="QC">Quebec</option>
                    <option value="SK">Saskatchewan</option>
                    <option value="YT">Yukon</option>
                </select></div>
                </div><br/>
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Country</span>    
                </div>                
                <div class="countryName" editable="NO">Canada</div>
                </div>    
            </xsl:when>
            <xsl:when test="$country='QUEBEC' or $country='QC'">
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Code Postal Canadien</span>    
                </div>
                <input type="text" size="50" validation="canadianPostalCode" placeholder="Code Postal Canadien" maxlength="7" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">postalCode</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>PostalCode</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>    
                <!-- StateProv specific choices for Canada -->
                <div class="MMdropDown">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Province</span>    
                </div>
                <div class="dropdown"><select>
                    <option value="AB">Alberta</option>
                    <option value="BC">British Columbia</option>
                    <option value="MB">Manitoba</option>
                    <option value="NB">New Brunswick</option>
                    <option value="NL">Newfoundland and Labrador</option>
                    <option value="NT">Northwest Territories</option>
                    <option value="NS">Nova Scotia</option>
                    <option value="NU">Nunavut</option>
                    <option value="ON">Ontario</option>
                    <option value="PE">Prince Edward Island</option>
                    <option value="QC">Quebec</option>
                    <option value="SK">Saskatchewan</option>
                    <option value="YT">Yukon</option>
                </select></div>
                </div><br/>
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Pays</span>    
                </div>
                <div class="countryName" editable="NO">Canada</div>
                </div>    
            </xsl:when>
            <xsl:when test="$country='USA' or $country='US'">
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Zip Code</span>    
                </div>                
                <input type="number" size="50" validation="usPostalCode" placeholder="Zip Code" maxlength="10" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">postalCode</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>PostalCode</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>    
                <!-- StateProv specific choices for USA -->
                <div class="MMdropDown">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>State</span>    
                </div>
                <div class="dropdown"><select>
                    <option value="AL">Alabama</option>
                    <option value="AK">Alaska</option>
                    <option value="AZ">Arizona</option>
                    <option value="AR">Arkansas</option>
                    <option value="CA">California</option>
                    <option value="CO">Colorado</option>
                    <option value="CT">Connecticut</option>
                    <option value="DE">Delaware</option>
                    <option value="DC">Washington, DC</option>
                    <option value="FL">Florida</option>
                    <option value="GA">Georgia</option>
                    <option value="HI">Hawaii</option>
                    <option value="ID">Idaho</option>
                    <option value="IL">Illinois</option>
                    <option value="IN">Indiana</option>
                    <option value="IA">Iowa</option>
                    <option value="KS">Kansas</option>
                    <option value="KY">Kentucky</option>
                    <option value="LA">Louisiana</option>
                    <option value="ME">Maine</option>
                    <option value="MD">Maryland</option>
                    <option value="MA">Massachusetts</option>
                    <option value="MI">Michigan</option>
                    <option value="MN">Minnesota</option>
                    <option value="MS">Mississippi</option>
                    <option value="MO">Missouri</option>
                    <option value="MT">Montana</option>
                    <option value="NE">Nebraska</option>
                    <option value="NV">Nevada</option>
                    <option value="NH">New Hampshire</option>
                    <option value="NJ">New Jersey</option>
                    <option value="NM">New Mexico</option>
                    <option value="NY">New York</option>
                    <option value="NC">North Carolina</option>
                    <option value="ND">North Dakota</option>
                    <option value="OH">Ohio</option>
                    <option value="OK">Oklahoma</option>
                    <option value="OR">Oregon</option>
                    <option value="PA">Pennsylvania</option>
                    <option value="RI">Rhode Island</option>
                    <option value="SC">South Carolina</option>
                    <option value="SD">South Dakota</option>
                    <option value="TN">Tennessee</option>
                    <option value="TX">Texas</option>
                    <option value="UT">Utah</option>
                    <option value="VT">Vermont</option>
                    <option value="VA">Virginia</option>
                    <option value="WA">Washington</option>
                    <option value="WV">West Virginia</option>
                    <option value="WI">Wisconsin</option>
                    <option value="WY">Wyoming</option>                    
                </select></div>
                </div><br/>
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Country</span>    
                </div>
                    <div class="countryName" editable="NO">USA</div>
                </div>    
            </xsl:when>
            <xsl:when test="$country='FRANCE' or $country='FRA'">
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Code Postal</span>    
                </div>
                <input type="number" size="50" validation="frenchPostalCode" placeholder="Code Postal" maxlength="5" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">postalCode</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>PostalCode</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/> 
                <div class="MMdropDown">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Région</span>    
                </div>
                <div class="dropdown"><select>
                    <option value="Alsace">Alsace</option>
                    <option value="Aquitaine">Aquitaine</option>
                    <option value="Auvergne">Auvergne</option>
                    <option value="Bretagne">Bretagne</option>
                    <option value="Bourgogne">Bourgogne</option>
                    <option value="Centre">Centre</option>
                    <option value="Champagne-Ardenne">Champagne-Ardenne</option>
                    <option value="Corse">Corse</option>
                    <option value="Franche-Comté">Franche-Comté</option>
                    <option value="Guyane">Guyane</option>
                    <option value="Guadeloupe">Guadeloupe</option>
                    <option value="Languedoc-Roussillon">Languedoc-Roussillon</option>
                    <option value="Limousin">Limousin</option>
                    <option value="Lorraine">Lorraine</option>
                    <option value="Basse-Normandie">Basse-Normandie</option>
                    <option value="Martinique">Martinique</option>
                    <option value="Mayotte">Mayotte</option>
                    <option value="Midi-Pyrénées">Midi-Pyrénées</option>
                    <option value="Nord-Pas-de-Calais">Nord-Pas-de-Calais</option>
                    <option value="Pays de la Loire">Pays de la Loire</option>
                    <option value="Picardie">Picardie</option>
                    <option value="Poitou-Charentes">Poitou-Charentes</option>
                    <option value="Provence-Alpes-Côte d'Azur">Provence-Alpes-Côte d'Azur</option>
                    <option value="La Réunion">La Réunion</option>
                    <option value="Rhône-Alpes">Rhône-Alpes</option>
                    <option value="Haute-Normandie">Haute-Normandie</option>
                    <option value="Île-de-France">Île-de-France</option>
                </select></div>
                </div><br/>
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Pays</span>    
                </div>
                    <div class="countryName" editable="NO">France</div>
                </div>   
            </xsl:when>
            <xsl:when test="$country='UK'">
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Postal Code</span>    
                </div>
                <input type="text" size="50" validation="ukPostalCode" placeholder="Postal Code" maxlength="8" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">postalCode</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>PostalCode</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>  
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>County</span>    
                </div>
                <input type="text" size="50" validation="names" placeholder="County" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">stateProv</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>StateProv</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                    <xsl:attribute name="maxlength"><xsl:value-of select="$MAX_CITY_LENGTH"/></xsl:attribute>
                </input>
                </div><br/>
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Country</span>    
                </div>
                    <div class="countryName" editable="NO">United Kingdom</div>
                </div>    
            </xsl:when>
            <xsl:when test="$country='MEXICO' or $country='MEX'">
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Código Postal</span>    
                </div>
                <input type="number" size="50" validation="mexicanPostalCode" placeholder="Código Postal" maxlength="5" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">postalCode</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>PostalCode</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>    
                <!-- StateProv specific choices for Canada -->
                <div class="MMdropDown">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>Estado</span>    
                </div>
                <div class="dropdown"><select>
                <option value="AG">Aguascalientes</option>
                <option value="BN">Baja California</option>
                <option value="BS">Baja California Sur</option>
                <option value="CH">Chihuahua</option>
                <option value="CL">Colima</option>
                <option value="CM">Campeche</option>
                <option value="CA">Coahuila</option>
                <option value="CP">Chiapas</option>
                <option value="DF">Distrito Federal</option>
                <option value="DU">Durango</option>
                <option value="GR">Guerrero</option>
                <option value="GJ">Guanajuato</option>
                <option value="HG">Hidalgo</option>
                <option value="JA">Jalisco</option>
                <option value="MC">Michoacan</option>
                <option value="MR">Morelos</option>
                <option value="MX">Edo. Mexico</option>
                <option value="NA">Nayarit</option>
                <option value="NL">Nuevo Leon</option>
                <option value="OA">Oaxaca</option>
                <option value="PU">Puebla</option>
                <option value="QR">Quintana Roo</option>
                <option value="QE">Queretaro</option>
                <option value="SI">Sinaloa</option>
                <option value="SL">San Luis Potosi</option>
                <option value="SO">Sonora</option>
                <option value="TB">Tabasco</option>
                <option value="TL">Tlaxcala</option>
                <option value="TM">Tamaulipas</option>
                <option value="VE">Veracruz</option>
                <option value="YU">Yucatan</option>
                <option value="ZA">Zacatecas</option>
                </select></div>
                </div><br/>
                <div class="MMtextField">
                <div>
                    <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                    <span>País</span>    
                </div>
                    <div class="countryName" editable="NO">México</div>
                </div>
            </xsl:when>
            <xsl:otherwise>
                Unknown address type found in XML file:<b><xsl:value-of select="$country"/></b> 
            </xsl:otherwise>    
        </xsl:choose>

        <!-- All cases check for validation -->
        <xsl:choose>
            <xsl:when test="./validationService">
                <div class="MMbuttonField">
                <button type="button">
                    <xsl:attribute name="onclick">javascript:validateAddress('<xsl:value-of select="@name"/>','<xsl:value-of select="./validationService"/>')</xsl:attribute>
                    Validate address
                </button>
                </div>    
            </xsl:when>
            <xsl:when test="./validation">
                <div class="MMbuttonField">
                <button type="button">
                    <xsl:attribute name="onclick">javascript:validateAddress('<xsl:value-of select="@name"/>','<xsl:value-of select="./validation"/>')</xsl:attribute>
                    Validate address
                </button>
                </div>
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>

    <!-- Bank Factory -->        
    <xsl:template name="buildBankComposite"> 
        <xsl:param name="country" />
        <xsl:variable name="prefix"><xsl:value-of select="./prefix"/></xsl:variable>        
        <xsl:choose>
            <xsl:when test="$country='CANADA' or $country='CA'">
                <xsl:text>CANADIAN BANK FIELD</xsl:text>    
            </xsl:when>
            <xsl:when test="$country='QUEBEC' or $country='QC'">
                <xsl:text>QUEBEC BANK FIELD</xsl:text>    
            </xsl:when>
            <xsl:when test="$country='USA' or $country='US'">
                <xsl:text>US BANK FIELD</xsl:text>    
            </xsl:when>
            <xsl:when test="$country='FRANCE' or $country='FRA'"> 
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Etablissement bancaire</span>    
                    </div>
                <input type="text" size="50" validation="names" placeholder="Etablissement bancaire" maxlength="60" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankName</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>Name</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>   
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Adresse</span>    
                    </div>
                <input type="text" size="50" placeholder="Adresse" maxlength="60">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankAddress</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>Address</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Code Postal</span>    
                    </div>
                <input type="number" size="50" validation="frenchPostalCode" placeholder="Code Postal" maxlength="5" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankPostalCode</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>PostalCode</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Ville</span>    
                    </div>
                <input type="text" size="50" placeholder="Ville">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankCity</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>City</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <p>
                    Désignation du compte à débiter:
                </p>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Code banque</span>    
                    </div>
                <input type="number" size="50" validation="numeric" placeholder="Code banque" maxlength="5" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankCode</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>BankCode</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Code agence</span>    
                    </div>
                <input type="number" size="50" validation="numeric" placeholder="Code agence" maxlength="5" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankAgency</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>BankAgency</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div>
                <input type="hidden">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankSortCode</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>BankSortCode</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>No. de compte</span>    
                    </div>
                <input type="number" size="50" validation="lettersNumeric" placeholder="No. de compte" maxlength="11" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankAccountNumber</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>AccountNumber</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>RIB</span>    
                    </div>
                <input type="number" size="50" validation="numeric" placeholder="RIB" maxlength="2" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankRIB</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>RIB</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                    <xsl:attribute name="disabled"/>
                </input>
                </div><br/>                
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>IBAN</span>    
                    </div>
                <input type="text" size="50" validation="lettersNumeric" placeholder="IBAN" maxlength="27" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankIBAN</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>IBAN</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>BIC</span>    
                    </div>
                <input type="text" size="50" validation="lettersNumeric" placeholder="BIC" maxlength="11" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankBIC</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>BIC</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <div class="MMbuttonField">
                <button type="button">
                    <xsl:attribute name="onclick">javascript:validateFRBank('<xsl:value-of select="@name"/>')</xsl:attribute>
                    Validate bank account
                </button> 
                </div>    
            </xsl:when>
            <xsl:when test="$country='UK'">
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Bank Name</span>    
                    </div>
                <input type="text" size="50" validation="names" placeholder="Bank Name" maxlength="60" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankName</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>Name</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>   
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Bank Address</span>    
                    </div>
                <input type="text" size="50" placeholder="Bank Address" maxlength="60">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankAddress</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>Address</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Postal Code</span>    
                    </div>
                <input type="text" size="50" validation="ukPostalCode" placeholder="Postal Code" maxlength="7" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankPostalCode</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>PostalCode</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <p>
                    PERSONAL INFORMATION<br/>
                    Name(s) Of Account Holder(s):
                </p>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Name 1</span>    
                    </div>
                <input type="text" size="50" placeholder="Name 1">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankAccountName1</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>AccountName1</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Name 2</span>    
                    </div>
                <input type="text" size="50" placeholder="Name 2">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankAccountName2</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>AccountName2</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Sort Code</span>    
                    </div>
                <input type="number" size="50" validation="numeric" placeholder="Sort Code" maxlength="6" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankSortCode</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>SortCode</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <div class="MMtextField">
                    <div>
                        <xsl:attribute name="class">ITEMLabel</xsl:attribute>
                        <span>Account Number</span>    
                    </div>
                <input type="number" size="50" validation="numeric" placeholder="Account Number" maxlength="8" onkeydown="javascript:filterInput(event,this);" oninput="javascript:evaluateInput(this);">
                    <xsl:attribute name="name">
                        <xsl:choose>
                            <xsl:when test="$prefix=''">bankAccountNumber</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./prefix"/>AccountNumber</xsl:otherwise>
                        </xsl:choose>                
                    </xsl:attribute>
                </input>
                </div><br/>
                <div class="MMbuttonField">
                <button type="button">
                    <xsl:attribute name="onclick">javascript:validateUKBank('<xsl:value-of select="@name"/>')</xsl:attribute>
                    Validate bank account
                </button>
                </div>    
            </xsl:when>
            <xsl:when test="$country='MEXICO' or $country='MEX'">
                <xsl:text>MEXICAN BANK FIELD</xsl:text>    
            </xsl:when>
            <xsl:otherwise>
                Unknown bank type found in XML file:<b><xsl:value-of select="$country"/></b> 
            </xsl:otherwise>    
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>