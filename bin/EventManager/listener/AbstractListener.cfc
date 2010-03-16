<!--- /*		
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.3
Build Date:  martedì mar 16, 2010
Build:		 137

Copyright 2010 Andrea Campolonghi

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.	
			
*/--->
<cfcomponent output="false">
	
	<cfset variables.instance.autowired = false />
	
	<!---   constructor   --->
	<cffunction name="init" output="false" returntype="EventManager.events.AbstractEvent">
		<cfthrow type="EventManager.InitAbstractClassException" message="Abstract class [AbstractListener] cannot be initialized" />
	</cffunction>

	<!--- 
	execute
	Call the method on the listener object
	 --->
	<cffunction name="execute" returntype="void" output="false" access="public">
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		
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
			variables.instance.listenerObject = invokeObject(arguments.listener,arguments.initMethod);
		}else{
			variables.instance.listenerObject = arguments.listener;
		}
		</cfscript>
	</cffunction> 
	<cffunction name="getlistenerObject" access="public" returntype="Any">
		<cfreturn variables.instance.listenerObject/>
	</cffunction>

	<!--- method--->
	<cffunction name="setmethod" access="public" returntype="void">
		<cfargument name="method" type="String"/>
		<cfargument name="event" type="String"/>
		<cfscript>
		if(not len(arguments.method)){
			variables.instance.method = arguments.event;
		}else{
			variables.instance.method = arguments.method;
		}
		</cfscript>
	</cffunction> 
	<cffunction name="getmethod" access="public" returntype="String">
		<cfreturn variables.instance.method/>
	</cffunction>

	<!--- Id--->
	<cffunction name="setId" access="public" returntype="void">
		<cfargument name="Id" type="String" required="true"/>
		<cfscript>
		if(not len(id)){
			variables.instance.Id = getClass() & '.' & getMethod();
		}else{
			variables.instance.Id = arguments.Id;
		}
		</cfscript>
	</cffunction> 
	<cffunction name="getId" access="public" returntype="String">
		<cfreturn variables.instance.Id/>
	</cffunction>


	<!--- autowire--->
	<cffunction name="setautowire" access="public" returntype="void">
		<cfargument name="autowire" type="Boolean" required="true"/>
		<cfset variables.instance.autowire = autowire />
	</cffunction> 
	<cffunction name="getautowire" access="public" returntype="Boolean">
		<cfreturn variables.instance.autowire/>
	</cffunction>
		
	<!--- 
	isAutowired
	 --->
	<cffunction name="isAutowired" returntype="Boolean" output="false" access="public">
		<cfreturn variables.instance.autowired />
	</cffunction>	
	<cffunction name="setAutowired" returntype="Boolean" output="false" access="public">
		<cfargument name="status" type="Boolean">
		<cfreturn variables.instance.autowired = arguments.status />
	</cffunction>	
	
	<!--- 
	getClass
	 --->
	<cffunction name="getClass" returntype="string" output="false" access="public">
		<cfscript>
		if(not structKeyExists(variables.instance,'class')){
			variables.instance.class = getMetadata(getlistenerObject()).name;
		}
		return variables.instance.class;
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