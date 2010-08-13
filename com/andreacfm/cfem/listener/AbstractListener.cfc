<cfcomponent output="false">
	
	<cfset variables.autowired = false />
	
	<!---   constructor   --->
	<cffunction name="init" output="false" returntype="com.andreacfm.cfem.events.AbstractEvent">
		<cfthrow type="com.andreacfm.cfem.InitAbstractClassException" message="Abstract class [AbstractListener] cannot be initialized" />
	</cffunction>

	<!--- 
	execute
	Call the method on the listener object
	 --->
	<cffunction name="execute" returntype="void" output="false" access="public">
		<cfargument name="event" type="com.andreacfm.cfem.events.AbstractEvent" />
		
		<cfscript>
			var listener = getListenerObject();
			var method = getMethod();		
			evaluate('listener.#method#(event)');	
		</cfscript>

	</cffunction>
	
	
	<!--- listenerObject--->
	<cffunction name="setlistenerObject" access="public" returntype="void">
		<cfargument name="listener" type="Any" required="true"/>
		<cfargument name="initmethod" type="String" required="true"/>
		<cfscript>
		if(isSimpleValue(arguments.listener)){
			variables.listenerObject = invokeObject(arguments.listener,arguments.initMethod);
		}else{
			variables.listenerObject = arguments.listener;
		}
		</cfscript>
	</cffunction> 
	<cffunction name="getlistenerObject" access="public" returntype="Any">
		<cfreturn variables.listenerObject/>
	</cffunction>

	<!--- method--->
	<cffunction name="setmethod" access="public" returntype="void">
		<cfargument name="method" type="String"/>
		<cfargument name="event" type="String"/>
		<cfscript>
		if(not len(arguments.method)){
			variables.method = arguments.event;
		}else{
			variables.method = arguments.method;
		}
		</cfscript>
	</cffunction> 
	<cffunction name="getmethod" access="public" returntype="String">
		<cfreturn variables.method/>
	</cffunction>

	<!--- Id--->
	<cffunction name="setId" access="public" returntype="void">
		<cfargument name="Id" type="String" required="true"/>
		<cfscript>
		if(not len(id)){
			variables.Id = getClass() & '.' & getMethod();
		}else{
			variables.Id = arguments.Id;
		}
		</cfscript>
	</cffunction> 
	<cffunction name="getId" access="public" returntype="String">
		<cfreturn variables.Id/>
	</cffunction>

	<!--- priority--->
	<cffunction name="setpriority" access="public" returntype="void">
		<cfargument name="priority" type="Numeric" required="true"/>
		<cfset variables.priority = priority />
	</cffunction> 
	<cffunction name="getpriority" access="public" returntype="Numeric">
		<cfreturn variables.priority/>
	</cffunction>

	<!--- autowire--->
	<cffunction name="setautowire" access="public" returntype="void">
		<cfargument name="autowire" type="Boolean" required="true"/>
		<cfset variables.autowire = autowire />
	</cffunction> 
	<cffunction name="getautowire" access="public" returntype="Boolean">
		<cfreturn variables.autowire/>
	</cffunction>
		
	<!--- 
	isAutowired
	 --->
	<cffunction name="isAutowired" returntype="Boolean" output="false" access="public">
		<cfreturn variables.autowired />
	</cffunction>	
	<cffunction name="setAutowired" returntype="Boolean" output="false" access="public">
		<cfargument name="status" type="Boolean">
		<cfset variables.autowired = arguments.status />
	</cffunction>	
	
	<!--- 
	getClass
	 --->
	<cffunction name="getClass" returntype="string" output="false" access="public">
		<cfscript>
		if(not structKeyExists(variables,'class')){
			variables.class = getMetadata(getlistenerObject()).name;
		}
		return variables.class;
		</cfscript>
	</cffunction>

	<!---
	invokeObject
	--->
	<cffunction name="invokeObject" output="false" returntype="any">
		<cfargument name="listener" type="string" required="true" />
		<cfargument name="method" type="string" required="true" />		
		<cfset var result = "" />
		<cfinvoke component="#arguments.listener#" method="#arguments.method#" returnvariable="result"/>
		<cfreturn result />
	</cffunction>
	
</cfcomponent>