<cfcomponent output="false"
	hint="Look for listener into a specified directory.Add listeners and implicit events.">
	
	<cfset variables.instance = {} />
	
	<cffunction name="init" access="public" output="false" returntype="com.andreacfm.cfem.listener.MetaScanner">
		<cfargument name="eventManager" required="true" type="com.andreacfm.cfem.EventManager">
		<cfargument name="path" required="true" type="string" hint="relative path to the directory to be scanned">
		<cfargument name="recurse" required="false" type="Boolean" default="false">
		
		<cfset setEventManager(arguments.eventManager) />
		<cfset setPath(arguments.path) />
		<cfset setRecurse(arguments.recurse) />
				
		<cfreturn this/>
	</cffunction>
	
	<!--- 
	findListeners
	 --->
	<cffunction name="addListeners" returntype="void" output="false" access="public">
		
		<cfset var dir = getPath() />
		<cfset var recurse = getRecurse() />
		<cfset scanDirectory(directory = dir, recurse = recurse) />
		
	</cffunction>

	<!--- 
	scanDirectory
	 --->
	<cffunction name="scanDirectory" returntype="void" output="false" access="private">
		<cfargument name="directory" required="true" type="string" >
		<cfargument name="recurse" required="true" type="Boolean" >
		
		<cfset var q = "" />
		<cfset var obj = "" />
		<cfset var mapping = "" />
		
		<cfdirectory action="list" name="q" directory="#expandPath(arguments.directory)#" filter="*.cfc" />

		<cfloop query="q">
			<cfif q.type eq "file">
				<cfset class = reReplaceNocase(arguments.directory,'^/','') />
				<cfset class = reReplaceNocase(class,'/','.','All') & reReplaceNocase(q.name,'.cfc','','All') />
				<cfset processObject(class)/>
			<cfelseif q.type eq "dir" and arguments.recurse>
				<cfset scanDirectory(directory:"#d.directory#/#q.name#",recurse:true)/>
			</cfif>
		</cfloop>
			
	</cffunction>	

	<!--- 
	processObject
	 --->
	<cffunction name="processObject" returntype="void" output="false" access="private">
		<cfargument name="class" required="true" type="String">
		
		<cfset var em = getEventManager() />
		<cfset var obj = createObject('component',class) />
		<cfset var meta = getmetadata(obj) />
		<cfset var functions = meta.functions />
		<cfset var event = "" />
		<cfset var params = {} />
		
		<cfloop array="#functions#" index="f">
				
			<cfif structKeyExists(f,'event') and len(f.event)>
				<cftry>
					<cfset event = em.getEvent(f.event) />
					<cfcatch type="com.andreacfm.cfem.noSuchEventExeption">
						<cfset em .addEvent(f.event) />
					</cfcatch>
				</cftry>
				<cfset params = duplicate(f) />
				<cfset params.listener = class />
				<cfset em.addEventListener(argumentCollection=params) />
			</cfif>
			
		</cfloop>
				
	</cffunction>
		
	
	<!--- EventManager--->
	<cffunction name="setEventManager" access="public" returntype="void">
		<cfargument name="EventManager" type="com.andreacfm.cfem.EventManager" required="true"/>
		<cfset variables.instance.EventManager = EventManager />
	</cffunction> 
	<cffunction name="getEventManager" access="public" returntype="com.andreacfm.cfem.EventManager">
		<cfreturn variables.instance.EventManager/>
	</cffunction>
	
	<!--- Recurse--->
	<cffunction name="setRecurse" access="public" returntype="void">
		<cfargument name="Recurse" type="Boolean" required="true"/>
		<cfset variables.instance.Recurse = Recurse />
	</cffunction> 
	<cffunction name="getRecurse" access="public" returntype="Boolean">
		<cfreturn variables.instance.Recurse/>
	</cffunction>	
	
	<!--- path--->
	<cffunction name="setpath" access="public" returntype="void">
		<cfargument name="path" type="String" required="true"/>
		<cfscript>
		if(not directoryexists(expandPath(arguments.path))){
			getEventManager().throw(message = "Directory [#arguments.path#] does not exists", type="com.andreacfm.cfem.directoryDoesNotExists");
		}
		variables.instance.path = path;
		</cfscript>
	</cffunction> 
	<cffunction name="getpath" access="public" returntype="String">
		<cfreturn variables.instance.path/>
	</cffunction>
	

</cfcomponent>