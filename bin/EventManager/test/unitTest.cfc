<cfcomponent extends="mxunit.framework.TestCase">

	<cfscript>		
	variables.mockBox = createObject("component","coldbox.system.testing.MockBox").init();
	</cfscript>

	<!--- setup--->
	<cffunction name="setUp">
	</cffunction>

	<!--- tearDown--->
	<cffunction name="tearDown">
	</cffunction>


	<!--- CONFIGS --->
	<cffunction name="test_defaults" returntype="void">

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




	<!--- FACTORIES --->
	<cffunction name="test_that_factories_exists" returntype="void">

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
	
	<cffunction name="test_event_factory_return_event_with_defaults" returntype="void">

		<cfset var local = {} />		
		<cfset local.emMock = mockBox.createMock(classname = 'EventManager.EventManager') />
		<cfset local.emMock.$(method='getEvent',returns={
				name = 'oneEvent', 
				type ="EventManager.events.Event",
				interceptions = []	
				})>
		
		<cfset local.factory = createObject('component','EventManager.factory.EventFactory').init(local.emMock) />
		
		<!--- call create --->
		<cfset local.result = local.factory.create('oneEvent') />
		<cfset assertTrue(isInstanceOf(local.result,'EventManager.events.Event'),
				"Basic create failed.") />			
		<cfset assertTrue(isInstanceOf(local.result.getEM(),'EventManager.EventManager'),
				"EventManager is not injected into event") />
					
	</cffunction>
	
	<cffunction name="test_event_factory_return_event_with_arguments" returntype="void">

		<cfset var local = {} />		
		<cfset local.emMock = mockBox.createMock(classname = 'EventManager.EventManager') />
		<cfset local.emMock.$(method='getEvent',returns={
				name = 'oneEvent', 
				type ="EventManager.events.Event",
				interceptions = []	
				})>
		
		<cfset local.factory = createObject('component','EventManager.factory.EventFactory').init(local.emMock) />
		
		<!--- create with arguments --->
		<cfset local.result = local.factory.create('oneEvent', {test = true}, this, 'asynch') />
		<cfset assertTrue(local.result.getData().test,
				"Data not passed correctly") />
		<cfset assertTrue(createObject("java", "java.lang.System").identityHashCode(this) eq createObject("java", "java.lang.System").identityHashCode(local.result.getTarget()),
				"Target not passed correctly")>		
		<cfset assertTrue(local.result.getMode() eq 'Asynch',
				"mode not passed correctly")>		
		
			
					
	</cffunction>
	
	<cffunction name="test_listener_factories_create" returntype="void" output="false" access="public">

		<cfset var local = {} />		
		<cfset local.emMock = mockBox.createMock(classname = 'EventManager.EventManager') />
		<cfset local.emMock.$(method='getEvent',returns={
				name = 'oneEvent', 
				type ="EventManager.events.Event",
				interceptions = []	
				}).$(method = 'getConfig', returns = 'EventManager.listener.Listener')/>
		
		<!--- Autowire true --->
		<cfset local.factory = createObject('component','EventManager.factory.ListenerFactory').init(local.emMock,true) />
		
		<!--- create an event :
		 - listener class 
		 - default event 
		 --->
		<cfset local.conf = { event="oneEvent", listener = 'EventManager.test.mocks.Listener'} />
		<cfset local.result = local.factory.create(argumentCollection = local.conf)>
		<cfset assertTrue(local.result.getmethod() eq 'oneEvent',"Incorrect method") />
		<cfset assertTrue(isinstanceof(local.result.getListenerObject(),'EventManager.test.mocks.Listener'),"Incorrect listener object creation") />
		<cfset assertTrue(local.result.getAutowire() eq 'true',"Incorrect autowiring setting.") />		
		
				
	</cffunction>




	<!--- EVENTS --->


	


		
	
	<!--- Asynch --->
	<cffunction name="test_dispatch_Asynch_Events" returntype="void" hint="">
		
		
		<cfset var local = {} />
		
		<!--- Event --->
		<cfset local.eventsArray = [
				{name = 'asynchTest', type = 'EventManager.events.CollectDataEvent'}
				] />
				
		<!--- Listener --->
		<cfset local.listenerArray=[
				{event='asynchTest',listener = 'EventManager.test.mocks.AsynchListener', method = "addItem"}
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