<cfcomponent>

	<cffunction name="init" output="false" access="public">
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="beforeWelcomeOutput" access="public" output="false">    
		<cfargument name="event" type="com.andreacfm.cfem.events.Event" />
		
		<cfset myName = 'Andrea' />
		<cfset event.getData().name = myName />
	
	</cffunction>	
		
</cfcomponent>