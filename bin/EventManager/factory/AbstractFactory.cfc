<!--- /*		
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.3
Build Date:  domenica mar 14, 2010
Build:		 123

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

<cfcomponent>
	
	<!---init--->
    <cffunction name="init" output="false" access="public" returntype="EventManager.factory.AbstractFactory">
    	<cfargument name="EventManager" type="EventManager.EventManager" required="true" />
		<cfargument name="autowire" required="false" type="boolean" default="false"/>
		<cfset setEventManager(EventManager) />
		<cfset setAutowire(arguments.autowire) />
    	<cfreturn this />
    </cffunction>
	
	<!---create--->
    <cffunction name="create" output="false" access="public" returntype="any">
    	<cfthrow type="EventManager.AbstractClassException" message="Abstract method [create] must be implemented"/>
    </cffunction>

	<!---   getEventManager   --->
	<cffunction name="getEventManager" access="public" output="false" returntype="EventManager.EventManager">
		<cfreturn variables.instance.EventManager/>
	</cffunction>
    
	<!---   setEventManager   --->
	<cffunction name="setEventManager" access="public" output="false" returntype="void">
		<cfargument name="EventManager" type="EventManager.EventManager" required="true"/>
		<cfset variables.instance.EventManager = arguments.EventManager/>
	</cffunction>
	
	
	<!--- autowireEvents --->
 	<cffunction name="autowire" access="public" output="false" returntype="boolean">
		<cfreturn variables.instance.Autowire/>
	</cffunction>
 
	<!---   setAutowireEvents   --->	
	<cffunction name="setAutowire" access="public" output="false" returntype="void">
		<cfargument name="autowire" type="boolean" required="true"/>
		<cfset variables.instance.Autowire = arguments.Autowire/>
	</cffunction>

</cfcomponent>