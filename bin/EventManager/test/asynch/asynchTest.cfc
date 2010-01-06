<cfcomponent extends="mxunit.framework.TestCase">

	<!--- setup--->
	<cffunction name="setUp">
		
	</cffunction>
	
	<!--- asynch test --->
	<cffunction name="testAsynchEvents" returntype="void" hint="">
		
		<cfset var local = {} />

		<cfset local.eventsArray = [
				{name = 'asynchTest', type = 'EventManager.events.CollectDataEvent'}
				] />
		<cfset local.listenerArray=[
				{event='asynchTest',listener = 'EventManager.test.mocks.AsynchListener', method = "addItem"}
			]/>
		<cfset local.EM = createObject('component','EventManager.EventManager').init(
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
	

</cfcomponent>	