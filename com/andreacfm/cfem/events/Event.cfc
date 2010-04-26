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
		<cfargument name="alias" required="false" type="string" default=""/>
		
		<cfscript>
		variables.instance.name = arguments.name;
		variables.instance.data = arguments.data;
		variables.instance.target = arguments.target;
		variables.instance.mode = arguments.mode;		
		variables.instance.type = arguments.type;
		variables.instance.alias = arguments.alias;
		</cfscript>
		
		<cfreturn this/>

	</cffunction>

</cfcomponent>