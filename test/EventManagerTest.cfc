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





	<!--- Events --->
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




		
	<!--- xml --->
	<cffunction name="testLoadFromXmlPath" returntype="void" output="false" access="public">
		<cfset var xml = getXml(1) />
		<cfset var path = '#siteroot#/test/temp/emXml.cfm'>
		<cffile action="write" file="#expandPath(path)#" output="#trim(xml)#" />
		
		<cfset local.em = createObject('component','EventManager.EventManager').init(xmlPath = path) />
		
		<!--- oneevent --->
		<cfset local.event = local.em.getEvent('oneEvent') />
		<cfset assertTrue(local.event.type eq 'EventManager.events.Event',
				"Event Type not saved correctly") />
		
		<!--- anotherevent --->
		<cfset local.event = local.em.getEvent('anotherEvent') />
		<cfset assertTrue(local.event.type eq '#cfcroot#.mocks.Event',
				"Event Type not saved correctly") />
		
		<!--- onemoreevent --->		
		<cfset local.event = local.em.getEvent('oneMoreEvent') />
		<cfset assertTrue(local.event.type eq 'EventManager.events.Event',
				"Event Type not saved correctly") />	
		<cfset assertTrue(local.event.interceptions.size() eq 3,
				"Interceptions not loaded.")>
			
		
	</cffunction>

	<cffunction name="testLoadFromXmlObject" returntype="void" output="false" access="public">

		<cfset var xml = xmlParse(getXml(1)) />
		<cfset local.em = createObject('component','EventManager.EventManager').init(xmlObject = xml) />
		
		<!--- oneevent --->
		<cfset local.event = local.em.getEvent('oneEvent') />
		<cfset assertTrue(local.event.type eq 'EventManager.events.Event',
				"Event Type not saved correctly") />
		
		<!--- anotherevent --->
		<cfset local.event = local.em.getEvent('anotherEvent') />
		<cfset assertTrue(local.event.type eq '#cfcroot#.mocks.Event',
				"Event Type not saved correctly") />
		
		<!--- onemoreevent --->		
		<cfset local.event = local.em.getEvent('oneMoreEvent') />
		<cfset assertTrue(local.event.type eq 'EventManager.events.Event',
				"Event Type not saved correctly") />	
		<cfset assertTrue(local.event.interceptions.size() eq 3,
				"Interceptions not loaded.")>

		
	</cffunction>

	<cffunction name="testLoadFromXmlRaw" returntype="void" output="false" access="public">

		<cfset var xml = getXml(1) />
		<cfset local.em = createObject('component','EventManager.EventManager').init(xml = xml) />
		
		<!--- oneevent --->
		<cfset local.event = local.em.getEvent('oneEvent') />
		<cfset assertTrue(local.event.type eq 'EventManager.events.Event',
				"Event Type not saved correctly") />
		
		<!--- anotherevent --->
		<cfset local.event = local.em.getEvent('anotherEvent') />
		<cfset assertTrue(local.event.type eq '#cfcroot#.mocks.Event',
				"Event Type not saved correctly") />
		
		<!--- onemoreevent --->		
		<cfset local.event = local.em.getEvent('oneMoreEvent') />
		<cfset assertTrue(local.event.type eq 'EventManager.events.Event',
				"Event Type not saved correctly") />	
		<cfset assertTrue(local.event.interceptions.size() eq 3,
				"Interceptions not loaded.")>
		
	</cffunction>
	



	
		
	<!--- Factory --->
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






	<!--- Interceptions --->	
	<cffunction name="testCreateInterception" returntype="void" output="false" access="public">
		
		<cfset var local = {} />
		<!--- em --->
		<cfset local.em = createObject('component','EventManager.EventManager').init() />	
		<!--- action --->
		<cfset local.action = local.em.createAction('stop') />
		
		<!--- default type --->
		<cfset local.result = local.em.createInterception(point = 'before', actions = [local.action]) />
		<cfset assertTrue(isinstanceOf(local.result,'EventManager.events.EventInterception'),
				"Type incorrect.")>
		<cfset assertTrue(local.result.getPoint() eq 'before',
				"Point incorrect.")>
		<cfset assertTrue(local.result.hasActions(),
				"Actions has not been added")>
				
		<!--- custom type --->				
		<cfset local.result = local.em.createInterception(point = 'each', class = '#cfcroot#.mocks.Interception') />
		<cfset assertTrue(isinstanceOf(local.result,'#cfcroot#.mocks.Interception'),
				"Type incorrect.")>
		<cfset assertTrue(local.result.getPoint() eq 'each',
				"Point incorrect.")>
		<cfset assertTrue(not local.result.hasActions(),
				"Actions count error")>
		
				
	</cffunction>

	<cffunction name="test_createInterception_fail_if_type_default_with_no_actions" returntype="void" output="false" access="public"
				mxunit:expectedException="EventManager.InterceptionEmpty">

		<cfset var local = {} />
		<!--- em --->
		<cfset local.em = createObject('component','EventManager.EventManager').init() />	
		
		<!--- default type require at least one action --->
		<cfset local.result = local.em.createInterception(point = 'before') />
		
		
	</cffunction>

	<cffunction name="testAddInterception" returntype="void" output="false" access="public">
		<cfset var local = {} />
		<cfset variables.emMock.$(method='getDebug',returns=false)>
		
		<!--- default type --->		
		<cfset variables.emMock.addEvent('oneEvent') />		
		<cfset local.interception = variables.mockBox.createMock(classname = 'EventManager.events.EventInterception') />
		
		<cfset assertTrue(variables.emMock.getEvent('oneEvent').interceptions.size() eq 0,
				"Errro in interceptions size before add.")>
		<cfset variables.emMock.addInterception('oneEvent',local.interception) />
		<cfset assertTrue(variables.emMock.getEvent('oneEvent').interceptions.size() eq 1,
				"Errro in interceptions size after add.")>
		
		
	</cffunction>

	<cffunction name="test_interception_factory_create" returntype="void" output="false" access="public">

		<cfset var local = {} />		
		<!--- debug false --->
		<cfset variables.emMock.$(method='getDebug',returns= false)/>
		
		<!--- factory --->
		<cfset local.factory = createObject('component','EventManager.factory.InterceptionFactory').init(variables.emMock) />
		<!--- event --->
		<cfset local.event = variables.mockBox.createMock(classname = 'EventManager.events.Event') />
		<!--- action --->
		<cfset local.action = variables.mockBox.createMock(classname = "EventManager.events.actions.AbstractAction") />		
		
		<!--- 
		create with defaults: 
		'before' interception 
		condition : true
		--->
		<cfset local.result = local.factory.create(point = 'before', actions = [local.action]) />
		<cfset assertTrue(isInstanceOf(local.result,'EventManager.events.AbstractEventInterception'),
				"Interception is not of the right class. #getMetaData(local.result).name#")>
		<cfset assertTrue(local.result.isConditionTrue(local.event),
				"Condition by default must be  true") />
		<cfset assertTrue(local.result.hasActions(),
				"Actions array is not empty") />				
		<cfset assertTrue(local.result.getPoint() eq 'before',
				"Point is not properly setted")>
		
		<!--- 
		create a custom type
		 --->
		<cfset local.result = local.factory.create('before','#cfcroot#.mocks.Interception') />
		<cfset assertTrue(isinstanceof(local.result,'#cfcroot#.mocks.Interception'),
				"Custom Int type error.")>
		 				 		 				
	</cffunction>

	<cffunction name="test_interception_create_illegal_point" returntype="void" output="false" access="public"
				mxunit:expectedException="EventManager.IllegalInterceptionPoint">
		
		<cfset var local = {} />		
		<!--- debug false --->
		<cfset variables.emMock.$(method='getDebug',returns= false)/>
		
		<!--- factory --->
		<cfset local.factory = createObject('component','EventManager.factory.InterceptionFactory').init(variables.emMock) />
		<!--- action --->
		<cfset local.action = variables.mockBox.createMock(classname = "EventManager.events.actions.AbstractAction") />
		
		<!--- exception --->		
		<cfset local.factory.create(point = 'not_existing_point', actions = [local.action]) />
		
	</cffunction>

	<cffunction name="test_interception_create_failing_evaluation_condition" returntype="void" output="false" access="public"
				mxunit:expectedException="EventManager.ConditionEvaluationError">
		
		<cfset var local = {} />		
		<!--- debug false --->
		<cfset variables.emMock.$(method='getDebug',returns= false)/>
		<cfset local.factory = createObject('component','EventManager.factory.InterceptionFactory').init(variables.emMock) />		
		<!--- action --->
		<cfset local.action = variables.mockBox.createMock(classname = "EventManager.events.actions.AbstractAction") />
		<!--- event --->
		<cfset local.event = variables.mockBox.createMock(classname = 'EventManager.events.Event') />
					
		<!--- exception --->					
		<cfset local.result = local.factory.create( point = 'before', condition = ' a / b', actions = [local.action]) />
		<cfset local.result.isConditionTrue(local.event) />
		
	</cffunction>	

	<cffunction name="test_interception_create_illegal_condition" returntype="void" output="false" access="public"
				mxunit:expectedException="EventManager.IllegalConditionError">
		
		<cfset var local = {} />		
		<!--- debug false --->
		<cfset variables.emMock.$(method='getDebug',returns= false)/>
		<cfset local.factory = createObject('component','EventManager.factory.InterceptionFactory').init(variables.emMock) />
		<cfset local.event = variables.mockBox.createMock(classname = 'EventManager.events.Event') />		
		<cfset local.action = variables.mockBox.createMock(classname = "EventManager.events.actions.AbstractAction") />

					
		<!--- exception --->					
		<cfset local.result = local.factory.create( point = 'before', condition = 'this', actions = [local.action]) />
		<cfset local.result.isConditionTrue(local.event) />
		
	</cffunction>	






	<!--- actions --->
	<cffunction name="testCreateAction" returntype="void" output="false" access="public">
		<cfset var local = {} />
		<!--- em --->
		<cfset local.em = createObject('component','EventManager.EventManager').init() />	
		
		<cfset local.action = local.em.createAction('stop') />
		<cfset assertTrue(isInstanceOf(local.action,'EventManager.events.actions.AbstractAction'),
				"Action wrong type.")>
		<cfset assertTrue(local.action.getName() eq 'stop',
				"Action wrong name.")>				
		
	</cffunction>	

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

	

	
	<!--- Dispacth --->
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