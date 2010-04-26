<cfcomponent output="false" extends="com.andreacfm.cfem.factory.AbstractFactory">

	<!--- create --->
	<cffunction name="create" output="false" returntype="com.andreacfm.cfem.dispatch.Dispatcher">
		<cfargument name="event" required="false" type="com.andreacfm.cfem.events.AbstractEvent"/>
		<cfscript>
		var result = "";
		if(arguments.event.getMode() eq 'asynch'){
			result = createObject('component','#getEventManager().getConfig('AsynchDispatcher')#').init(getEventManager(),arguments.event);
		}else{
			result = createObject('component','#getEventManager().getConfig('SynchDispatcher')#').init(getEventManager(),arguments.event);		
		}
		return result;
		</cfscript>
	</cffunction>

	
</cfcomponent>
