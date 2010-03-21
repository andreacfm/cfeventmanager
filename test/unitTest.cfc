<cfcomponent extends="mxunit.framework.TestCase">

	<cfinclude template="settings.cfm">
	
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
		variables.emMock.$("getConfig").$args("SynchDispatcher").$results('EventManager.dispatch.SynchDispatcher');
		variables.emMock.$("getConfig").$args("AsynchDispatcher").$results('EventManager.dispatch.AsynchDispatcher');
		variables.emMock.$("getConfig").$args("defaultBaseEventClass").$results('EventManager.events.Event');
		variables.emMock.$("getConfig").$args("Actions").$results({
			stop = 'EventManager.events.actions.Stop',
			throw = 'EventManager.events.actions.Throw',
			dispatch = 'EventManager.events.actions.Dispatch'
			});				
		</cfscript>
	</cffunction>

	<!--- tearDown--->
	<cffunction name="tearDown">
	
	</cffunction>


	<!--- events --->
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

	<cffunction name="test_event_factory_create_and_register_observers" returntype="void">

		<cfset var local = {} />
		<cfset local.intMock = mockBox.createMock(classname = "EventManager.events.EventInterception") />		
		<cfset variables.emMock.$(method='getEvent',returns={
				name = 'oneEvent', 
				type ="EventManager.events.Event",
				interceptions = [local.intMock]	
				})>
		
		<cfset local.factory = createObject('component','EventManager.factory.EventFactory').init(variables.emMock) />
		
		<!--- call create --->
		<cfset local.result = local.factory.create('oneEvent') />
		<cfset assertTrue(local.result.isObserved(),"Interception has not been registered.")>
		<cfset assertTrue(local.result.getObservers().size() eq 1,"Interceptions number is wrong.")>
							
	</cffunction>

	<cffunction name="test_addEvent" returntype="void" output="true" access="public">
		
		<cfset var local = {} />
		<cfset variables.emMock.$(method='getDebug',returns=false)>
		
		<!--- default type --->		
		<cfset variables.emMock.addEvent('oneEvent') />
		
		<cfset assertTrue(variables.emMock.getEvent('oneEvent').type eq 'EventManager.events.Event',
				"Event was not added correctly. Wrong type") />
		<cfset assertTrue(variables.emMock.getEvent('oneEvent').interceptions.size() eq 0,
				"Event was not added correctly. Wrong interception size") />
		<cfset assertTrue(variables.emMock.getEvent('oneEvent').counter eq 0,
				"Event was not added correctly. Wrong counter.") />
		<cfset assertTrue(variables.emMock.getEvent('oneEvent').listeners.size() eq 0,
				"Event was not added correctly, Wrong listeners size") />

		
		<!--- custom type --->		
		<cfset variables.emMock.addEvent('anotherEvent','EventManager.events.CollectDataEvent') />

		<cfset assertTrue(variables.emMock.getEvent('anotherEvent').type eq 'EventManager.events.CollectDataEvent',
				"Wrong custom type") />
		
	</cffunction>

	<cffunction name="test_addEvents" returntype="void" output="true" access="public">
		
		<cfset var local = {} />
		<cfset variables.emMock.$(method='getDebug',returns=false)>
		
		<!--- default type --->		
		<cfset local.events = [{name = 'oneEvent'},{name = 'anotherEvent', type = 'EventManager.events.CollectDataEvent'}] />
		
		<cfset variables.emMock.setEvents(local.events) />
		
		<cfset assertTrue(variables.emMock.getEvent('oneEvent').type eq 'EventManager.events.Event',
				"Event was not added correctly. Wrong type") />
		<cfset assertTrue(variables.emMock.getEvent('anotherEvent').type eq 'EventManager.events.CollectDataEvent',
				"Event was not added correctly. Wrong custom type") />
				
	</cffunction>
	
	<cffunction name="test_adding_existing_event" returntype="void" output="false" access="public"
				mxunit:expectedException="EventManager.duplicateEventsExeption">
	
		<cfset var local = {} />
		<cfset variables.emMock.$(method='getDebug',returns=false)>

		<cfset variables.emMock.addEvent('oneEvent') />
		<cfset variables.emMock.addEvent('oneEvent') />
										
	</cffunction>

	<cffunction name="test_add_event_with_interceptions_and_actions" returntype="void" output="false" access="public">
				
	</cffunction>	
	


	
	<!--- listener --->
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
		<cfset local.conf = { event="oneEvent", listener = '#cfcroot#.mocks.Listener'} />
		<cfset local.result = local.factory.create(argumentCollection = local.conf)>
		<cfset assertTrue(local.result.getmethod() eq 'oneEvent',"Incorrect method") />
		<cfset assertTrue(isinstanceof(local.result.getListenerObject(),'#cfcroot#.mocks.Listener'),
				"Incorrect listener object creation") />
		<cfset assertTrue(local.result.getAutowire() eq 'true',"Incorrect autowiring setting.") />
		<cfset assertTrue(local.result.getId() eq '#cfcroot#.mocks.Listener.oneEvent',
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



	<!--- interceptions --->
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



	<!--- dispatcher --->
	<cffunction name="test_dispatcher_factory_create" returntype="void" output="false" access="public">

		<cfset var local = {} />
		<cfset local.factory = createObject('component','EventManager.factory.DispatcherFactory').init(variables.emMock) />

		<!--- event synch --->
		<cfset local.event = variables.mockBox.createMock(classname = 'EventManager.events.Event').$(method="getMode",returns="Synch") />				
		
		<!--- create --->
		<cfset local.result = local.factory.create(local.event) />
		<cfset assertTrue(isinstanceof(local.result,'EventManager.dispatch.SynchDispatcher'),
				"Synch dispathcer is not of the right class. [#getmetadata(local.result).name#]")>
						
		<!--- asynch --->
		<cfset local.event = variables.mockBox.createMock(classname = 'EventManager.events.Event').$(method="getMode",returns="Asynch") />				
		
		<!--- create --->
		<cfset local.result = local.factory.create(local.event) />
		<cfset assertTrue(isinstanceof(local.result,'EventManager.dispatch.AsynchDispatcher'),
				"Asynch dispathcer is not of the right class. [#getmetadata(local.result).name#]")>
				
		
	</cffunction>



	<!--- actions --->
	<cffunction name="test_actions_factory_create" returntype="void" output="false" access="public">
		<cfset var local = {} />
		<cfset local.factory = createObject('component','EventManager.factory.ActionFactory').init(variables.emMock) />
		
		<cfset local.result = local.factory.create(name = 'stop') />
		<cfset assertTrue(isInstanceOf(local.result,'EventManager.events.actions.AbstractAction'),
				"Action create error.")>
		<cfset assertTrue(local.result.getName() eq 'stop',
				"Action create error. Name is incorrect.")>		
	
	</cffunction>

	<cffunction name="tets_actions_factory_create_illegal_name" returntype="void" output="false" access="public"
				mxunit:expectedException="EventManager.NoSuchActionException">
			
		<cfset var local = {} />
		<cfset local.factory = createObject('component','EventManager.factory.ActionFactory').init(variables.emMock) />
		
		<cfset local.result = local.factory.create(name = 'unknown_action') />
					
				
	</cffunction>
	
		
</cfcomponent>	