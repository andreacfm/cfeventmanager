<cfcomponent extends="mxunit.framework.TestCase">

	<cfscript>		
	variables.mockBox = createObject("component","coldbox.system.testing.MockBox").init();
	</cfscript>

	<!--- setup--->
	<cffunction name="setUp">
		<cfscript>
		variables.emMock = mockBox.createMock(classname = 'EventManager.EventManager');
		variables.emMock.$("getConfig").$args("defaultInterceptionClass").$results('EventManager.events.EventInterception');		
		variables.emMock.$("getConfig").$args("eventInterceptionsPoints").$results('before,each,after');				
		variables.emMock.$("getConfig").$args("defaultBaseListenerClass").$results('EventManager.listener.Listener');		
		</cfscript>
		
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
	
	<cffunction name="test_event_factory_create" returntype="void">

		<cfset var local = {} />		
		<cfset variables.emMock.$(method='getEvent',returns={
				name = 'oneEvent', 
				type ="EventManager.events.Event",
				interceptions = []	
				})>
		
		<cfset local.factory = createObject('component','EventManager.factory.EventFactory').init(variables.emMock) />
		
		<!--- call create --->
		<cfset local.result = local.factory.create('oneEvent') />
		<cfset assertTrue(isInstanceOf(local.result,'EventManager.events.Event'),
				"Basic create failed.") />			
		<cfset assertTrue(isInstanceOf(local.result.getEM(),'EventManager.EventManager'),
				"EventManager is not injected into event") />

		<!--- create with arguments --->
		<cfset local.result = local.factory.create('oneEvent', {test = true}, this, 'asynch') />
		<cfset assertTrue(local.result.getData().test,
				"Data not passed correctly") />
		<cfset assertTrue(createObject("java", "java.lang.System").identityHashCode(this) eq createObject("java", "java.lang.System").identityHashCode(local.result.getTarget()),
				"Target not passed correctly")>		
		<cfset assertTrue(local.result.getMode() eq 'Asynch',
				"mode not passed correctly")>		
					
	</cffunction>
	
	<cffunction name="test_listener_factory_create" returntype="void" output="false" access="public">

		<cfset var local = {} />		
		<cfset variables.emMock.$(method='getEvent',returns={
				name = 'oneEvent', 
				type ="EventManager.events.Event",
				interceptions = []	
				})/>
		
		<!--- Autowire true --->
		<cfset local.factory = createObject('component','EventManager.factory.ListenerFactory').init(variables.emMock,true) />
		
		<!--- create an event :
		 - listener class 
		 - default event 
		 --->
		<cfset local.conf = { event="oneEvent", listener = 'EventManager.test.mocks.Listener'} />
		<cfset local.result = local.factory.create(argumentCollection = local.conf)>
		<cfset assertTrue(local.result.getmethod() eq 'oneEvent',"Incorrect method") />
		<cfset assertTrue(isinstanceof(local.result.getListenerObject(),'EventManager.test.mocks.Listener'),
				"Incorrect listener object creation") />
		<cfset assertTrue(local.result.getAutowire() eq 'true',"Incorrect autowiring setting.") />
		<cfset assertTrue(local.result.getId() eq 'EventManager.test.mocks.Listener.oneEvent',
				"Incorrect generated id.") />

		<!--- Autowire default : false --->
		<cfset local.factory = createObject('component','EventManager.factory.ListenerFactory').init(variables.emMock) />
		
		<!--- create an event :
		 - listener object 
		 - custom event
		 - custom id 
		 --->
		 <cfset local.listenerStub = mockBox.createStub()/>
		 <cfset local.conf = { event="oneEvent", listener = local.listenerStub, method = 'customMethod', id ="customId"} />
		 <cfset local.result = local.factory.create(argumentCollection = local.conf)>
		 <cfset assertTrue(local.result.getmethod() eq 'customMethod',
		 		"Incorrect method") />
		 <cfset assertTrue(isinstanceof(local.result.getListenerObject(),'coldbox.system.testing.mockutils.Stub'),
		 		"Incorrect listener object") />
		 <cfset assertTrue(not local.result.getAutowire(),
		 		"Incorrect autowiring setting.") />
		 <cfset assertTrue(local.result.getId() eq 'customId',
		 		"Incorrect generated id.") />
		 
		 				
	</cffunction>

	<cffunction name="test_interception_factory_create" returntype="void" output="false" access="public">

		<cfset var local = {} />		
		<!--- debug false --->
		<cfset variables.emMock.$(method='getDebug',returns= false)/>
		
		<!--- factory --->
		<cfset local.factory = createObject('component','EventManager.factory.InterceptionFactory').init(variables.emMock) />
		<!--- event --->
		<cfset local.event = variables.mockBox.createMock(classname = 'EventManager.events.Event') />		
		
		<!--- 
		create with defaults: 
		'before' interception 
		condition : true
		--->
		<cfset local.result = local.factory.create('before') />
		<cfset assertTrue(isInstanceOf(local.result,'EventManager.events.AbstractEventInterception'),
				"Interception is not of the right class. #getMetaData(local.result).name#")>
		<cfset assertTrue(local.result.isConditionTrue(local.event),
				"Condition by default must be  true") />
		<cfset assertTrue(not local.result.hasActions(),
				"Actions array is not empty") />				
		<cfset assertTrue(local.result.getPoint() eq 'before',
				"Point is not properly setted")>
				
				
		 				 		 				
	</cffunction>

	<cffunction name="test_interception_create_illegal_point" returntype="void" output="false" access="public"
				mxunit:expectedException="EventManager.IllegalInterceptionPoint">
		
		<cfset var local = {} />		
		<!--- debug false --->
		<cfset variables.emMock.$(method='getDebug',returns= false)/>
		
		<!--- factory --->
		<cfset local.factory = createObject('component','EventManager.factory.InterceptionFactory').init(variables.emMock) />
		
		<!--- exception --->		
		<cfset local.factory.create('not_existing_point') />
		
	</cffunction>

	<cffunction name="test_interception_create_failing_evaluation_condition" returntype="void" output="false" access="public"
				mxunit:expectedException="EventManager.ConditionEvaluationError">
		
		<cfset var local = {} />		
		<!--- debug false --->
		<cfset variables.emMock.$(method='getDebug',returns= false)/>
		<cfset local.factory = createObject('component','EventManager.factory.InterceptionFactory').init(variables.emMock) />
		<cfset local.event = variables.mockBox.createMock(classname = 'EventManager.events.Event') />		
					
		<!--- exception --->					
		<cfset local.result = local.factory.create( point = 'before', condition = ' a / b') />
		<cfset local.result.isConditionTrue(local.event) />
		
	</cffunction>	

	<cffunction name="test_interception_create_illegal_condition" returntype="void" output="false" access="public"
				mxunit:expectedException="EventManager.IllegalConditionError">
		
		<cfset var local = {} />		
		<!--- debug false --->
		<cfset variables.emMock.$(method='getDebug',returns= false)/>
		<cfset local.factory = createObject('component','EventManager.factory.InterceptionFactory').init(variables.emMock) />
		<cfset local.event = variables.mockBox.createMock(classname = 'EventManager.events.Event') />		
					
		<!--- exception --->					
		<cfset local.result = local.factory.create( point = 'before', condition = 'this') />
		<cfset local.result.isConditionTrue(local.event) />
		
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