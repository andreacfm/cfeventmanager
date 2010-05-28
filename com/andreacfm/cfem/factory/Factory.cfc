<cfcomponent>
	
	<cfset variables.instance.factories = {} />
	
	<!---init--->
    <cffunction name="init" output="false" access="public" returntype="com.andreacfm.cfem.factory.Factory">
    	<cfreturn this />
    </cffunction>
	
	<!---addFactory--->
    <cffunction name="addFactory" output="false" access="public" returntype="void">
    	<cfargument name="factoryName" required="true" type="string" />
		<cfargument name="factory" required="true" type="com.andreacfm.cfem.factory.AbstractFactory" />
		
		<cfset variables.instance.factories[arguments.factoryName] = arguments.factory />
		
    </cffunction>

	<!---getFactory--->
    <cffunction name="getFactory" output="false" access="public" returntype="com.andreacfm.cfem.factory.AbstractFactory">
    	<cfargument name="factoryName" required="true" type="string" />
    	<cfreturn variables.instance.factories[arguments.factoryName] />
    </cffunction>
	
	<!---createEvent--->
    <cffunction name="createEvent" output="false" access="public" returntype="com.andreacfm.cfem.events.AbstractEvent">
    	<cfreturn getFactory('EventFactory').create(argumentCollection=arguments)/>
    </cffunction>
	
	<!---createDispatcher--->
    <cffunction name="createDispatcher" output="false" access="public" returntype="com.andreacfm.cfem.dispatch.Dispatcher">
    	<cfreturn getFactory('DispatcherFactory').create(argumentCollection=arguments)/>
    </cffunction>
	
	<!---createAction--->
    <cffunction name="createAction" output="false" access="public" returntype="com.andreacfm.cfem.events.actions.AbstractAction">
    	<cfreturn getFactory('ActionFactory').create(argumentCollection=arguments)/>
    </cffunction>
	
	<!---createInterception--->
    <cffunction name="createInterception" output="false" access="public" returntype="com.andreacfm.cfem.events.AbstractEventInterception">
    	<cfreturn getFactory('InterceptionFactory').create(argumentCollection=arguments)/>
    </cffunction>

	<!---createListener--->
    <cffunction name="createListener" output="false" access="public" returntype="com.andreacfm.cfem.listener.AbstractListener">
    	<cfreturn getFactory('ListenerFactory').create(argumentCollection=arguments)/>
    </cffunction>

	<!---createListenerParser--->
    <cffunction name="createListenerParser" output="false" access="public" returntype="com.andreacfm.cfem.listener.Parser">
    	<cfreturn getFactory('ListenerParserFactory').create(argumentCollection=arguments)/>
    </cffunction>

</cfcomponent>