<cfcomponent output="false" extends="com.andreacfm.cfem.factory.AbstractFactory">

	<!--- create --->
	<cffunction name="create" output="false" returntype="com.andreacfm.cfem.events.AbstractEventInterception">
		<cfargument name="point" required="true" type="string"/>
		<cfargument name="class" required="false" type="string" default="#getEventManager().getConfig('defaultInterceptionClass')#"/>
		<cfargument name="condition" required="false" type="string" default="true"/>
		<cfargument name="actions" required="false" type="array" default="#arrayNew(1)#"/>
		
		<cfscript>
		var result = "";
		
		// a default interception type must have at least one action	
		if(arguments.class eq getEventManager().getConfig('defaultInterceptionClass')){
			if(not arguments.actions.size()){
				getEventManager().throw('A default interception type must declare at least one action','com.andreacfm.cfem.InterceptionEmpty');		
			}
		}
		result = createObject('component',arguments.class).init(getEventManager(),arguments.point,arguments.condition);
		result.addActions(arguments.actions);
			        
		return result;
		</cfscript>

	</cffunction>

</cfcomponent>