<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron">
    <ns uri="http://www.le-tex.de/css/namespace" prefix="css"/>
    <!--    *
            * font rules 
            * -->
    <pattern id="css-font">
        <rule context="*[@css:font-family]">
            <report test="@css:font-family">
                font-family not supported
            </report>
        </rule>
        <!-- ****Font-Sizing RegEx überprüfen -->
        <rule context="*[@css:font-size]">
            <report test="@css:font-size[([0-9]+)em] > 2">
                Font sizes larger than 2em are without effect
            </report>
            <report test="@css:font-size[([0-9]+)px] > 48">
                Font sizes larger than 2em are without effect
            </report>
            
        </rule>
    </pattern>
    
    <!--    *
            * text rules 
            * -->
    <pattern id="css-text">
        <rule context="*[@css:text-transform]">
            <report test="@css:text-transform eq 'lowercase'">
                text-transform:lowercase not supported
            </report>
            <report test="@css:text-transform eq 'uppercase'">
                text-transform:uppercase not supported
            </report>
            <report test="@css:text-transform eq 'capitalize'">
                text-transform:capitalize not supported
            </report>
        </rule>
        <rule context="*[@css:text-decoration]">
            <report test="@css:text-decoration eq 'overline'">
                text-decoration:overline not supported
            </report>
            <report test="@css:text-decoration eq 'blink'">
                text-decoration:blink not supported
            </report>
        </rule>
    </pattern>
    <!--    *
            * padding rules 
            * -->    
    <pattern id="css-padding">
        <rule context="*[@css:padding]">
            <report test="@css:padding">
                padding not supported
            </report>
        </rule>
        <rule context="*[@css:padding-right]">
            <report test="@css:padding-right">
                padding-right not supported
            </report>
        </rule>
        <rule context="*[@css:padding-left]">
            <report test="@css:padding-left">
                padding-left not supported
            </report>
        </rule>
        <rule context="*[@css:padding-bottom]">
            <report test="@css:padding-bottom">
                padding-bottom not supported
            </report>
        </rule>
        <rule context="*[@css:padding-top]">
            <report test="@css:padding-top">
                padding-top not supported
            </report>
        </rule>
    </pattern>
    <!--    *
            * float rules 
            * -->    
    <pattern id="css-floats">
        <rule context="*[@css:float]">
            <report test="@css:float">
                float not supported
            </report>
        </rule>
        <rule context="*[@css:clear]">
            <report test="@css:clear">
                clear not supported
            </report>
        </rule>
    </pattern>
</schema>
