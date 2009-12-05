<cfcomponent displayname="core-bean"  extends="mxunit.framework.TestCase">


	<!--- setup--->
	<cffunction name="setUp">
		<cfscript>		
		EM = createObject('component','EventManager.eventManager').init(xmlPath='/EventManager/test/eventmanager.xml');
		</cfscript>
	</cffunction>

	
	<cffunction name="testinit" returntype="void" hint="Init with multiple events and listeners">
		
		<cfset var events = EM.getEvents() />
		
		<!--- DEFAULTS --->
		<cfset assertTrue(not EM.getDebug(),'Debug default mode is not false') />
		<cfset assertTrue(EM.getScope() eq 'request','Debug default scope is not request') />
		<cfset assertTrue(EM.getConfig('mapping') eq '','Debug default mapping is not /')/>
		
		<!--- CONFIGS --->
		<cfset assertTrue(EM.getConfig('AsynchDispatcher') eq 'EventManager.dispatch.AsynchDispatcher','Error in config loading') />
		<cfset assertTrue(EM.getConfig('SynchDispatcher') eq 'EventManager.dispatch.SynchDispatcher','Error in config loading') />
		<cfset assertTrue(isStruct(EM.getConfig('actions')),'Error in config loading') />		

		<!--- check events registered --->		
		<cfset assertTrue(structCount(events) gt 0,'Events not loaded correctly') />
		<cfset assertTrue(structKeyExists(events,'test1') and structKeyExists(events,'addItem') and structKeyExists(events,'resetItems'),'Error in events load.') />
		
		<!--- event test1 do not declare a class. Check that the default is applied --->
		<cfset assertTrue(events['test1'].type eq 'EventManager.events.Event','Error in registering an event with default type') />

		<!--- event addItem declare a custom class. --->
		<cfset assertTrue(events['addItem'].type eq 'EventManager.test.Event','Error in registering an event with custom type') />
				
		<!--- Check that custom listener id are registered correctly --->
		<cfset local.value = EM.getListeners('AddItem') />		
		<cfset assertTrue(local.value[1].id eq 'addItemsId','Custom listener id not save correctly') />

		<!--- Check that custom method registered correctly --->
		<cfset local.value = EM.getListeners('AddItem') />		
		<cfset assertTrue(local.value[1].method eq 'addItem','Custom listener method not save correctly') />

		<!--- Check that default method registered correctly --->
		<cfset local.value = EM.getListeners('ResetItems') />		
		<cfset assertTrue(local.value[1].method eq 'ResetItems','Deafult listener method not save correctly') />
		
		
		
		<!--------------------------------------   NEW MANAGER ---------------------------------------------------->
		
		<!--- Add Events Listeners via Init mode / change defaults --->
		<cfset local.eventsArray = [
				{name = 'test1'},
				{name = 'test2'}] />
		<cfset local.listenerArray=[
				{id="test1id", event='test1',listener = 'EventManager.test.listener'},
				{id="test2id", event='test2',listener = 'EventManager.test.listener'}				
		]/>
		<cfset EM = createObject('component','EventManager.eventManager').init(
				events = local.eventsArray, 
				listeners = local.listenerArray,
				debug = true,
				scope = 'instance',
				autowireEvents = true
				)/>	
		
		<cfset events = EM.getEvents() />
		
		<!--- check events registered --->		
		<cfset assertTrue(structCount(events) eq 2,'Events not loaded correctly') />
		<cfset assertTrue(structKeyExists(events,'test1') and structKeyExists(events,'test2'),'Error in events load.') />

		<!--- Check listener are registered correctly --->
		<cfset local.value = EM.getListeners('test1') />		
		<cfset assertTrue(local.value[1].id eq 'test1id','Error in listener load') />
		<cfset local.value = EM.getListeners('test2') />		
		<cfset assertTrue(local.value[1].id eq 'test2id','Error in listenr load') />
			
											
	</cffunction>
	
					
</cfcomponent>