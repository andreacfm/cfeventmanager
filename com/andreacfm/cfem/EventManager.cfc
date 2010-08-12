<cfcomponent 
	output="false" 
	name="EventManager" 
	hint="Event Manager Class">

	<cfscript>
	variables.instance.events = structNew();
	variables.instance.config = structNew();
	variables.instance.helpers = structNew();
	variables.instance.Sorter = createObject('component','com.andreacfm.cfem.util.SortableListener').init();
	variables.instance.islogging = true;
	</cfscript>
	
	<!--- Constructor --->
	<cffunction name="init" output="false" returntype="com.andreacfm.cfem.EventManager" hint="Constructor" >
		<cfargument name="events" required="false" type="array" default="#arrayNew(1)#"/>
		<cfargument name="listeners" required="false" type="array" default="#arrayNew(1)#"/>
		<cfargument name="xmlPath" required="false" type="string" default="" hint="relative path"/>
		<cfargument name="xml" required="false" type="string" default="" hint="xml string"/>
		<cfargument name="xmlObject" required="false" type="xml" hint="xml parsed object"/>
		<cfargument name="autowire" required="false" type="boolean" default="false"/>
		<cfargument name="logging" required="false" type="boolean" default="true"/>
		<cfargument name="logger" required="false" type="any" default=""/>
		<cfargument name="dir" required="false" type="any"/>
		<cfargument name="recurseOnDir" required="false" type="Boolean" default="false"/>
		
		<cfscript>		
		//create factories
		var factory = createObject('component','com.andreacfm.cfem.factory.Factory').init();
		var EventFactory = createObject('component','com.andreacfm.cfem.factory.EventFactory').init(this,arguments.autowire);
		var DispatcherFactory = createObject('component','com.andreacfm.cfem.factory.DispatcherFactory').init(this);
		var ActionFactory = createObject('component','com.andreacfm.cfem.factory.ActionFactory').init(this);
		var InterceptionFactory = createObject('component','com.andreacfm.cfem.factory.InterceptionFactory').init(this);
		var ListenerFactory = createObject('component','com.andreacfm.cfem.factory.ListenerFactory').init(this,arguments.autowire);
		var ListenerParserFactory = createObject('component','com.andreacfm.cfem.factory.ListenerParserFactory').init(this);
		
		factory.addFactory('EventFactory',EventFactory);
		factory.addFactory('DispatcherFactory',DispatcherFactory);
		factory.addFactory('ActionFactory',ActionFactory);
		factory.addFactory('InterceptionFactory',InterceptionFactory);
		factory.addFactory('ListenerFactory',ListenerFactory);
		factory.addFactory('ListenerFactory',ListenerFactory);
		factory.addFactory('ListenerParserFactory',ListenerParserFactory);
		
		setFactory(factory);
		
		// trace the autowiring election
		setAutowire(arguments.autowire);		
		//Load System Configs
		loadConfig('/com/andreacfm/cfem/config/cfem.xml.cfm');
		//Ie EM in logging mode ? 
		setLoggingMode(arguments.logging);
		//create the logger
		structkeyExists(arguments,'logger') ? setLogger(arguments.logger) : setLogger(); 
		//Load events
		setEvents(arguments.events);
		
		//Load from xml
		if(len(arguments.xmlPath)){
			loadFromXmlPath(arguments.xmlPath);
		}
		if(len(arguments.xml)){
			loadFromXmlRaw(arguments.xml);
		}
		if(structKeyExists(arguments,'xmlObject')){
			loadFromXmlObject(arguments.xmlObject);
		}
		
		//load listeners (listeners are always at final)
		setListeners(arguments.listeners);
		
		return this;
		</cfscript>			
	</cffunction>

	<!------------------------------------------- PUBLIC ------------------------------------------->

	<!---
	addEvent
	--->
	<cffunction name="addEvent" output="false" returntype="void" hint="Register a new Event">
		<cfargument name="name" required="true" type="string" />
		<cfargument name="type" required="false" type="string" default="#getconfig('defaultBaseEventClass')#" />		
		<cfscript>
		if(not eventExists(arguments.name)){
			variables.instance.events['#name#'] = structNew();
			variables.instance.events['#name#'].type = arguments.type;
			variables.instance.events['#name#'].listeners = createObject('java','java.util.ArrayList').init();
			variables.instance.events['#name#'].interceptions = createObject('java','java.util.ArrayList').init();
			variables.instance.events['#name#'].counter = 0 ;
		}else{
			throw('Cannot register a duplicate Event. The event #arguments.name# already exists.','com.andreacfm.cfem.duplicateEventsExeption');
		}
		if(isLogging()){
			getLogger().info('Registering event #arguments.name#');
		}
		</cfscript>
	</cffunction>

	<!---
	addEventListener 
	--->
	<cffunction name="addEventListener" output="false" returntype="void" hint="Register a listener to respond to a specific event invocation.">
		<cfargument name="event" required="true" type="string" />
		<cfargument name="listener" required="true" type="any" />
		<cfargument name="id" required="false" type="string" default=""/>
		<cfargument name="method" required="false" type="string" default=""/>
		<cfargument name="priority" required="false" type="numeric" default="5"/>
		<cfargument name="initMethod" required="false" type="string" default="init"/>

		<cfset var sorter = getSorter() />
		<cfset var key = "" />
				
		<cfloop collection="#variables.instance.events#" item="key">
			
			<cfif findNocase(arguments.event,key) gt 0  >
				
				<cfset listener = getFactory().createListener(argumentCollection=arguments) />
				
				<cfset variables.instance.events[key]['listeners'].add(listener) />
				
				<cfset variables.instance.events[key]['listeners'] = sorter.sortArray(variables.instance.events[key]['listeners'],'LT') />	
				
				<cfif isLogging()>
					<cfset getLogger().info('Registered Listener id :#listener.getid()# to Event:#key# {Priority:#arguments.priority#}') />				
				</cfif>
			</cfif>	
		</cfloop>

	</cffunction>
	
	<!---
	removeEventListener
	--->
    <cffunction name="removeEventListener" output="false" access="public" returntype="void">
		<cfargument name="event" required="true" type="string" />
   		<cfargument name="id" required="false" type="string"/>
 		
		<cfscript>
		var listeners = getListeners(arguments.event);
		var iterator = listeners.iterator();
		var item = "";
		while(iterator.hasNext()){
			item = iterator.next();
			if(item.getId() eq arguments.id){
				iterator.remove();
			}
		}
		</cfscript>
    
    </cffunction>

	<!---   
	events   
	--->
	<cffunction name="getevents" access="public" output="false" returntype="struct">
		<cfreturn variables.instance.events/>
	</cffunction>	
	<cffunction name="setevents" access="public" output="false" returntype="void">
		<cfargument name="events" type="array" required="true"/>		
		<cfset var i = "" />
		<cfscript>
			for(i = 1; i <= arraylen(arguments.events); i++){
				if(structKeyExists(arguments.events[i],'type')){
					this.addEvent(arguments.events[i].name,arguments.events[i].type);
				}else{
					this.addEvent(arguments.events[i].name);
				}
			}			
		</cfscript>
	</cffunction>

	<!---   
	listeners   
	--->
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

	<!---
	createEvent
	--->
	<cffunction name="createEvent" output="false" returntype="com.andreacfm.cfem.events.AbstractEvent">
		<cfargument name="name" required="true" type="string"/>
		<cfargument name="data" required="false" type="any" default=""/>		
		<cfargument name="target" required="false" type="any" default="" />
		<cfargument name="mode" required="false" type="string" default="synch" />
		<cfscript>
		/* convert data to struct if is not */
		if(not isStruct(arguments.data)){
			local.dataStr = {};
			local.datStr.data = arguments.data;
			arguments.data = local.dataStr;
		}
		return getFactory().createEvent(argumentCollection=arguments);
		</cfscript>
	</cffunction>

	<!--- 
	addInterception
	 --->
	<cffunction name="addInterception" returntype="void" output="false" access="public">
		<cfargument name="name" required="true" type="string" />
		<cfargument name="interception" required="false" type="com.andreacfm.cfem.events.AbstractEventInterception"/>
		
		<cfscript>
		var event = getEvent(arguments.name);	
		event.interceptions.add(arguments.interception);
		</cfscript>
				
	</cffunction>

	<!--- 
	createInterception
	 --->
	<cffunction name="createInterception" returntype="com.andreacfm.cfem.events.AbstractEventInterception" output="false" access="public">
		<cfargument name="point" required="true" type="string"/>
		<cfargument name="class" required="false" type="string" default="#getConfig('defaultInterceptionClass')#"/>
		<cfargument name="condition" required="false" type="string" default="true"/>
		<cfargument name="actions" required="false" type="array"/>
		
		<cfscript>
		var int = getFactory().createInterception(argumentCollection=arguments);
		return int;
		</cfscript>
	</cffunction>
	
	<!--- 
	createAction
	 --->
	<cffunction name="createAction" returntype="com.andreacfm.cfem.events.actions.AbstractAction" output="false" access="public">
		<cfargument name="name" required="true" type="string"/>		
		<cfscript>
		var action = getFactory().createAction(argumentCollection=arguments);
		return action;
		</cfscript>
	</cffunction>
	
	<!---
	getEvent
	--->
	<cffunction name="getEvent" output="false" returntype="struct">
		<cfargument name="eventname" type="string" required="true"/>
		<cfscript>
		if(not eventExists(arguments.eventname)){
			throw('The event #arguments.eventname# do not exists!','com.andreacfm.cfem.noSuchEventExeption');			
		}
		return variables.instance.events[arguments.eventname];
		</cfscript>
	</cffunction>
	
	<!---
	dispatchEvent
	--->
	<cffunction name="dispatchEvent" output="false" returntype="void">
		<cfargument name="name" required="false" type="string" default="Event" />
		<cfargument name="data" required="false" type="any" default=""/>		
		<cfargument name="target" required="false" type="any" default="" />
		<cfargument name="mode" required="false" type="string" default="synch" />
		<cfargument name="event" required="false" type="com.andreacfm.cfem.events.AbstractEvent"/>
		
		<cfscript>	
		var local = structNew();
		
		/* convert data to struct if is not */
		if(not isStruct(arguments.data)){
			local.dataStr = {};
			local.datStr.data = arguments.data;
			arguments.data = local.dataStr;
		}
		
		/*if is passed an object as event argument*/
		if(structKeyexists(arguments,'event') and isObject(arguments.event)){
			local.eventObj = arguments.event;
			arguments.name = local.eventObj.getName();
		}else{
			/* be sure event exists */	
			getEvent(arguments.name);			
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
		
		if(isLogging()){
			if(not structKeyExists(local,'eventObj')){
				local.eventObj = getFactory().createEvent(name=arguments.name,data=arguments.data,target=arguments.target,mode=arguments.mode);
			}
			getLogger().info('Dispatched Event #arguments.name#');
		}				
		</cfscript>	

	</cffunction>

	<!---
	listenerExists
	--->
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

	<!---
	eventExists
	--->
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
	
	<!---
	loadConfig
	--->
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
						variables.instance.config[local.configs[i].xmlAttributes.name] = {};
						variables.instance.config[local.configs[i].xmlAttributes.name].value = trim(local.configs[i].xmlAttributes.value);
						variables.instance.config[local.configs[i].xmlAttributes.name].props = {};
						var props = xmlSearch(local.xml,'/event-manager/configs/config[#i#]/property');
						for(p=1; p <= arraylen(props); p++){
							variables.instance.config[local.configs[i].xmlAttributes.name].props[props[p].xmlAttributes.name] = props[p].xmlAttributes.value;
						}	
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
					throw('Xml file #local.Path# is not valid.','com.andreacfm.cfem.xmlInvalidException');
			} 
		}
		</cfscript>
	</cffunction>
	
	<!--- 
	loadFromXmlPath
	 --->
	<cffunction name="loadFromXmlPath" returntype="void" output="false" access="public">
		<cfargument name="path" required="true" type="string" />
		<cfscript>
		var local = structNew();	
		local.path = expandPath(arguments.path);
		
		if(fileExists(local.path)){
			local.output = fileRead(local.path);
			if(isXml(local.output)){
				loadXmlData(xmlParse(local.output));
			}else{
				throw('File [#path#] does not contain a valid xml format.','com.andreacfm.cfem.illegalXmlFormat');
			}
		}else{
			throw('File [#path#] cannot be found.','com.andreacfm.cfem.fileNotFound');	
		}
		</cfscript>
				
	</cffunction>

	<!--- 
	loadFromXmlRaw
	 --->
	<cffunction name="loadFromXmlRaw" returntype="void" output="false" access="public">
		<cfargument name="xml" required="true" type="string" />
		<cfscript>
		
		if(isXml(arguments.xml)){
			loadXmlData(xmlParse(arguments.xml));
		}else{
			throw('Variable [xml] does not contain a valid xml format.','com.andreacfm.cfem.illegalXmlFormat');
		}

		</cfscript>
				
	</cffunction>

	<!--- 
	loadFromXmlObject
	 --->
	<cffunction name="loadFromXmlObject" returntype="void" output="false" access="public">
		<cfargument name="xml" required="true" type="xml" />
		<cfscript>
		loadXmlData(arguments.xml);
		</cfscript>
	</cffunction>
		

	<!--- 
	parseDirectory
	 --->
	<cffunction name="parseDirectory" returntype="void" output="false" access="public">
		<cfargument name="dir" type="any" required="true" hint="relative path ( or an array of ) to the directory that contains the listeners to scan">
		<cfargument name="recurse" type="Boolean" required="false" default="false">
		
		<cfscript>
		var parser = "";
			
		if(isSimpleValue(arguments.dir)){
			parser = getFactory().createListenerParser(argumentCollection=arguments);
			parser.run(); 					
		}else if(isArray(arguments.dir)){
			for(var i=1; i <= arraylen(arguments.dir); i++){
				parser = getFactory().createListenerParser(dir = arguments.dir[i], recurse = arguments.recurse);
				parser.run(); 								
			}
		}else{
			throw(type="com.andreacfm.cfem.IllegalDirType",message="The arguments [dir] passed to function parseDirectoty must be a string or an array of strings")
		}	
		</cfscript>
		
	</cffunction>
	

    <!---   
	Sorter  
	--->
	<cffunction name="getSorter" access="public" output="false" returntype="com.andreacfm.cfem.util.AbstractSortable">
		<cfreturn variables.instance.Sorter/>
	</cffunction>

    <!---   
	Factory   
	--->
	<cffunction name="getFactory" access="public" output="false" returntype="com.andreacfm.cfem.factory.Factory">
		<cfreturn variables.instance.Factory/>
	</cffunction>
	<cffunction name="setFactory" access="public" output="false" returntype="void">
		<cfargument name="Factory" type="com.andreacfm.cfem.factory.Factory" required="true"/>
		<cfset variables.instance.Factory = arguments.Factory/>
	</cffunction>

	<!--- 
	autowire
	--->
	<cffunction name="setAutowire" access="public" returntype="void">
		<cfargument name="autowire" type="Boolean" required="true"/>
		<cfset variables.instance.autowire = autowire />
	</cffunction> 
	<cffunction name="getAutowire" access="public" returntype="Boolean">
		<cfreturn variables.instance.autowire/>
	</cffunction>

	<!--- 
	loggingMode
	--->
	<cffunction name="setloggingMode" access="public" returntype="void">
		<cfargument name="loggingMode" type="Boolean" required="true"/>
		<cfset variables.instance.islogging = loggingMode />
	</cffunction> 
	
	<!--- 
	isLogging
	 --->
	<cffunction name="islogging" access="public" returntype="Boolean">
		<cfreturn variables.instance.islogging/>
	</cffunction>
	

	<!--- 
	logger
	--->
	<cffunction name="setlogger" access="public" returntype="void">
		<cfargument name="logger" type="any" required="true"/>
		<cfif not isSimpleValue(arguments.logger)>
			<cfset variables.instance.logger = logger />
		</cfif>
	</cffunction> 
	<cffunction name="getlogger" access="public" returntype="any">
		<cfif not structKeyExists(variables.instance,'logger')>
			<cfset var loggerclass = getConfig('defaultLoggerClass') />
			<cfset variables.instance.logger = createObject('component',loggerclass).init(argumentCollection = getConfigProps('defaultLoggerClass')) />
		</cfif>
		<cfreturn variables.instance.logger/>
	</cffunction>
	
	<!--- 
	getConfig  
	--->
	<cffunction name="getConfig" returntype="any" output="false">
		<cfargument name="config" type="string" required="true" />
		<cfreturn variables.instance.config[config].value />
	</cffunction> 
	<cffunction name="getConfigProps" returntype="any" output="false">
		<cfargument name="config" type="string" required="true" />
		<cfreturn variables.instance.config[config].props />
	</cffunction> 	
	<cffunction name="setConfig" returntype="void" output="false">
		<cfargument name="config" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfset variables.instance.config[arguments.config] = arguments.value />
	</cffunction> 

	<!--- 
	getActions
	 --->
	<cffunction name="getActions" returntype="struct" output="false" access="public">
		<cfreturn variables.instance.config['actions'] />	
	</cffunction>
	
	<!--- 
	getHelper  
	--->
	<cffunction name="getHelper" returntype="any" output="false">
		<cfargument name="helper" type="any" required="true" />
		<cfreturn variables.instance.helpers[helper] />
	</cffunction> 
	<cffunction name="setHelper" returntype="void" output="false">
		<cfargument name="name" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		<cfset variables.instance.helpers[arguments.name] = arguments.value />
	</cffunction> 

	<!---	
	beanInjector  
	--->
	<cffunction name="getBeanInjector" access="public" returntype="any" output="false" hint="I return the BeanInjector.">
		<cfreturn variables.instance['beanInjector'] />
	</cffunction>		
	<cffunction name="setBeanInjector" access="public" returntype="void" output="false" hint="I set the BeanInjector.">
		<cfargument name="beanInjector" type="any" required="true" hint="BeanInjector" />
		<cfset variables.instance['beanInjector'] = arguments.beanInjector />
	</cffunction>

	<!----	
	beanFactory	
	--->
	<cffunction name="getBeanFactory" access="public" returntype="any" output="false" hint="Return the beanFactory instance">
		<cfreturn variables.instance.beanFactory />
	</cffunction>		
	<cffunction name="setBeanFactory" access="public" returntype="void" output="false" hint="Inject a beanFactory reference.">
		<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true" />
		<cfset variables.instance.beanFactory = arguments.beanFactory />
	</cffunction>

	<!------------------------------------------- PRIVATE ------------------------------------------->		

	<!---
	loadXmlData
	--->
	<cffunction name="loadXmlData" output="false" returntype="void" access="private">
		<cfargument name="data" required="true" type="xml" />
		<cfscript>
		var i = "";
		var j = "";
		var t = "";
		var local = structNew();
		local.xml = arguments.data;	

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
							
							// class
							if(structkeyExists(local.interceptions[j].xmlAttributes,'class')){
								local.collection.class = local.interceptions[j].xmlAttributes.class;
							}else{
								local.collection.class = getConfig('defaultInterceptionClass');
							}
							
							// point
							local.collection.point = local.interceptions[j].xmlAttributes.point;

							local.interChd = local.interceptions[j].xmlChildren;
							
							//actions
							local.collection.actions = [];							
							for(t=1; t <= arraylen(local.interChd); t++){										
								if(local.interChd[t].xmlName eq 'action'){
									local.collection.actions.add(getFactory().createAction(argumentCollection=local.interChd[t].xmlAttributes));
								}
							}

							for(t=1; t <= arraylen(local.interChd); t++){
								if(local.interChd[t].xmlName eq 'condition'){
									local.collection.condition = local.interChd[t].xmlText;
								}
							}	

							local.interception = getFactory().createInterception(argumentCollection=local.collection);
							
							// post to event repo
							getEvent(local.events[i].xmlAttributes.name).interceptions.add(local.interception);

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
				addEventListener(argumentCollection=local.args);
			}
		}
					
		</cfscript>
	</cffunction>

	<!---   
	Sorter   
	--->
	<cffunction name="setSorter" access="private" output="false" returntype="void">
		<cfargument name="Sorter" type="com.andreacfm.cfem.util.AbstractSortable" required="true"/>
		<cfset variables.instance['sorter'] = arguments.Sorter/>
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

	<!---
	throw
	--->
	<cffunction name="Throw" returntype="void" output="no" access="public" >   
		<cfargument name="Message" type="string" required="false" default="" />
		<cfargument name="type" type="string" required="false" default="any" />  
		<cfthrow message="#arguments.Message#" type="#arguments.type#"/> 
	</cffunction> 

</cfcomponent>
