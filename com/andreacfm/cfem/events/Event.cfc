<cfcomponent 
	output="false" 
	extends="AbstractEvent"
	hint="Basic event class implements the AbstractEvent interface and nothing more. Use it as safe base to build custom events on.">
	
	<!---   Implement Abstract Constructor   --->
	<cffunction name="init" output="false" returntype="com.andreacfm.cfem.events.Event">
		<cfargument name="name" required="true" type="string"/>
		<cfargument name="data" required="true" type="struct"/>		
		<cfargument name="target" required="true" type="any"/>
		<cfargument name="mode" required="true" type="string"/>
		<cfargument name="type" required="true" type="string"/>
		
		<cfscript>
		variables.name = name;
		variables.data = data;
		variables.target = target;
		variables.mode = mode;		
		variables.type = type;
		</cfscript>
		
		<cfreturn this/>

	</cffunction>

</cfcomponent>