<cfcomponent extends="mxunit.framework.TestCase">
	
	<cfinclude template="settings.cfm">

	<!--- setup--->
	<cffunction name="setUp">	
	</cffunction>

	<!--- tearDown--->
	<cffunction name="tearDown">
		<cfscript>
			if(fileExists(expandPath('/cfem.log'))){
				fileDelete(expandPath('/cfem.log'));
			}
		</cfscript>
	</cffunction>

	
	<!--- 
	test_setLogger
	 --->
	<cffunction name="test_setLogger" returntype="void" output="false" access="public">
		<cfset var logger = createObject('component','com.andreacfm.cfem.util.SimpleAppender').init(maxSize = 2000) />
		<cfset var em = createObject('component','com.andreacfm.cfem.EventManager').init( logger = logger ) />	
		
		<cfset assertTrue(em.getLogger().getMaxSize() eq 2000,"Logger not setted correctly") />		
		
	</cffunction>
	

	<!--- 
	test_config_properties
	 --->
	<cffunction name="test_config_properties" returntype="void" output="false" access="public">
		<cfset var em = createObject('component','com.andreacfm.cfem.EventManager').init() />
		<cfset em.loadConfig('/com/andreacfm/cfem/test/config/cfem-test.xml') />	
		<cfset var logger = em.getLogger() />
		
		<cfset assertTrue(logger.getMaxSize() eq 3000,"Default logger properties uncorrectly setted") />
		<cfset assertTrue(logger.getTranslatedMinLevel() eq 'warn',"Default logger properties uncorrectly setted") />		
		
	</cffunction>


	<!--- 
	*************************************************************************************************
	PRIVATE 
	*************************************************************************************************
	--->	
	
	<!--- 
	readLog
	 --->
	<cffunction name="readLog" returntype="string" output="false" access="private">
		<cfargument name="path" type="String">
		<cfscript>
		var res = fileRead(path);		
		return res;
		</cfscript>
	</cffunction>

	<!--- 
	getXml
	 --->
	<cffunction name="getXml" returntype="String" output="false" access="private">
		<cfargument name="version" required="false" default="1" />
		
		<cfswitch expression="#arguments.version#">
			
			<cfcase value="1">
				
				<cfxml variable="xml"><cfoutput>
				<event-manager>

		    		<events>
		        		
		        		<event name="oneEvent" />
		        		
		        		<event name="anotherEvent" type="#cfcroot#.mocks.Event" />
		        		
				      	<event name="oneMoreEvent">
				            
				            <interception point="before">
				                <action name="dispatch" event="addDefaultSidebar" />   
				            </interception>
				
				            <interception point="each" class="#cfcroot#.mocks.Interception"/>
				            
				            <interception point="after">
				                <condition><![CDATA[arraylen(event.getItems()) eq 0]]></condition>
				                <action name="dispatch" eventAlias="true" event="onSidebarMissingItems"/>
				            </interception>
				            
				        </event>
		        		
		    		</events>
				</event-manager>
				</cfoutput></cfxml>
			
			</cfcase>
		
		</cfswitch>
		
		
		<cfreturn xml />
	</cffunction>
		

</cfcomponent>