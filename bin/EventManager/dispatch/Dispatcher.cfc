<!--- /*		
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.1.1
Build Date:  domenica dic 20, 2009
Build:		 114

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
			
*/--->

<cfcomponent name="Dispatcher">

	<!--- Constructor --->
	<cffunction name="init" output="false" returntype="EventManager.dispatch.Dispatcher">
		<cfargument name="EventManager" type="EventManager.EventManager" required="true" />
		<cfargument name="event" type="EventManager.events.AbstractEvent" required="true"/>
		<cfscript>
		setEventManager(arguments.EventManager);
		setEvent(arguments.event);
		</cfscript>
		<cfreturn this />
	</cffunction>
	
	<!--- Dispatch --->
	<cffunction name="dispatch" returntype="void" output="false">
		<cfscript>
		var i = 0;
		var local = {};		
		local.event = getEvent();
		local.em = getEventManager();
		local.listeners = local.em.getListeners(local.event.getName());
		local.debug = local.em.getDebug();
		local.tracer = local.em.getTracer();

		for(i=1; i lte arraylen(local.listeners); i++){
			if(local.event.isActive()){
				if(i==1){
					local.event.updatePoint('before');
				}
				if(local.debug){
					local.tracer.trace('Interception','<ul><li>Point : Before</li><li>Event : #local.event.getname()#</li></ul>',local.event);
				}		
				local.listObj = local.listeners[i].listener;
				local.method = local.listeners[i].method;
				evaluate('local.listObj.#local.method#(local.event)');
				local.event.updatePoint('each');
				if(local.em.getDebug()){
					local.em.getTracer().trace('Interception','<ul><li>Point : Each</li><li>Event : #local.event.getname()#</li></ul>',local.event);
					if(local.debug){
						local.tracer.trace('Invoke Listener','Listener #getMetaData(local.listObj).name#',local.event);
					}		
				}		
				if(i==arraylen(local.listeners)){
					local.event.updatePoint('after');
					if(local.debug){
						local.tracer.trace('Interception','<ul><li>Point : After</li><li>Event : #local.event.getname()#</li></ul>',local.event);
					}		
				}
			}
		}
		</cfscript>				
	</cffunction>
   
    <!---   event   --->
	<cffunction name="getevent" access="public" output="false" returntype="EventManager.events.AbstractEvent">
		<cfreturn variables.instance.event/>
	</cffunction>
	<cffunction name="setevent" access="public" output="false" returntype="void">
		<cfargument name="event" type="EventManager.events.AbstractEvent" required="true"/>
		<cfset variables.instance.event = arguments.event/>
	</cffunction>

    <!---   EventManager   --->
	<cffunction name="getEventManager" access="public" output="false" returntype="EventManager.EventManager">
		<cfreturn variables.instance.EventManager/>
	</cffunction>
	<cffunction name="setEventManager" access="public" output="false" returntype="void">
		<cfargument name="EventManager" type="EventManager.EventManager" required="true"/>
		<cfset variables.instance.EventManager = arguments.EventManager/>
	</cffunction>


</cfcomponent>