<cfcomponent output="false" extends="com.andreacfm.cfem.factory.AbstractFactory">
 
	<!--- create --->
	<cffunction name="create" output="false" returntype="com.andreacfm.cfem.listener.Parser">
		<cfargument name="dir" required="true" type="string"/>
		<cfargument name="recurse" required="false" type="Boolean" default="false"/>
		
		<cfscript>
		var em = getEventManager();
		var result = createObject('component','com.andreacfm.cfem.listener.Parser').init(em,arguments.dir,arguments.recurse);
		return result;
		</cfscript>

	</cffunction>

</cfcomponent>