<cfcomponent extends="mxunit.framework.TestCase">
	
	<cfinclude template="settings.cfm">

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


	<!--- Parse Listener --->	
	<cffunction name="test_parse_listener_programmatically" returntype="void" output="false" access="public">
		
		<cfset var em = createObject('component','com.andreacfm.cfem.EventManager').init() />		
		<cfset em.parseDirectory(dir = "#siteroot#/test/mocks/scan/") />
		<cfset var event = em.getEvent('onTestCase')>		
		<!--- non recurse solo 2 listener --->				
		<cfset assertEquals(2, event.listeners.size()) />
		<cfset assertTrue(event.listeners[1].getMethod() eq 'onScanTestCase','Expected onScanTestCase - #event.listeners[1].getMethod()#')>
		<cfset assertTrue(event.listeners[2].getMethod() eq 'onScanTestCaseSecondListener','Expected onScanTestCaseSecondListener - #event.listeners[1].getMethod()#')>
		
	</cffunction>

	<cffunction name="test_parse_listener_programmatically_recurse" returntype="void" output="false" access="public">
	
		<cfset var em = createObject('component','com.andreacfm.cfem.EventManager').init() />
		<cfset em.getLogger().setOut('console') />		
		<cfset em.parseDirectory(dir = "#siteroot#/test/mocks/scan/",recurse = true) />
		<cfset var event = em.getEvent('onTestCase')>		
		<!--- recurse 4 listener --->				
		<cfset assertEquals(5, event.listeners.size()) />
		<cfset assertTrue(event.listeners[1].getMethod() eq 'onScanTestCase','Expected onScanTestCase - #event.listeners[1].getMethod()#')>
		<cfset assertTrue(event.listeners[2].getMethod() eq 'onScanTestCaseSecondListener','Expected onScanTestCaseSecondListener - #event.listeners[1].getMethod()#')>
		<cfset assertTrue(event.listeners[3].getMethod() eq 'onScanTestCaseSub1','Expected onScanTestCaseSub1 - #event.listeners[1].getMethod()#')>
		<cfset assertTrue(event.listeners[4].getMethod() eq 'onScanTestCaseSecondListenerSub1','Expected onScanTestCaseSecondListenerSub1 - #event.listeners[1].getMethod()#')>
		
	</cffunction>

		
	<!--- xml --->
	<cffunction name="testLoadFromXmlPath" returntype="void" output="false" access="public">
		<cfset var xml = getXml(1) />
		<cfset var path = '#siteroot#/test/temp/emXml.cfm'>
		<cffile action="write" file="#expandPath(path)#" output="#trim(xml)#" />
		
		<cfset local.em = createObject('component','com.andreacfm.cfem.EventManager').init(xmlPath = path) />
		
		<!--- oneevent --->
		<cfset local.event = local.em.getEvent('oneEvent') />
		<cfset assertTrue(local.event.type eq 'com.andreacfm.cfem.events.Event',
				"Event Type not saved correctly") />
		
		<!--- anotherevent --->
		<cfset local.event = local.em.getEvent('anotherEvent') />
		<cfset assertTrue(local.event.type eq '#cfcroot#.mocks.Event',
				"Event Type not saved correctly") />
		
		<!--- onemoreevent --->		
		<cfset local.event = local.em.getEvent('oneMoreEvent') />
		<cfset assertTrue(local.event.type eq 'com.andreacfm.cfem.events.Event',
				"Event Type not saved correctly") />	
		<cfset assertTrue(local.event.interceptions.size() eq 3,
				"Interceptions not loaded.")>
			
		
	</cffunction>

	<cffunction name="testLoadFromXmlObject" returntype="void" output="false" access="public">

		<cfset var xml = xmlParse(getXml(1)) />
		<cfset local.em = createObject('component','com.andreacfm.cfem.EventManager').init(xmlObject = xml) />
		
		<!--- oneevent --->
		<cfset local.event = local.em.getEvent('oneEvent') />
		<cfset assertTrue(local.event.type eq 'com.andreacfm.cfem.events.Event',
				"Event Type not saved correctly") />
		
		<!--- anotherevent --->
		<cfset local.event = local.em.getEvent('anotherEvent') />
		<cfset assertTrue(local.event.type eq '#cfcroot#.mocks.Event',
				"Event Type not saved correctly") />
		
		<!--- onemoreevent --->		
		<cfset local.event = local.em.getEvent('oneMoreEvent') />
		<cfset assertTrue(local.event.type eq 'com.andreacfm.cfem.events.Event',
				"Event Type not saved correctly") />	
		<cfset assertTrue(local.event.interceptions.size() eq 3,
				"Interceptions not loaded.")>

		
	</cffunction>

	<cffunction name="testLoadFromXmlRaw" returntype="void" output="false" access="public">

		<cfset var xml = getXml(1) />
		<cfset local.em = createObject('component','com.andreacfm.cfem.EventManager').init(xml = xml) />
		
		<!--- oneevent --->
		<cfset local.event = local.em.getEvent('oneEvent') />
		<cfset assertTrue(local.event.type eq 'com.andreacfm.cfem.events.Event',
				"Event Type not saved correctly") />
		
		<!--- anotherevent --->
		<cfset local.event = local.em.getEvent('anotherEvent') />
		<cfset assertTrue(local.event.type eq '#cfcroot#.mocks.Event',
				"Event Type not saved correctly") />
		
		<!--- onemoreevent --->		
		<cfset local.event = local.em.getEvent('oneMoreEvent') />
		<cfset assertTrue(local.event.type eq 'com.andreacfm.cfem.events.Event',
				"Event Type not saved correctly") />	
		<cfset assertTrue(local.event.interceptions.size() eq 3,
				"Interceptions not loaded.")>
		
	</cffunction>
	

	<!--- Dispacth --->
	<cffunction name="test_dispatch_Asynch_Events" returntype="void" hint="">
		
		
		<cfset var local = {} />
		
		<!--- Event --->
		<cfset local.eventsArray = [
				{name = 'asynchTest', type = 'com.andreacfm.cfem.events.CollectDataEvent'}
				] />
				
		<!--- Listener --->
		<cfset local.listenerArray=[
				{event='asynchTest',listener = '#cfcroot#.mocks.AsynchListener', method = "addItem"}
			]/>
			
		<!--- Em --->	
		<cfset local.EM = createObject('component','com.andreacfm.cfem.EventManager').init(
				events = local.eventsArray, 
				listeners = local.listenerArray
				)/>	

		<cfset local.event = local.EM.createEvent(name = 'asynchTest', mode = "asynch") />		
		
		<!--- Before dispatch item len == 0 --->
		<cfset assertTrue(local.event.getItems().size() eq 0,'Items count fail before dispatch.') />
		
		<cfset local.EM.dispatchEvent(event=local.event) />

		<!--- Just After dispatch item len == 0 --->
		<cfset assertTrue(local.event.getItems().size() eq 0,'Items count fail just after asynch dispatch. Listeners sleep 1000.') />
		
		<cfset sleep(3000) />
		
		<!--- Sleep 3000 to give time to the thread to execute --->
		<cfset assertTrue(local.event.getItems().size() eq 100,'Items count fails.') />		
		
		
	</cffunction>
	

	<!--- 
	*************************************************************************************************
	PRIVATE 
	*************************************************************************************************
	--->	

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