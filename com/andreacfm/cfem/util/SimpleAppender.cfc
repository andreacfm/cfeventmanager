<cfcomponent output="false">
	
	<cfset variables.instance = {} />
	<cfset variables.severityScale = {debug=1,info=2,warn=3,error=4,fatal=5} />
	
	<cffunction name="init" access="public" output="false" returntype="com.andreacfm.cfem.util.SimpleAppender">		
		<cfargument name="out" type="String" default="file" />		
		<cfargument name="filepath" type="String" default="/cfem.log" />
		<cfargument name="minLevel" type="String" default="info" />
		<cfargument name="maxSize" type="Numeric" default="10485760" />

		<cfset setmaxSize(arguments.maxsize) />
		<cfset setMinLevel(arguments.minLevel) />
		<cfset setOut(arguments.out) />	
		<cfset setFilePath(arguments.filepath) />

		<cfreturn this/>

	</cffunction>

	<!--- 
	debug
	 --->
	<cffunction name="debug" returntype="void" output="false" access="public">
		<cfargument name="msg" required="true" type="String">
		<cfset logMessage('debug',arguments.msg) />
	</cffunction>
	
	<!--- 
	info
	 --->
	<cffunction name="info" returntype="void" output="false" access="public">
		<cfargument name="msg" required="true" type="String">
		<cfset logMessage('info',arguments.msg) />
	</cffunction>
	
	<!--- 
	warn
	 --->
	<cffunction name="warn" returntype="void" output="false" access="public">
		<cfargument name="msg" required="true" type="String">
		<cfset logMessage('warn',arguments.msg) />
	</cffunction>

	<!--- 
	error
	 --->
	<cffunction name="error" returntype="void" output="false" access="public">
		<cfargument name="msg" required="true" type="String">
		<cfset logMessage('error',arguments.msg) />		
	</cffunction>

	<!--- 
	fatal
	 --->
	<cffunction name="fatal" returntype="void" output="false" access="public">
		<cfargument name="msg" required="true" type="String">
		<cfset logMessage('fatal',arguments.msg) />		
	</cffunction>

	
	<!---FilePath--->
	<cffunction name="getFilePath" output="false" returntype="string">
		<cfscript>
			return variables.instance.FilePath;
		</cfscript>
	</cffunction>
	<cffunction name="setFilePath" output="false" returntype="void">
		<cfargument name="path" type="String">
		<cfscript> 
			var path = expandPath(arguments.path);
			if(not fileExists(path)){
				fileWrite(path,'');
			}
			variables.instance.filePath = path;
			variables.instance.file = createObject('java','java.io.File').init(variables.instance.filePath);
		</cfscript>
	</cffunction>

	<!--- 
	getFile
	 --->
	<cffunction name="getFile" returntype="any" output="false" access="public">
		<cfreturn variables.instance.file />
	</cffunction>	

	<!--- out--->
	<cffunction name="setout" access="public" returntype="void">
	<cfargument name="out" type="String" required="true"/>
		<cfset variables.instance.out = out />
		<cfif variables.instance.out eq 'console'>
			<cfset variables.instance.console = createObject('java','java.lang.System').out />
		</cfif>
	</cffunction> 
	<cffunction name="getout" access="public" returntype="String">
		<cfreturn variables.instance.out/>
	</cffunction>

	<!--- minLevel--->
	<cffunction name="setminLevel" access="public" returntype="void">
		<cfargument name="minLevel" type="String" required="true"/>
	
		<cfif not structKeyExists(variables.severityScale,arguments.minLevel)>
			<cfthrow type="com.andreacfm.logging.MinLevelDoNotExists" message="The min level logging [#arguments.minLevel#] is not valid.">
			<cfset variables.instance.minLevel = 2>
		<cfelse>
			<cfset variables.instance.minLevel = variables.severityScale[arguments.minLevel] />	
		</cfif>

	</cffunction>
	<cffunction name="getminLevel" access="public" returntype="String">
		<cfreturn variables.instance.minLevel/>
	</cffunction>	
	<cffunction name="getTranslatedMinLevel" access="public" returntype="String">
		<cfset var key = "" />
		<cfset var min = getMinLevel() />	
		<cfloop collection="#variables.severityScale#" item="key">
			<cfif variables.severityScale[key] eq min>
				<cfreturn key />
			</cfif>
		</cfloop>
		<cfreturn "" />
	</cffunction>	

	<!--- maxSize--->
	<cffunction name="setmaxSize" access="public" returntype="void">
		<cfargument name="maxSize" type="Numeric" required="true"/>
		<cfset variables.instance.maxSize = maxSize />
	</cffunction> 
	<cffunction name="getmaxSize" access="public" returntype="Numeric">
		<cfreturn variables.instance.maxSize/>
	</cffunction>	
	
	<!----------------------------------------- PRIVATE ---------------------------------------------------------->
	<!--- 
	logMessage
	 --->
	<cffunction name="logMessage" returntype="void" output="false" access="private">
		<cfargument name="severity" required="true" type="string">
		<cfargument name="msg" required="true" type="String">
		
		<cfscript>
		var timestamp = now();	
		var entry = '"#arguments.severity#","#dateformat(timestamp,"MM/DD/YYYY")#","#timeformat(timestamp,"HH:MM:SS")#","#msg#"';
		var out = getOut();
		
		// log only over the fixed minimum
		if(variables.severityScale[arguments.severity] gte getminLevel()){
			if(out eq 'file'){
				writeLogFile(entry);
			}else if(out eq 'console'){
				variables.instance.console.println(entry);
			}		
		}
		</cfscript>		

	</cffunction>	

	<!--- writeLog --->
	<cffunction name="writeLogFile" output="false" access="private">
		<cfargument name="msg" required="true" type="string"/>

		<cfif getSize() gt getmaxSize()>
			<cfset doZipFile() />
			<cfset fileDelete(getFilePath()) />	
			<cfset fileWrite(getFilePath(),'') />		
		</cfif>
			
		<cfthread name="#createUUID()#" action="run" msg="#arguments.msg#">
			<cfscript>
			var fileObj = "" ;
			// open file buffer	
			fileObj = fileOpen(getFilePath(),'append','utf-8');
			fileWriteLine(fileObj,attributes.msg);
			fileClose(fileObj);
			</cfscript>					
		</cfthread>
			
	</cffunction>

	<!--- 
	doZipFile
	 --->
	<cffunction name="doZipFile" returntype="void" output="false" access="private">				
		<cfset var exists = true>	
		<cfset var count = 0>
		<cfset var abPath = getFilePath() />
		<cfset var fileName = 'cfem' />
		<cfset var extension = 'zip' />	
		<cfset var zipName = replace(fileName,'.log','') />	
		<cfset var tempName = zipName />		
		<cfset var path = rereplace(abpath,filename,'') />

		<cfloop condition="exists eq true">			
			<cfif fileExists(path &  zipName & "." & extension)>
				<cfset count = count+1>
				<cfset zipName = tempName & "_" & count>				
			<cfelse>
				<cfset exists = false>	
			</cfif>
		</cfloop>
			
		<cfzip action="zip" source="#abPath#" file="#path##zipname#.#extension#" prefix="" />

	</cffunction>
	
	<!--- getSize --->
	<cffunction name="getSize" output="false" returntype="date">	
		<cfreturn variables.instance.file.length() />
	</cffunction>


</cfcomponent>