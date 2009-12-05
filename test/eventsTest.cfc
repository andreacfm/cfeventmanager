<cfcomponent displayname="core-bean"  extends="mxunit.framework.TestCase">

	<cfscript>		
	variables.testListener = createObject('component','cfops.core.object').init();
	injectMethod(variables.testListener,this,'alert1','alert1');
	injectMethod(variables.testListener,this,'alert2','alert2');
	injectMethod(variables.testListener,this,'manipulateData','manipulateData');
	injectMethod(variables.testListener,this,'addItems','addItems');

	variables.events = arrayNew(1);
	
		event1 = structNew();
		event1.name = "mxUnit1";
		event1.type = "EventManager.events.Event";					
		
		events.add(event1);
		
		event2 = structNew();
		event2.name = "mxUnit2";
		event2.type = "EventManager.events.Event";					

		events.add(event2);

	</cfscript>

	<!--- setup--->
	<cffunction name="setUp">

	</cffunction>

	<!--- mocks -------------------------------------------------------------------------------->
	
	<cffunction name="alert1" output="false" access="private" returntype="void">
		<cfargument name="event" type="EventManager.events.AbstractEvent" />		
		<cfset request.alert1 = structNew() />
		<cfset request.alert1[event.getData().label] = 'runned' />
	</cffunction>

	<cffunction name="alert2" output="false" access="private" returntype="void">
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		<cfset request.alert2 = structNew() />
		<cfset request.alert2[event.getData().label] = 'runned' />
	</cffunction>	

	<cffunction name="manipulateData" output="false" access="private" returntype="void">
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		
		<cfset var data = event.getdata() />
		<cfset data.string = 'ModifiedString'/>
		<cfset data.struct.test = 'ModifiedStructElement' />
		<cfset data.array[2] = 'addedByEvent' />
					
	</cffunction>
	
	<cffunction name="addItems" output="false" access="private" returntype="void">
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		<cfset var item1 = arrayNew(1) />
		<cfset var item2 = arrayNew(1) />
		<cfset event.storeItem(item1) />
		<cfset event.storeItem(item2) />
	</cffunction>

	<cffunction name="storeItem" output="false" access="private" returntype="void">
		<cfargument name="item" type="any" />
		<cfset variables.instance.items.add(arguments.item) />
	</cffunction>

	<cffunction name="getItems" output="false" access="private" returntype="array">
		<cfreturn variables.instance.items />
	</cffunction>

	<!--- tests----------------------------------------------------------------------------------------->
	
	<cffunction name="testinit" returntype="void" hint="Init with multiple events and listeners">

		<cfset var local = structNew() />
		<cfset local.arrList = arrayNew(1) />					
		<cfset local.arrList[1] = structNew()/>
		<cfset local.arrList[1].event = 'mxUnit1'/>
		<cfset local.arrList[1].listener = variables.testListener/>
		<cfset local.arrList[1].method = 'alert1'/>
		<cfset local.arrList[1].priority = 10/>					
				
		<cfset local.em = createObject('component','EventManager.eventManager').init(variables.events,local.arrList) />
		<cfset local.events = local.em.getEvents() />
		
		<!--- number or registered evenst == events injected --->		
		<cfset assertTrue(structCount(local.events) eq arrayLen(variables.events),"events have not been loaded correctly")>
		<!--- check name of the first event has listeners array attached --->
		<cfset assertTrue(isArray(local.events[variables.events[1].name].listeners),"listeners base array has not been craeted")>
		<cfset assertTrue(isSimpleValue(local.em.getAsynchDispatcher()), "asynchDispatcher config has not been loaded")/> 
					
	</cffunction>
	
 	<cffunction name="testAddEvent" returntype="void" hint="Add a single event">
		
		<cfset var local = structNew() />		
		<cfset local.em = createObject('component','EventManager.eventManager').init()/>
		<cfset local.ev = variables.events[1] />
		
		<cfset local.em.addEvent(local.ev.name,local.ev.type) />
		<cfset local.events = local.em.getEvents() />
		<cfset local.listeners = local.em.getListeners(local.ev.name) />
		
		<cfset assertTrue(structCount(local.events) eq 1,"event has not been added") />
		<cfset assertTrue(structKeyExists(local.events,local.ev.name),"event has not been added") />
		<cfset assertTrue(isArray(local.listeners) and arrayIsEmpty(local.listeners),"listeners base array has not been craeted")>		
	
	</cffunction>	

	<cffunction name="testaddEventListener" returntype="void" hint="Add a new listener to the event manager and dispatch it">
		<cfset var local = structNew() />		
		<cfset local.em = createObject('component','EventManager.eventManager').init(variables.events) />
		
		<cfset local.list = structNew()/>
		<cfset local.list.event = 'mxUnit1' />
		<cfset local.list.listener = variables.testListener />
		<cfset local.list.method = 'alert1' />
		<cfset local.list.priority = 10 />

		<cfset local.em.addEventListener(argumentCollection=local.list) />
		
		<cfset local.data = structNew() />
		<cfset local.data.label = 'testaddEventListener' />
		<cfset local.em.dispatchEvent('mxUnit1',local.data,this) />
		
		<cfset assertTrue(structKeyExists(request[local.list.method],'testAddEventListener'),"Event listener has not runned properly")>
			
		<!--- add listeners usign classpath and caching--->
		<cfset local.em = createObject('component','EventManager.eventManager').init(variables.events) />
		
		<cfset local.list = structNew()/>
		<cfset local.list.event = 'mxUnit1' />
		<cfset local.list.listener =  'cfops.core.object'/>
		<cfset local.list.method = 'getObjectId' />
		<cfset local.list.priority = 10 />
		<cfset local.list.cache = true />		

		<cfset local.em.addEventListener(argumentCollection=local.list) />

		<cfset local.list = structNew()/>
		<cfset local.list.event = 'mxUnit2' />
		<cfset local.list.listener =  'cfops.core.object'/>
		<cfset local.list.method = 'getObjectId' />
		<cfset local.list.priority = 5 />
		<cfset local.list.cache = true />

		<cfset local.em.addEventListener(argumentCollection=local.list) />
		
		<cfset local.data = structNew() />
		<cfset local.em.dispatchEvent('mxUnit1',local.data,this) />
		<cfset local.em.dispatchEvent('mxUnit2',local.data,this) />
		
		<cfset local.list1Id = local.em.getListeners('mxunit1') />
		<cfset local.list1Id = local.list1Id[1].listener.getObjectId() />
		<cfset local.list2Id = local.em.getListeners('mxunit2') />
		<cfset local.list2Id = local.list2Id[1].listener.getObjectId() />

		<cfset assertTrue(local.list1id eq local.list2id,"Listeners cachin is not working properly.")>

		<!--- add listeners usign classpath only one cache --->
		<cfset local.em = createObject('component','EventManager.eventManager').init(variables.events) />
		
		<cfset local.list = structNew()/>
		<cfset local.list.event = 'mxUnit1' />
		<cfset local.list.listener =  'cfops.core.object'/>
		<cfset local.list.method = 'getObjectId' />
		<cfset local.list.priority = 10 />
		<cfset local.list.cache = true />		

		<cfset local.em.addEventListener(argumentCollection=local.list) />

		<cfset local.list = structNew()/>
		<cfset local.list.event = 'mxUnit2' />
		<cfset local.list.listener =  'cfops.core.object'/>
		<cfset local.list.method = 'getObjectId' />
		<cfset local.list.priority = 5 />

		<cfset local.em.addEventListener(argumentCollection=local.list) />
		
		<cfset local.data = structNew() />
		<cfset local.em.dispatchEvent('mxUnit1',local.data,this) />
		<cfset local.em.dispatchEvent('mxUnit2',local.data,this) />
		
		<cfset local.list1Id = local.em.getListeners('mxunit1') />
		<cfset local.list1Id = local.list1Id[1].listener.getObjectId() />
		<cfset local.list2Id = local.em.getListeners('mxunit2') />
		<cfset local.list2Id = local.list2Id[1].listener.getObjectId() />

		<cfset assertTrue(local.list1id neq local.list2id,"Listeners cachin is not working properly.")>

	</cffunction>	

	<cffunction name="testEventWithMoreListeners" returntype="void" hint="dispatch an event that has mroe listeners and check that both are runned">
		<cfset var local = structNew() />		
		
		<cfset local.listArr = arrayNew(1) />
		
		<cfset local.list = structNew()/>
		<cfset local.list.event = 'mxUnit1' />
		<cfset local.list.listener = variables.testListener />
		<cfset local.list.method = 'alert1' />
		<cfset local.list.priority = 10 />
		
		<cfset arrayAppend(local.listArr,local.list) />

		<cfset local.list2 = structNew()/>
		<cfset local.list2.event = 'mxUnit1' />
		<cfset local.list2.listener = variables.testListener />
		<cfset local.list2.method = 'alert2' />
		<cfset local.list2.priority = 10 />
		
		<cfset arrayAppend(local.listArr,local.list2) />
		
		<cfset local.em = createObject('component','EventManager.eventManager').init(variables.events,local.listArr) />
		
		<cfset local.data = structNew() />
		<cfset local.data.label = 'testEventWithMoreListeners' />
		<cfset local.em.dispatchEvent('mxUnit1',local.data,this) />
		
		<cfset assertTrue(structKeyExists(request[local.list.method],'testEventWithMoreListeners'),"Event mxunit1 on listener alert1 did not runned")>	
		<cfset assertTrue(structKeyExists(request[local.list2.method],'testEventWithMoreListeners'),"Event mxunit1 on listener alert2 did not runned")>
							
	</cffunction>	

	<cffunction name="testlistenersPriority" returntype="void" hint="Test that the eventlistener priority is respecetd">
		<cfset var local = structNew() />		
		
		<cfset local.listArr = arrayNew(1) />
		
		<cfset local.list = structNew()/>
		<cfset local.list.event = 'mxUnit1' />
		<cfset local.list.listener = variables.testListener />
		<cfset local.list.method = 'alert1' />
		<cfset local.list.priority = 1 />
		
		<cfset arrayAppend(local.listArr,local.list) />

		<cfset local.list2 = structNew()/>
		<cfset local.list2.event = 'mxUnit1' />
		<cfset local.list2.listener = variables.testListener />
		<cfset local.list2.method = 'alert2' />
		<cfset local.list2.priority = 10 />
		
		<cfset arrayAppend(local.listArr,local.list2) />
		
		<cfset local.em = createObject('component','EventManager.eventManager').init(variables.events,local.listArr) />
		
		<cfset local.listeners = local.em.getListeners('mxUnit1') />
		
		<cfset assertEquals(10,local.listeners[1].priority,"The listeners priority has not been setted correctly")>
		
	</cffunction>

	<cffunction name="testDataManipulation" returntype="void" hint="test events that manipulate data">
		<cfset var local = structNew() />		
		
		<cfset var data = structNew() />
		<!--- if flagged by var as loval var cf8 is not able to manage them out of the function--->
		<cfset teststring = 'Test String' />		
		<cfset teststruct = StructNew() />
		<cfset testarray =  arrayNew(1) />
		
		<cfset teststruct.test = 'String in Struct Before Event'/>		
		<cfset testarray[1] = 'Test Array Element 1'/>
		
		<cfset local.em = createObject('component','EventManager.eventManager').init(variables.events) />
				
		<cfset local.listn = structNew()/>
		<cfset local.listn.event = 'mxUnit1' />
		<cfset local.listn.listener = variables.testListener />
		<cfset local.listn.method = 'manipulateData' />
		<cfset local.listn.priority = 1 />
		
		<cfset local.em.addEventListener(argumentCollection=local.listn) />
	
		<cfset data.string = teststring />
		<cfset data.array = testarray />
		<cfset data.struct = teststruct />
		
		<cfset local.em.dispatchEvent('mxunit1',data,this) />
		
		<cfset assertTrue(testarray[2] eq 'addedByEvent','Array manipulation failed.') />
		<cfset assertTrue(teststruct.test eq 'ModifiedStructElement','Struct Manipulation failed.') />
		<!--- simple values must be referred from the complex obejct that carry them --->
		<cfset assertTrue(data.string eq 'ModifiedString','simple value manipulation failed') />		
			
	</cffunction>	

	<cffunction name="testdispatchEventByObject" returntype="void" hint="Dispatch an event passing an object as argument">
		<cfset var local = structNew() />

		<!--- listener --->
		<cfset local.listenersArray = arraynew(1) />
		<cfset local.listener = structNew() />
		<cfset local.listener.event = 'mxUnit1' />
		<cfset local.listener.listener = variables.testListener />
		<cfset local.listener.method = 'addItems' />
		<cfset local.listener.priority = 1 />
		<cfset local.listenersArray.add(local.listener) />
		
		<!--- manager --->
		<cfset local.em = createObject('component','EventManager.eventManager').init(variables.events,local.listenersArray) />
		<!--- ask manager for event --->
		<cfset local.event = local.em.createEvent('mxUnit1') />
		<!--- add a property to our mock --->
		<cfset injectProperty(local.event,'items',arrayNew(1),"instance") />
		<cfset injectMethod(local.event,this,'storeItem','storeItem') />
		<cfset injectMethod(local.event,this,'getItems','getItems') />
				
		<cfset assertIsArray(local.event.getItems()) />	
		
		<cfset local.em.dispatchEvent(event=local.event) />	
		
		<cfset assertTrue(arraylen(local.event.getItems()) eq 2) />	
		
	</cffunction>

	<cffunction name="testloadXml" returntype="void" hint="test the capacity to load events and listeners from xml file">
		<cfset var local = structNew() />		
		
		<cfset local.xmlPath = '/EventManager/test/EventManager.xml' />			
		<cfset local.em = createObject('component','EventManager.eventManager').init(xmlPath=local.xmlPath) />
		
		<cfset data.label = 'testLoadXml1'>
		<cfset local.ev = local.em.createEvent('mxUnit1',data,this) />
		<cfset local.em.dispatchEvent(event=local.ev) />

		<cfset assertTrue(structKeyExists(request.alert1,'testLoadXml1')) />

		<cfset data.label = 'testLoadXml2'>
		<cfset local.ev = local.em.createEvent('mxUnit2',data,this) />
		<cfset local.em.dispatchEvent(event=local.ev) />

		<cfset assertTrue(structKeyExists(request.alert2,'testLoadXml2')) />
			
	</cffunction>

	<cffunction name="testaddEventListenerByRegex" returntype="void" hint="Add listeners using regex">
		<cfset var local = structNew() />		
		<cfset local.em = createObject('component','EventManager.eventManager').init(variables.events) />
		
		<cfset local.list = structNew()/>
		<cfset local.list.event = '\w' />
		<cfset local.list.listener = variables.testListener />
		<cfset local.list.method = 'alert1' />
		<cfset local.list.priority = 10 />

		<cfset local.em.addEventListener(argumentCollection=local.list) />
		
		<cfset local.data = structNew() />
		<cfset local.data.label = 'testaddEventListener' />
		<cfset local.em.dispatchEvent('mxUnit1',local.data,this) />
		
		<cfset assertTrue(structKeyExists(request[local.list.method],'testAddEventListener'),"Event listener has not runned properly")>
			
		<!--- add listeners usign classpath and caching--->
		<cfset local.em = createObject('component','EventManager.eventManager').init(variables.events) />
		
		<cfset local.list = structNew()/>
		<cfset local.list.event = 'mx\w*?' />
		<cfset local.list.listener =  'cfops.core.object'/>
		<cfset local.list.method = 'getObjectId' />
		<cfset local.list.priority = 10 />
		<cfset local.list.cache = true />		

		<cfset local.em.addEventListener(argumentCollection=local.list) />

		<cfset local.list = structNew()/>
		<cfset local.list.event = '2$' />
		<cfset local.list.listener =  'cfops.core.object'/>
		<cfset local.list.method = 'getObjectId' />
		<cfset local.list.priority = 5 />
		<cfset local.list.cache = true />

		<cfset local.em.addEventListener(argumentCollection=local.list) />
		
		<cfset local.data = structNew() />
		<cfset local.em.dispatchEvent('mxUnit1',local.data,this) />
		<cfset local.em.dispatchEvent('mxUnit2',local.data,this) />
		
		<cfset local.list1Id = local.em.getListeners('mxunit1') />
		<cfset local.list1Id = local.list1Id[1].listener.getObjectId() />
		<cfset local.list2Id = local.em.getListeners('mxunit2') />
		<cfset local.list2Id = local.list2Id[1].listener.getObjectId() />

		<cfset assertTrue(local.list1id eq local.list2id,"Listeners cachin is not working properly.")>

	</cffunction>	

	<cffunction name="testCounter" returntype="void" hint="test the counter and tracing to request">
		<cfset var local = structNew() />
		<cfset local.xmlPath = '/EventManager/test/EventManager.xml' />			
		<cfset local.em = createObject('component','EventManager.eventManager').init(debug=true,xmlPath=local.xmlPath) />
		<cfset local.data = {label = 'testLoadXml1'} />
		<cfset local.ev = local.em.createEvent('mxUnit1',local.data,this) />
		<cfset local.em.dispatchEvent(event=local.ev) />
		<cfset assertTrue(local.em.getEvent('mxunit1').counter eq 1,'Counter fail') />
		<cfset local.em.dispatchEvent(event=local.ev) />
		<cfset assertTrue(local.em.getEvent('mxunit1').counter eq 2,'Counter fail') />
		<cfset local.em.dispatchEvent(event=local.ev) />
		<cfset assertTrue(local.em.getEvent('mxunit1').counter eq 3,'Counter fail') />
	</cffunction>

	<cffunction name="testAsynch" returntype="void" hint="test the dispatching of asynch events">
		<cfset var local = structNew() />
		
		<!--- listener --->
		<cfset local.listenersArray = arraynew(1) />
		<cfset local.listener = structNew() />
		<cfset local.listener.event = 'mxUnit1' />
		<cfset local.listener.listener = variables.testListener />
		<cfset local.listener.method = 'addItems' />
		<cfset local.listener.priority = 1 />
		<cfset local.listenersArray.add(local.listener) />
		
		<!--- manager --->
		<cfset local.em = createObject('component','EventManager.eventManager').init(variables.events,local.listenersArray) />
		
		<!--- ask manager for asynch event --->
		<cfset local.event = local.em.createEvent(name='mxUnit1',mode="asynch") />
		
		<!--- add a property to our mock --->
		<cfset injectProperty(local.event,'items',arrayNew(1),"instance") />
		<cfset injectMethod(local.event,this,'storeItem','storeItem') />
		<cfset injectMethod(local.event,this,'getItems','getItems') />
				
		<cfset assertIsArray(local.event.getItems()) />	
		
		<cfset local.em.dispatchEvent(event=local.event) />
		<cfset assertTrue(arraylen(local.event.getItems()) neq 2) />
		<cfset sleep(1000) />	
		<cfset assertTrue(arraylen(local.event.getItems()) eq 2) />	
		
	</cffunction>
			
</cfcomponent>