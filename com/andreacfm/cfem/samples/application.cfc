<cfcomponent output="false">
	
	<cfset this.name = "EventManager samples">
	<cfset this.applicationTimeout = createTimeSpan(0,2,0,0)>
	<cfset this.clientManagement = false>
	<cfset this.clientStorage = "registry">
	<cfset this.loginStorage = "session">
	<cfset this.sessionManagement = true>
	<cfset this.sessionTimeout = createTimeSpan(0,0,20,0)>
	<cfset this.setClientCookies = true>
	<cfset this.setDomainCookies = false>
	<cfset this.scriptProtect = "none">
	<cfset this.secureJSON = false>
	<cfset this.secureJSONPrefix = "">
	<cfset this.welcomeFileList = "">
	
	<cfset this.mappings = structNew()>
	
	<cfset this.customtagpaths = "">
	
	<cffunction name="onApplicationStart" returnType="boolean" output="false">
		
		<cfset application.EventManager = CreateObject('component','com.andreacfm.cfem.EventManager').init(
				debug = true,
				scope = 'session'
				)/>
		
		<cfset application.com.andreacfm.cfem.loadXml('/EventManager/samples/config/helloWorldExample.xml')/>		
				
		<cfset application.com.andreacfm.cfem.loadXml('/EventManager/samples/config/dataCollectionExample.xml')/>
		
		<cfset application.com.andreacfm.cfem.loadXml('/EventManager/samples/config/interceptionExample.xml')/>
		
		<cfset LinksHelper = createObject('component','com.andreacfm.cfem.samples.helpers.LinksHelper') />		
		<cfset application.com.andreacfm.cfem.setHelper('LinksHp',LinksHelper) />
		<cfreturn true>
	</cffunction>

	<cffunction name="onApplicationEnd" returnType="void" output="false">
		<cfargument name="applicationScope" required="true">
	</cffunction>

	<cffunction name="onMissingTemplate" returnType="boolean" output="false">
		<cfargument name="targetpage" required="true" type="string">
		<cfreturn true>
	</cffunction>
	
	<cffunction name="onRequestStart" returnType="boolean" output="false">
		<cfargument name="thePage" type="string" required="true">
		
		<cfif structKeyExists(url,'init')>
			<cfif structKeyExists(session,'Event_Manager_Tracer_Scope')>
				<cfset session['Event_Manager_Tracer_Scope'] = arrayNew(1) />
			</cfif>
			<cfset onApplicationStart() />
		</cfif>
		
		<cfreturn true>
	</cffunction>

	<cffunction name="onRequestEnd" returnType="void" output="false">
		<cfargument name="thePage" type="string" required="true">
	</cffunction>

	<cffunction name="onError" returnType="void" output="false">
		<cfargument name="exception" required="true">
		<cfargument name="eventname" type="string" required="true">
		<cfdump var="#arguments#"><cfabort>
	</cffunction>

	<cffunction name="onSessionStart" returnType="void" output="false">
	</cffunction>

	<cffunction name="onSessionEnd" returnType="void" output="false">
		<cfargument name="sessionScope" type="struct" required="true">
		<cfargument name="appScope" type="struct" required="false">
	</cffunction>

</cfcomponent>