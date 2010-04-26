<cfcomponent output="false">
	
	<cfset variables.instance = {} />
	
	<cffunction name="init" access="public" output="false" returntype="com.andreacfm.cfem.util.SimpleAppender">		
		<cfargument name="out" type="String" default="file" />		
		<cfargument name="basepath" type="String" default="#expandPath('/_cfemlogs')#" />
		<cfset setOut(arguments.out) />	
		<cfset setBasepath(arguments.basepath) />
		<cfreturn this/>
	</cffunction>

	<!--- 
	debug
	 --->
	<cffunction name="debug" returntype="void" output="false" access="public">
		
	</cffunction>
	
	<!--- 
	info
	 --->
	<cffunction name="info" returntype="void" output="false" access="public">
		
	</cffunction>
	
	<!--- 
	warn
	 --->
	<cffunction name="warn" returntype="void" output="false" access="public">
		
	</cffunction>

	<!--- 
	error
	 --->
	<cffunction name="error" returntype="void" output="false" access="public">
		
	</cffunction>

	<!--- 
	fatal
	 --->
	<cffunction name="fatal" returntype="void" output="false" access="public">
		
	</cffunction>

	
	<!---FilePath--->
	<cffunction name="getFilePath" output="false" returntype="string">
		<cfscript>
			var path = expandPath(variables.instance.FilePath);
			return path;
		</cfscript>
	</cffunction>
	
	<cffunction name="setFilePath" output="false" returntype="void">
		<cfargument name="path" type="String">
		<cfscript>
			if(not fileExists(expandPath(arguments.path)){
				filewrite(obPath,'');
			}
			variables.instance.FilePath = arguments.path;
			return path;
		</cfscript>
	</cffunction>

	<!--- out--->
	<cffunction name="setout" access="public" returntype="void">
		<cfargument name="out" type="String" required="true"/>
		<cfset variables.instance.out = out />
		<cfif variables.instance.out eq 'console'>
			<cfset variables.console = createObject('java','java.lang.System').out />
		</cfif>
	</cffunction> 
	<cffunction name="getout" access="public" returntype="String">
		<cfreturn variables.instance.out/>
	</cffunction>
	
	
	<!--- PRIVATE --->

	<!--- 
	logMessage
	 --->
	<cffunction name="logMessage" returntype="void" output="false" access="private">
		
	</cffunction>	

	<!--- 
	doZipFile
	 --->
	<cffunction name="doZipFile" returntype="void" output="false" access="public">				
		<cfset var exists = true>	
		<cfset var count = 0>
		<cfset var abPath = getFilePath() />
		<cfset var fileName = variables.instance.fileObj.getName() />
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
		<cfreturn variables.instance.fileObj.length() />
	</cffunction>
	

	<!--- processLog --->
	<cffunction name="processLog" output="false" access="private">
		<cfargument name="str" required="true" type="struct"/>
			
			<cfscript>
				var fileObj = "" ;
				var schema = getSchema();

				// open file buffer	
				fileObj = fileOpen(getFilePath(),'append',getCharset());

				writeLog(fileObj,arguments.str);
				
				fileClose(fileObj);
			</cfscript>
	
	</cffunction>

	<!--- handleLog --->
	<cffunction name="handleLog" output="false" access="private">
		<cfargument name="str" required="true" type="struct"/>
			
		<cfthread name="#createUUID()#" action="run" values="#arguments.str#">
			<cfscript>
				var fileObj = "" ;
				var schema = getSchema();

				// open file buffer	
				fileObj = fileOpen(getFilePath(),'append',getCharset());
		
				writeLog(fileObj,attributes.values);
				
				fileClose(fileObj);

			</cfscript>
						
		</cfthread>
			
	</cffunction>
	
	<!--- writeLog --->
	<cffunction name="writeLog" output="false" access="private">
		<cfargument name="fileObj" required="true"/>
		<cfargument name="values" required="true" type="struct"/>
		
		<cfscript>
			var listValues = "";
			var schema = getSchema();
			var value ='"' & '"';
			var schemaitem = "";
			
			for(i = 1 ; i LTE listlen(schema); i++ ){
				schemaitem = rereplacenocase(listGetAt(schema,i),'"','','All');
				// looks for match in passed struct				
				if(structKeyExists(arguments.values,schemaitem) and isSimpleValue(arguments.values[schemaitem])){
					// add macth to the value list
					value = '"' & arguments.values[schemaitem] & '"';
				}
				if(schemaitem eq 'ts'){
					value = '"' & now() & '"';
					if(isTestMode()){
						value = '"TEST --' & now() & '-- TEST"';
					}
				}
					
				listValues = listAppend(listValues,value,',');
					
				value ='"' & '"';
			
			}
			
			// write file
			fileWriteLine(arguments.fileObj,listValues);		
		</cfscript>
		
	</cffunction>	

</cfcomponent>