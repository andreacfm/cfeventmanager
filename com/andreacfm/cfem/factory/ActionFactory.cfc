<cfcomponent output="false" extends="com.andreacfm.cfem.factory.AbstractFactory">
 
	<!--- createAction --->
	<cffunction name="create" output="false" returntype="com.andreacfm.cfem.events.actions.AbstractAction">
		<cfargument name="name" required="true" type="string"/>
		<cfset var actions = getEventManager().getActions() />
		<cfset var actionClass = "" />
		<cfset var result = "" />
		<cftry>
			<cfset actionClass = actions[name] />
			<cfcatch type="any">
				<cfthrow type="com.andreacfm.cfem.NoSuchActionException" message="Action [#arguments.name#] is unknown or cannot be created.">            
			</cfcatch>
		</cftry>
		
		<cfset result = createObject('component',#actionClass#).init(argumentCollection=arguments) />
		
		<cfreturn result />		
	</cffunction>

</cfcomponent>