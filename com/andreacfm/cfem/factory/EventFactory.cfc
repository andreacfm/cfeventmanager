<cfcomponent output="false" extends="com.andreacfm.cfem.factory.AbstractFactory">

	<!---create--->
	<cffunction name="create" output="false" returntype="com.andreacfm.cfem.events.AbstractEvent">
		<cfargument name="name" required="true" type="string"/>
		<cfargument name="data" required="false" type="struct" default="#structNew()#"/>		
		<cfargument name="target" required="false" type="any" default="" />
		<cfargument name="mode" required="false" type="string" default="synch" />
		<cfscript>
		var local = {};	
		
		local.event = getEventManager().getEvent(arguments.name);
		arguments.type = local.event.type;
		
		local.newInstance = createObject('component','#arguments.type#').init(argumentCollection=arguments);
		local.newInstance.setEM(getEventManager());
		
		if(arrayLen(local.event.interceptions) gt 0){
			local.it = local.event.interceptions.iterator();
			while(local.it.hasNext()){
				local.newInstance.registerObserver(local.it.next());
			}
		}	
		
		if(getAutowire()){
			getEventManager().getBeanInjector().autowire(local.newInstance);		
		}	
		return local.newInstance;
		</cfscript>
	</cffunction>

</cfcomponent>