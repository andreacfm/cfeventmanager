<cfcomponent extends="mxunit.framework.TestCase">
	
	<cfinclude template="settings.cfm">

	<cfscript>		
	variables.mockBox = createObject("component","mockbox.system.testing.MockBox").init();
	</cfscript>

	<!--- setup--->
	<cffunction name="setUp">		
		<cfscript>		
		</cfscript>
	</cffunction>

	<!--- tearDown--->
	<cffunction name="tearDown">
		<cfscript>
			if(fileExists(expandPath('/cfem.log'))){
				fileDelete(expandPath('/cfem.log'));
			}
		</cfscript>
	</cffunction>

	
	<cffunction name="testinit" returntype="void" output="false">
		<cfset var obj = createObject('component','com.andreacfm.cfem.util.SimpleAppender').init() />
		
		<cfset assertTrue(obj.getMinLevel() eq 2,'Minlevel: wrong default') />
		<cfset assertTrue(fileExists(expandPath('/cfem.log')),'File not craeted') />
		<cfset assertTrue(obj.getmaxSize() eq 10485760,'File not craeted') />
		
	</cffunction>
	
	<cffunction name="test_level_do_not_exists" returntype="void" output="false" mxunit:expectedException="com.andreacfm.logging.MinLevelDoNotExists" >
		<cfset createObject('component','com.andreacfm.cfem.util.SimpleAppender').init(minLevel:'do_not_exists') />
	</cffunction>
	
	<cffunction name="test_log" returntype="void" output="false">
		<cfset var obj = createObject('component','com.andreacfm.cfem.util.SimpleAppender').init() />
		<cfset var msg = hash(now()) />
		<cfset obj.info(msg) />
		<cfset sleep(50) />
		<cfset var content = fileread(expandPath('/cfem.log')) />
		<cfset assertTrue(find(msg,content),'Messaggio non loggato') />
	</cffunction>
	
	<cffunction name="test_log_lower_level_should_not_log" returntype="void" output="false">
		<cfset var obj = createObject('component','com.andreacfm.cfem.util.SimpleAppender').init(minlevel='warn') />
		<cfset var msg = hash(now()) />
		<cfset obj.info(msg) />
		<cfset sleep(50) />
		<cfset var content = fileread(expandPath('/cfem.log')) />
		<cfset assertTrue(not find(msg,content),'Messaggio non loggato') />
	</cffunction>

</cfcomponent>