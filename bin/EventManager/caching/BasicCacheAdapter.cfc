<cfcomponent>

	<cfset variables.instance = {} />
	<cfset variables.instance.cache = {} />

	<cffunction name="init" access="public" output="false" returntype="EventManager.caching.ICacheAdapter">
		<cfargument name="EventManager" type="EventManager.EventManager" />	
		
		<cfset setEventManager(EventManager) />
			
		<cfreturn this />	
	</cffunction>

	<cffunction name="put" output="false" returntype="void">	
		<cfargument name="key" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfargument name="timespan" type="numeric" required="false"/>
				
	</cffunction>
	
	<cffunction name="get" output="false" returntype="any">	
		<cfargument name="key" type="string" required="true" />
				
	</cffunction>
	
	<cffunction name="flush" output="false" returntype="void">	
				
	</cffunction>
	
	<cffunction name="exists" output="false" returntype="Boolean">	
		<cfargument name="key" type="string" required="true" />
				
	</cffunction>
	
	<cffunction name="remove" output="false" returntype="void">	
		<cfargument name="key" type="string" required="true" />
				
	</cffunction>

    <!---   EventManager   --->
	<cffunction name="getEventManager" access="public" output="false" returntype="EventManager.EventManager">
		<cfreturn variables.instance.EventManager/>
	</cffunction>
	<cffunction name="setEventManager" access="public" output="false" returntype="void">
		<cfargument name="EventManager" type="EventManager.EventManager" required="true"/>
		<cfset variables.instance.EventManager = arguments.EventManager/>
	</cffunction>

</cfcomponent>