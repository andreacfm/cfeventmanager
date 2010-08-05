<cfcomponent output="false" extends="com.andreacfm.cfem.listener.AbstractListener">
	
	<!---   constructor   --->
	<cffunction name="init" output="false" returntype="com.andreacfm.cfem.listener.AbstractListener">
		<cfargument name="listener" type="any" required="true"/>
		<cfargument name="event" type="String" required="true"/>
		<cfargument name="method" type="string" default="" />
		<cfargument name="priority" required="false" type="numeric" default="5"/>
		<cfargument name="id" type="string" default="" />
		<cfargument name="initMethod" type="string" default="init"/>
		<cfargument name="factory" type="com.andreacfm.cfem.factory.AbstractFactory"/>
		
		<cfscript>
		setMethod(arguments.method, arguments.event);	
		setListenerObject(arguments.listener,arguments.initmethod);
		setId(arguments.id);
		setPriority(arguments.priority);
		setAutowire(arguments.factory.getAutowire());
		return this;
		</cfscript>
		
		
	</cffunction>
	
	
</cfcomponent>