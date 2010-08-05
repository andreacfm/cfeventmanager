<cfcomponent output="false" extends="com.andreacfm.cfem.factory.AbstractFactory">
 
	<!--- createListener --->
	<cffunction name="create" output="false" returntype="com.andreacfm.cfem.listener.AbstractListener">
		<cfargument name="listener" type="any" required="true"/>
		<cfargument name="event" type="String" required="true"/>
		<cfargument name="priority" required="false" type="numeric" default="5"/>
		<cfargument name="method" type="string" default="" />
		<cfargument name="id" type="string" default="" />
		<cfargument name="initMethod" type="string" default="init"/>
		<cfscript>
		var class = getEventManager().getConfig('defaultBaseListenerClass');
		var obj = "";
		arguments.factory = this;
		obj = createObject('component',class).init(argumentCollection=arguments);
		</cfscript>
		<cfreturn obj />		
	</cffunction>

</cfcomponent>