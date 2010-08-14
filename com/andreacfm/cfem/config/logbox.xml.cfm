<?xml version="1.0" encoding="utf-8"?>
<Logbox xmlns:xsi="http://www.w3.org/2001/xmlschema-instance" 
	xsi:nonamespaceschemalocation="http://www.coldbox.org/schema/logboxconfig_1.4.xsd">

	<!-- appender definitions -->
	<Appender name="console" class="logbox.system.logging.appenders.ConsoleAppender" />
	
	<Appender name="asyncfile" class="logbox.system.logging.appenders.AsyncRollingFileAppender">
		<Property name="filepath"><![CDATA[/logs/cfem]]></Property>
		<Property name="filename">cfem</Property>
		<Property name="filemaxsize">10000</Property>
		<Property name="filemaxarchives">3</Property>		
	</Appender>

	<Appender name="syncfile" class="logbox.system.logging.appenders.RollingFileAppender">
		<Property name="filepath"><![CDATA[/logs/cfem]]></Property>
		<Property name="filename">cfem</Property>
		<Property name="filemaxsize">10000</Property>
		<Property name="filemaxarchives">3</Property>		
	</Appender>
		
	<!-- root logger -->
	<Root appenders="console,asyncfile"/>
	
	<!-- Prevent the log to run in async inside the dispatch thread -->
	<Category name="com.andreacfm.cfem.dispatch.AsynchDispatcher" appenders="console,syncfile" />

</Logbox>