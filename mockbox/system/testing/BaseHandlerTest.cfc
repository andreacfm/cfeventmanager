<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Author 	  : Luis Majano
Date        : 06/20/2009
Description :
 Base Test case for Handler
---------------------------------------------------------------------->
<cfcomponent name="BaseHandlerTest" 
			 output="false" 
			 extends="mockbox.system.testing.BaseTestCase"
			 hint="A base test for testing handlers">

	<cfscript>
		this.loadColdbox = false;	
	</cfscript>
	
	
</cfcomponent>
