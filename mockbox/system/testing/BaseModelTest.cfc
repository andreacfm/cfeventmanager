<!-----------------------------------------------------------------------
********************************************************************************
Copyright 2005-2009 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Author 	  : Luis Majano
Date        : 06/20/2009
Description :
 Base Test case for Model Objects
---------------------------------------------------------------------->
<cfcomponent name="BaseModelTest" 
			 output="false" 
			 extends="mockbox.system.testing.BaseTestCase"
			 hint="A base test for testing model objects">

	<cfscript>
		this.loadColdbox = false;	
	</cfscript>
	
</cfcomponent>