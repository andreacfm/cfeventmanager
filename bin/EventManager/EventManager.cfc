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

<cfcomponent 
	output="false" 
	name="EventManager" 
	hint="Event Manager Class.">

	<cfscript>
	variables.instance.events = structNew();
	variables.instance.config = structNew();
	variables.instance.cachedListeners = structNew();
	variables.instance.helpers = structNew();
	variables.instance.Sorter = createObject('component','EventManager.util.SortableListeners').init();
	</cfscript>
	
	<!--- Constructor --->
	<cffunction name="init" output="false" returntype="EventManager.EventManager" hint="Constructor" >
		<cfargument name="events" required="false" type="array" default="#arrayNew(1)#"/>
		<cfargument name="listeners" required="false" type="array" default="#arrayNew(1)#"/>
		<cfargument name="xmlPath" required="false" type="string" default="" hint="relative path"/>
		<cfargument name="autowire" required="false" type="boolean" default="false"/>
		<cfargument name="debug" required="false" type="boolean" default="false"/>
		<cfargument name="scope" required="false" type="string" default="request"/>
		<cfscript>
		//create factories
		var factory = createObject('component','EventManager.factory.Factory').init();
		var EventFactory = createObject('component','EventManager.factory.EventFactory').init(this,arguments.autowire);
		var DispatcherFactory = createObject('component','EventManager.factory.DispatcherFactory').init(this,arguments.autowire);
		var ActionFactory = createObject('component','EventManager.factory.ActionFactory').init(this,arguments.autowire);
		var InterceptionFactory = createObject('component','EventManager.factory.InterceptionFactory').init(this,arguments.autowire);
		
		factory.addFactory('EventFactory',EventFactory);
		factory.addFactory('DispatcherFactory',DispatcherFactory);
		factory.addFactory('ActionFactory',ActionFactory);
		factory.addFactory('InterceptionFactory',InterceptionFactory);
		
		setFactory(factory);
		
		//Load System Configs
		loadConfig('/EventManager/config/eventmanager.xml.cfm');
		//save the debug option. The debug setter load the Tracer. 
		setDebug(arguments.debug,arguments.scope);
		//Load events
		setEvents(arguments.events);
		//Load xml
		loadXml(arguments.xmlPath);
		//load listeners (listeners are always at final)
		setListeners(arguments.listeners);
		
		return this;
		</cfscript>			
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->

	<!---addEvent--->
	<cffunction name="addEvent" output="false" returntype="void" hint="Register a new Event">
		<cfargument name="name" required="true" type="string" />
		<cfargument name="type" required="false" type="string" default="#getconfig('defaultBaseEventClass')#" />		
		<cfscript>
		if(not eventExists(arguments.name)){
			variables.instance.events['#name#'] = structNew();
			variables.instance.events['#name#'].type = arguments.type;
			variables.instance.events['#name#'].listeners = arrayNew(1);
			variables.instance.events['#name#'].interceptions = arrayNew(1);
			variables.instance.events['#name#'].counter = 0 ;
		}else{
			throw('Cannot register a duplicate Event. The event #arguments.name# already exists.','EventManager.duplicateEventsExeption');
		}
		if(getDebug()){
			getTracer().trace('Adding Event','Registered event #arguments.name#');
		}
		</cfscript>
	</cffunction>

	<!---addEventListener --->
	<cffunction name="addEventListener" output="false" returntype="void" hint="Register a listener to respond to a specific event invocation.">
		<cfargument name="event" required="true" type="string" />
		<cfargument name="listener" required="true" type="any" />
		<cfargument name="id" required="false" type="string" default="listener-#hash(randRange(1,99999999) & now())#"/>
		<cfargument name="method" required="false" type="string" default=""/>
		<cfargument name="priority" required="false" type="numeric" default="1"/>
		<cfargument name="initMethod" required="false" type="string" default="init"/>
		<cfargument name="cache" required="false" type="boolean" default="true"/>		
		<cfscript>
		var local = structNew();
		/* registered events */
		local.events = getEvents();
		local.sorter = getSorter();
		
		for(item in local.events){
			
			local.match = reFindNoCase(arguments.event,item,1,true);
			
			if(local.match.len[1] gt 0){
				
				/* if the method has not been passed set eventName as default*/
				if(arguments.method eq ""){
					arguments.method = item;
				}
				
				/* If the object passed is path try to see if we have a cached copy to push into the events array.
				   Otherwise create a copy store it for future use and push it into array */	 
				if(not isObject(arguments.listener) and not listenerExists(arguments.listener) and arguments.cache){
		
					variables.instance.cachedListeners['#arguments.listener#'] = invokeObject(arguments.listener,arguments.initMethod);
					arguments.listener = variables.instance.cachedListeners['#arguments.listener#'];
				
				/* refuse to use previous cached instance and craete a new one */
				}else if(not isObject(arguments.listener) and not arguments.cache){
		
					arguments.listener = invokeObject(arguments.listener,arguments.initMethod);
		
				/* cached copy exists and cache is true so just add reference */
				}else if( not isObject(arguments.listener) and listenerExists(arguments.listener ) and arguments.cache){
		
					arguments.listener = variables.instance.cachedListeners['#arguments.listener#'];
		
				}
				
				/* save explicitly the class path for the listener object. This will make easier unsubscribe operations when implemented */	
				arguments.listener.listenerClass = getmetadata(arguments.listener).name;
		
				local.events[item]['listeners'].add(arguments);
				
				local.events[item]['listeners'] = local.sorter.sortArray(local.events[item]['listeners'],'LT');	
				
				if(getDebug()){
					getTracer().trace('Adding Listener','<ul><li>Added Listener id {#arguments.id#}</li><li>Event #arguments.event#</li><li>Priority : #arguments.priority#</li></ul>');
				}		
							
			} 
			
		}

		</cfscript>		

	</cffunction>
	
	<!---removeEventListener--->
    <cffunction name="removeEventListener" output="false" access="public" returntype="void">
   		<cfargument name="id" required="false" type="string"/>
		<cfargument name="event" required="true" type="string" />
 		
		<cfscript>
		var listeners = getListeners(arguments.event);
		var iterator = listeners.iterator();
		var item = "";
		while(iterator.hasNext()){
			item = iterator.next();
			if(item.id eq arguments.id){
				iterator.remove();
			}
		}
		</cfscript>
    
    </cffunction>

	<!---   events   --->
	<cffunction name="getevents" access="public" output="false" returntype="struct">
		<cfreturn variables.instance.events/>
	</cffunction>	
	<cffunction name="setevents" access="public" output="false" returntype="void">
		<cfargument name="events" type="array" required="true"/>		
		<cfscript>
			/* event is never overwritten, must be explicitly delated */
			for(i = 1; i <= arraylen(arguments.events); i++){
				if(not eventExists(arguments.events[i].name)){
					if(structKeyExists(arguments.events[i],'type')){
						this.addEvent(arguments.events[i].name,arguments.events[i].type);
					}else{
						this.addEvent(arguments.events[i].name);
					}
				}
			}			
		</cfscript>
	</cffunction>

	<!---   listeners   --->
	<cffunction name="getlisteners" access="public" output="false" returntype="array">
		<cfargument name="eventname" type="string" required="true"/>
		<cfscript>
			var event = getEvent(arguments.eventName);
			return event.listeners;
		</cfscript>
	</cffunction>
	<cffunction name="setlisteners" access="public" output="false" returntype="void">
		<cfargument name="listeners" type="array" required="true"/>		
		<cfset var listArr = arguments.listeners />
		<cfloop from="1" to="#arrayLen(listArr)#" index="i">
			<cfset addEventListener(argumentCollection= listArr[i])/>			
		</cfloop>	
		
	</cffunction>

	<!---createEvent--->
	<cffunction name="createEvent" output="false" returntype="EventManager.events.AbstractEvent">
		<cfargument name="name" required="true" type="string"/>
		<cfargument name="data" required="false" type="struct" default="#structNew()#"/>		
		<cfargument name="target" required="false" type="any" default="" />
		<cfargument name="mode" required="false" type="string" default="synch" />
		<cfscript>
		return getFactory().createEvent(argumentCollection=arguments);
		</cfscript>
	</cffunction>

	<!---getEvent--->
	<cffunction name="getEvent" output="false" returntype="struct">
		<cfargument name="eventname" type="string" required="true"/>
		<cfscript>
		if(not eventExists(arguments.eventname)){
			throw('The event #arguments.eventname# do not exists!','EventManager.noSuchEventExeption');			
		}
		return variables.instance.events[arguments.eventname];
		</cfscript>
	</cffunction>
	
	<!---dispatchEvent--->
	<cffunction name="dispatchEvent" output="false" returntype="void">
		<cfargument name="name" required="false" type="string" default="Event" />
		<cfargument name="data" required="false" type="struct" default="#structNew()#"/>		
		<cfargument name="target" required="false" type="any" default="" />
		<cfargument name="mode" required="false" type="string" default="synch" />
		<cfargument name="event" required="false" type="EventManager.events.AbstractEvent"/>
		
		<cfscript>	
		var local = structNew();
		local.debug = getDebug();
		
		/*if is passed an object as event argument*/
		if(structKeyexists(arguments,'event') and isObject(arguments.event)){
			local.eventObj = arguments.event;
			arguments.name = local.eventObj.getName();
		}else{
			/* be sure event exists */	
			local.eventObj = getEvent(arguments.name);			
		}
		
		if(arraylen(getlisteners(arguments.name))){
			//if event object was not passed build it
			if(not structKeyExists(local,'eventObj')){
				local.eventObj = getFactory().createEvent(name=arguments.name,data=arguments.data,target=arguments.target,mode=arguments.mode);
			}
			/*really dispatch event only if there are listeners. 
			If not avoid the overhead.*/
			getFactory().createDispatcher(local.eventObj).dispatch();
		}
		
		if(local.debug){
			getTracer().trace('Dispatching Event','Dispatched Event #arguments.name#',local.eventObj,'dispatch');
		}				
		</cfscript>	

	</cffunction>
	
	<!---loadConfig--->
	<cffunction name="loadConfig" output="false" returntype="void">
		<cfargument name="path" required="true" type="string" />
		<cfscript>
		var local = structNew();	
		local.path = expandPath(arguments.path);
		
		if(fileExists(local.path)){
			local.output = fileRead(local.path);
			if(isXml(local.output)){
				local.xml = xmlParse(local.output);
				// add Configs
				local.configs = xmlSearch(local.xml,'/event-manager/configs/config');
				if(arraylen(local.configs)){
					for(i=1; i <= arraylen(local.configs); i++){
						variables.instance.config[local.configs[i].xmlAttributes.name] = trim(local.configs[i].xmlText);
					}
				}					
				local.actions = xmlSearch(local.xml,'/event-manager/actions/action');
				if(arraylen(local.actions)){
					variables.instance.config['actions'] = {};
					for(i=1; i <= arraylen(local.actions); i++){
						variables.instance.config.actions[local.actions[i].xmlAttributes.name] = local.actions[i].xmlAttributes.class;
					}
				}					

			}else{					
					throw('Xml file #local.Path# is not valid.','EventManager.xmlInvalidException');
			} 
		}
		</cfscript>
	</cffunction>
		
	<!---loadXml--->
	<cffunction name="loadXml" output="false" returntype="void">
		<cfargument name="path" required="true" type="string" />
		<cfscript>
		var i = "";
		var j = "";
		var t = "";
		var local = structNew();	
		local.path = expandPath(arguments.path);
		
		if(fileExists(local.path)){
			local.output = fileRead(local.path);
			if(isXml(local.output)){
				local.xml = xmlParse(local.output);
				// if there are configs load them
				local.configs = xmlSearch(local.xml,'/event-manager/configs/config');
				if(arraylen(local.configs)){
					loadConfig(arguments.path);
				}
				// add Events
				local.events = xmlSearch(local.xml,'/event-manager/events/event');
				if(arraylen(local.events)){
					for(i=1; i <= arraylen(local.events); i++){
						if(structKeyExists(local.events[i].xmlAttributes,'type')){
							addEvent(local.events[i].xmlAttributes.name,local.events[i].xmlAttributes.type);
						}else{
							addEvent(local.events[i].xmlAttributes.name);
						}
						if(arrayLen(local.events[i].xmlChildren) gt 0){
							local.interceptions = local.events[i].xmlChildren;
							for(j=1; j <= arraylen(local.interceptions); j++){
								if(local.interceptions[j].xmlName eq 'interception'){
									
									local.collection = {};
									local.collection.condition = "";
									local.collection.class = getConfig('defaultInterceptionClass');
									local.collection.point = local.interceptions[j].xmlAttributes.point;
									
									/*check if is passed a custom class*/
									if(structKeyExists(local.interceptions[j].xmlAttributes,'class')){
										local.collection.class = local.interceptions[j].xmlAttributes.class;
									}
									if(arrayLen(local.interceptions[j].xmlChildren) eq 0){
										throw('EventManager.InterceptionEmpty','An interception must declare at least one action');
									}else{
										local.interChd = local.interceptions[j].xmlChildren;
										for(t=1; t <= arraylen(local.interChd); t++){
											if(local.interChd[t].xmlName eq 'condition'){
												local.collection.condition = local.interChd[t].xmlText;
											}
										}	
										local.interception = getFactory().createInterception(argumentCollection=local.collection);
										for(t=1; t <= arraylen(local.interChd); t++){										
											if(local.interChd[t].xmlName eq 'action'){
												local.interception.addAction(getFactory().createAction(argumentCollection=local.interChd[t].xmlAttributes));
											}
										}
										getEvent(local.events[i].xmlAttributes.name).interceptions.add(local.interception);
									}
								}
							}
						}	
					}
				}

				// add listeners
				local.lists = xmlSearch(local.xml,'/event-manager/listeners/listener');
				if(arraylen(local.lists)){
					for(i=1; i <= arraylen(local.lists); i++){
							local.args = {
								event = local.lists[i].xmlAttributes.event,
								listener = local.lists[i].xmlAttributes.listener
							};
							if(structKeyExists(local.lists[i].xmlAttributes,'method')){
								local.args['method'] = local.lists[i].xmlAttributes.method;
							};
							if(structKeyExists(local.lists[i].xmlAttributes,'id')){
								local.args['id'] = local.lists[i].xmlAttributes.id;
							};
							if(structKeyExists(local.lists[i].xmlAttributes,'priority')){
								local.args['priority'] = local.lists[i].xmlAttributes.priority;
							};
							if(structKeyExists(local.lists[i].xmlAttributes,'initMethod')){
								local.args['initMethod'] = local.lists[i].xmlAttributes.initMethod;
							};
							if(structKeyExists(local.lists[i].xmlAttributes,'cache')){
								local.args['cache'] = local.lists[i].xmlAttributes.cache;
							};							
						addEventListener(argumentCollection=local.args);
					}
				}
					
			}else{					
					throw('Xml file #local.Path# is not valid.','EventManager.xmlInvalidException');
			} 
		}
		</cfscript>
	</cffunction>

	<!---listenerExists--->
	<cffunction name="listenerExists" access="public" output="false" returntype="boolean" hint="check from a class path if exist a listener cached in memory">
		<cfargument name="class" type="string" required="true"/>
		<cfscript>
			var result = true;
			if(not structKeyExists(variables.instance.cachedListeners,arguments.class)){
				result = false;
			}
			return result;
		</cfscript>		
	</cffunction>

	<!---eventExists--->
	<cffunction name="eventExists" output="false" returntype="boolean" access="public">
		<cfargument name="eventname" type="string" required="true"/>
		<cfscript>
			var result = true;
			if(not structKeyExists(variables.instance.events,arguments.eventname)){
				result = false;
			}
			return result;
		</cfscript>		
	</cffunction>

    <!---   Sorter   --->
	<cffunction name="getSorter" access="public" output="false" returntype="EventManager.util.AbstractSortable">
		<cfreturn variables.instance.Sorter/>
	</cffunction>

    <!---   Factory   --->
	<cffunction name="getFactory" access="public" output="false" returntype="EventManager.factory.Factory">
		<cfreturn variables.instance.Factory/>
	</cffunction>
	<cffunction name="setFactory" access="public" output="false" returntype="void">
		<cfargument name="Factory" type="EventManager.factory.Factory" required="true"/>
		<cfset variables.instance.Factory = arguments.Factory/>
	</cffunction>

	<!---	beanInjector  --->
	<cffunction name="getBeanInjector" access="public" returntype="any" output="false" hint="I return the BeanInjector.">
		<cfreturn variables.instance['beanInjector'] />
	</cffunction>		

 	<!---	beanInjector  --->
	<cffunction name="setBeanInjector" access="public" returntype="void" output="false" hint="I set the BeanInjector.">
		<cfargument name="beanInjector" type="any" required="true" hint="BeanInjector" />
		<cfset variables.instance['beanInjector'] = arguments.beanInjector />
	</cffunction>

   <!---   tracer   --->
	<cffunction name="gettracer" access="public" output="false" returntype="EventManager.stats.Tracer">
		<cfreturn variables.instance.tracer/>
	</cffunction>

	<!---   debug  / scope --->
	<cffunction name="getdebug" access="public" output="false" returntype="boolean">
		<cfreturn variables.instance.debug/>
	</cffunction>
	<cffunction name="getscope" access="public" output="false" returntype="string">
		<cfreturn variables.instance.scope/>
	</cffunction>
	<cffunction name="setdebug" access="public" output="false" returntype="void">
		<cfargument name="debug" type="boolean" required="true"/>
		<cfargument name="scope" type="string" required="false" default="request"/>
		<cfset variables.instance.debug = arguments.debug/>
		<cfset variables.instance.scope = arguments.scope/>
		<cfset setTracer(createObject('component','EventManager.stats.Tracer').init(arguments.scope)) />
	</cffunction>

	<!--- renderDebug --->
	<cffunction name="renderDebug" output="false" returntype="string" access="public">
		<cfscript>
			if(not structKeyExists(variables.instance,'tracer') or not getdebug()){
				throw('Debug cannot be rendered when is not active.','EventManger.debugOutputException');
			}
			return 	getTracer().render();        	        
        </cfscript>
	</cffunction>

	<!--- clearDebug --->
	<cffunction name="clearDebug" output="false" returntype="string" access="public">
		<cfscript>
		return 	getTracer().clear();        	        
        </cfscript>
	</cffunction>
	
	<!--- getConfig  --->
	<cffunction name="getConfig" returntype="any" output="false">
		<cfargument name="config" type="string" required="true" />
		<cfreturn variables.instance.config[config] />
	</cffunction> 

	<!--- setConfig  --->
	<cffunction name="setConfig" returntype="void" output="false">
		<cfargument name="config" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfset variables.instance.config[arguments.config] = arguments.value />
	</cffunction> 

	<!--- getHelper  --->
	<cffunction name="getHelper" returntype="any" output="false">
		<cfargument name="helper" type="any" required="true" />
		<cfreturn variables.instance.helpers[helper] />
	</cffunction> 

	<!--- setHelper  --->
	<cffunction name="setHelper" returntype="void" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfset variables.instance.helpers[arguments.name] = arguments.value />
	</cffunction> 

	<!----	beanFactory	--->
	<cffunction name="getBeanFactory" access="public" returntype="any" output="false" hint="Return the beanFactory instance">
		<cfreturn variables.instance.beanFactory />
	</cffunction>		
	<cffunction name="setBeanFactory" access="public" returntype="void" output="false" hint="Inject a beanFactory reference.">
		<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true" />
		<cfset variables.instance.beanFactory = arguments.beanFactory />
	</cffunction>

	<!------------------------------------------- PRIVATE ------------------------------------------->		

	<!---   Sorter   --->
	<cffunction name="setSorter" access="private" output="false" returntype="void">
		<cfargument name="Sorter" type="EventManager.util.AbstractSortable" required="true"/>
		<cfset variables.instance['sorter'] = arguments.Sorter/>
	</cffunction>

    <!---   tracer   --->
	<cffunction name="settracer" access="private" output="false" returntype="void">
		<cfargument name="tracer" type="EventManager.stats.Tracer" required="true"/>
		<cfset variables.instance.tracer = arguments.tracer/>
	</cffunction>

	<!---invokeObject--->
	<cffunction name="invokeObject" output="false" returntype="any">
		<cfargument name="listener" type="string" required="true" />
		<cfargument name="method" type="string" required="true" />		
		<cfset var result = "" />
		<cfinvoke component="#arguments.listener#" method="#arguments.method#" returnvariable="result"/>
		<cfreturn result />
	</cffunction>

	<!---throw--->
	<cffunction name="Throw" returntype="void" output="no" access="public" >   
		<cfargument name="Message" type="string" required="false" default="" />
		<cfargument name="type" type="string" required="false" default="any" />  
		<cfthrow message="#arguments.Message#" type="#arguments.type#"/> 
	</cffunction> 

</cfcomponent>