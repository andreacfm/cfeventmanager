<cfcomponent extends="mxunit.framework.TestCase">
	
	<cfinclude template="settings.cfm">

	<cfscript>		
	variables.mockBox = createObject("component","coldbox.system.testing.MockBox").init();
	</cfscript>

	<!--- setup--->
	<cffunction name="setUp">		
	</cffunction>

	<!--- tearDown--->
	<cffunction name="tearDown">
	
	</cffunction>

	<cffunction name="test_init" returntype="void">

		<cfset var local = {} />
				
		<cfset local.em = createObject('component','EventManager.eventManager').init() />
		
		<!--- 0 events--->
		<cfset assertTrue(local.em.getEvents().size() eq 0,"Events Array is not empty.")>
		
		<!--- Autowire false --->
		<cfset assertTrue(local.em.getAutowire() eq false,"Error in default autowire ")/> 

		<!--- Debug false --->
		<cfset assertTrue(local.em.getDebug() eq false,"Error in default debug.")/> 

		<!--- Scope 'request' --->
		<cfset assertTrue(local.em.getScope() eq 'request',"Error in default scope")/> 
					
	</cffunction>

	<cffunction name="test_getFactory" returntype="void">
		
		<cfset var local = {} />
				
		<cfset local.em = createObject('component','EventManager.eventManager').init() />
		
		<!--- main factory --->
		<cfset assertTrue(isInstanceof(local.em.getFactory(),'EventManager.factory.Factory'),
				"Main factory failed.")>
		
		<!--- Dispatcher factory --->
		<cfset assertTrue(isInstanceof(local.em.getFactory().getFactory('DispatcherFactory'),'EventManager.factory.DispatcherFactory'),
				"Dispatcher factory failed.")>

		<!--- Event factory --->
		<cfset assertTrue(isInstanceof(local.em.getFactory().getFactory('EventFactory'),'EventManager.factory.EventFactory'),
				"Event factory failed.")>

		<!--- Action factory --->
		<cfset assertTrue(isInstanceof(local.em.getFactory().getFactory('ActionFactory'),'EventManager.factory.ActionFactory'),
				"Action factory failed.")>

		<!--- Interception factory --->
		<cfset assertTrue(isInstanceof(local.em.getFactory().getFactory('InterceptionFactory'),'EventManager.factory.InterceptionFactory'),
				"Interception factory failed.")>

					
	</cffunction>

	
	<!--- Dispacth --->
	<cffunction name="test_dispatch_Asynch_Events" returntype="void" hint="">
		
		
		<cfset var local = {} />
		
		<!--- Event --->
		<cfset local.eventsArray = [
				{name = 'asynchTest', type = 'EventManager.events.CollectDataEvent'}
				] />
				
		<!--- Listener --->
		<cfset local.listenerArray=[
				{event='asynchTest',listener = '#cfcroot#.mocks.AsynchListener', method = "addItem"}
			]/>
			
		<!--- Em --->	
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