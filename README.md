# XSLT Transformation Tools


We use these tools to validate our .xmls against the [MM XML FORM BUILDER LANGUAGE V.1.1](XMLDocumentationV1.1.pdf) and to
generate the .html forms that we use in the [iOS OnBoard App](http://gitlab.getmade.co/onboard/iosshell.git)

## To generate an .html form, use the following command:

```Shell
java -jar saxon9he.jar source-xml stylesheet-xsl -o:fileName.html
```

For example, 

```Shell
java -jar saxon9he.jar "/Users/egarro/Desktop/MADE MEDIA/forms/XML/Primus/PRIMUS1.xml" "toHTML.xsl" -o:PRIMUS1.html
```

will apply the toHTML.xsl stylesheet to the PRIMUS1.xml source-xml and will create a PRIMUS1.html file in the directory where you type in the command (you must have the [saxon9he.jar](saxon9he.jar) file in that directory).

To validate .xmls against the [MM XML FORM BUILDER LANGUAGE V.1.1](XMLDocumentationV1.1.pdf) implemented in the schema [form.xsd](form.xsd), use:

```Shell
java -jar saxon9he.jar Validate -s:"/Users/egarro/Desktop/MADE MEDIA/forms/XML/Primus/PRIMUS1.xml" -xsd:"form.xsd"
```

For this last feature, there seems to be some licensing issue. I'm working hard to hack this somehow.