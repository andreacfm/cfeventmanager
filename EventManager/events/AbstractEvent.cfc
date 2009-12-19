<!--- 
				
Project:     Cf Event Manager http://www.cfeventmanager.com
Author:      Andrea Campolonghi <acampolonghi@gmail.com>
Version:     1.0
Build Date:  2009/10/25 16:16
Build:		 25

Copyright 2009 Andrea Campolonghi

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.	
						
--->

<cfcomponent name="AbstractEvent" implements="EventManager.util.IObservable">

	<cfproperty name="name" type="string"/>
	<cfproperty name="data" type="struct"/>
	<cfproperty name="target" type="any"/>
	<cfproperty name="isActive" type="boolean"/>
	<cfproperty name="type" type="string"/>
	<cfproperty name="mode" type="string"/>
	
	<cfscript>
	variables.instance.state = true ;
	variables.instance.point = "";
	variables.instance.observers = createObject('java','java.util.ArrayList').init();
	</cfscript>
	
	<!---   constructor   --->
	<cffunction name="init" output="false" returntype="EventManager.events.AbstractEvent">
		<cfthrow type="EventManager.InitAbstractClassException" message="Abstract class [abstractEvent] cannot be initialized" />
	</cffunction>

	<!-----------------------------   public   ----------------------------------->
	
	<!---   name   --->
	<cffunction name="getName" access="public" output="false" returntype="string">
		<cfreturn variables.instance.name/>
	</cffunction>

	<!---   data   --->
	<cffunction name="getData" access="public" output="false" returntype="struct">
		<cfreturn variables.instance.data/>
	</cffunction>
	<cffunction name="setData" access="public" output="false" returntype="void">
		<cfargument name="data" type="struct" required="true"/>
		<cfset variables.instance.data = arguments.data/>
	</cffunction>

	<!---   target   --->
	<cffunction name="getTarget" access="public" output="false" returntype="any">
		<cfreturn variables.instance.target/>
	</cffunction>

	<!---   type   --->
	<cffunction name="getType" access="public" output="false" returntype="string">
		<cfreturn variables.instance.type/>
	</cffunction>

	<!---   mode   --->
	<cffunction name="getMode" access="public" output="false" returntype="string">
		<cfreturn variables.instance.mode/>
	</cffunction>

	<!---   stopPropagation   --->
	<cffunction name="stopPropagation" access="public" output="false" returntype="void">
		<cfset variables.instance.state = false />
	</cffunction>

	<!---   isActive   --->
	<cffunction name="isActive" access="public" output="false" returntype="boolean">
		<cfreturn variables.instance.state />
	</cffunction>

	<!---   EM   --->
	<cffunction name="getEM" access="public" output="false" returntype="EventManager.EventManager">
		<cfreturn variables.instance.EM/>
	</cffunction>
	<cffunction name="setEM" access="public" output="false" returntype="void">
		<cfargument name="EM" type="EventManager.EventManager" required="true"/>
		<cfset variables.instance.EM = arguments.EM/>	
	</cffunction>

	<!---getEventId--->
	<cffunction name="getEventId" returntype="string" output="false" hint="Return the identityHashCode of the java object underling the cfc instance.">
		<cfreturn createObject("java", "java.lang.System").identityHashCode(this)/>
	</cffunction>

	<!---updatePoint--->
	<cffunction name="updatePoint" output="false" returntype="void">
		<cfargument name="point" type="String" />
		<cfset variables.instance.point = arguments.point/>
		<cfset notifyObservers(this) />
	</cffunction>

	<cffunction name="getPoint" returntype="string" output="false">
		<cfreturn variables.instance.point />
	</cffunction>
	
	<!---   implement IObservable   --->
	<cffunction name="notifyObservers" access="public">
		<cfloop array="#variables.instance.observers#" index="int">
			<cfif int.getPoint() eq getPoint()>
				<cfset int.update(this) />
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="registerObserver" access="public">
		<cfargument name="observer" type="EventManager.util.IObserver"/>
		<cfset variables.instance.observers.add(observer) />
	</cffunction>
	
</cfcomponent>