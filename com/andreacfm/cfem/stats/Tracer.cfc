<cfcomponent output="false">

	<cfproperty name="trace" type="boolean"/>
	<cfproperty name="scope" type="string"/>
	<cfproperty name="log" type="array"/>

	<cfset variables.instance.log = createObject('java','java.util.ArrayList').init() />
	
	<!---init--->
	<cffunction name="init" output="false" returntype="com.andreacfm.cfem.stats.Tracer">
		<cfargument name="scope" type="string" required="false" default="request"/>
		<cfset setScope(arguments.scope) />
		<cfreturn this/>		
	</cffunction>
	
	<!------------------------------------------- PUBLIC------------------------------------------->    
	<!---   trace   --->	
	<cffunction name="trace" returntype="void" output="false" access="public">
		<cfargument name="action" required="false" type="string" default="" />
		<cfargument name="description" required="false" type="string" default="" />
		<cfargument name="event" required="false" type="com.andreacfm.cfem.events.Event"/>
		<cfargument name="phase" required="false" type="string" default="config"/>

		<cfset var scope = getScope() />
		<cfset var log  = getLog() />
		
		<cfset var item = {} />
		<cfset item['ts'] = now() />		
		<cfset item['action'] = arguments.action />
		<cfset item['description'] = arguments.description />
		<cfset item['phase'] = arguments.phase />
		<cfif structKeyExists(arguments,'event')>		
			<cfset item['eventType'] =  arguments.event.getType()/>		
			<cfset item['eventData'] = arguments.event.getData().toString() />
			<cfif isObject(arguments.event.getTarget())>
				<cfset item['target'] = getMetadata(arguments.event.getTarget()).name />
			<cfelse>
				<cfset item['target'] = arguments.event.getTarget() />
			</cfif>		
		</cfif>
		<cfif scope eq 'request'>
			<cfif not structKeyExists(request,'Event_Manager_Tracer_Scope')>
				<cfset request['Event_Manager_Tracer_Scope'] = arrayNew(1) />
			</cfif>
			<cfset request['Event_Manager_Tracer_Scope'].add(item)/>	
		<cfelseif scope eq 'session'>
			<cfif not structKeyExists(session,'Event_Manager_Tracer_Scope')>
				<cfset session['Event_Manager_Tracer_Scope'] = arrayNew(1) />
			</cfif>
			<cfset session['Event_Manager_Tracer_Scope'].add(item)/>	
		<cfelseif scope eq 'instance'>
			<cfset log.add(item) />	
		</cfif>
	</cffunction>
	
	<!--- render --->
	<cffunction name="render" returntype="string" output="false">
		<cfset var data = arrayNew(1) />
		<cfif getScope() eq 'request' and structKeyExists(request,'Event_Manager_Tracer_Scope')>
			<cfset data = request['Event_Manager_Tracer_Scope']/>
		<cfelseif getScope() eq 'session' and structKeyExists(session,'Event_Manager_Tracer_Scope')>
			<cfset data = session['Event_Manager_Tracer_Scope']/>	
		<cfelse>
			<cfset data = getLog() />	
		</cfif>
		<cfsavecontent variable="temp">
			<cfoutput>
				<style type="text/css">
				.tablelisting{
					background-color: ##CDCDCD;
					margin:10px 0pt 15px;
					border-spacing: 1px;
				}
				.tablelisting tr{
					background-color: ##F7F7F7;
				}
				.tablelisting tr.even{
					background-color: ##ffffff;
				}
				.tablelisting tr:hover { background: ##d7eafe}
				.tablelisting th {
					text-align: left;
					background-color: ##E0EFEF;
					padding: 4px;
				}
				.tablelisting th.center{
					text-align:center;
				}
				.tablelisting th a {
					color: ##000;
					background-color: inherit;
					text-decoration: none;
					border-bottom: none;
				}
				.tablelisting th a:hover {
					color: ##CC0001; 
					background-color: inherit;	
				}
				.tablelisting td{
					padding: 5px;
				}
				.tablelisting td.center{
					text-align: center;
				}
				.tablelisting a {
					text-decoration: none;
					border-bottom: none;
				}
				.tablelisting a:hover {
					color: ##CC0001; 
					background-color: inherit;	
				}
				.tablesorter td.center{
					text-align: center;
				}
				</style>
				<table class="tablelisting">
					<thead>
						<tr><th>Time</th><th>Action</th><th width="40%">Details</th><th>Event Type</th><th>Data</th><th>Target</th></tr>
					</thead>
					<tbody>
					<cfloop from="1" to="#arraylen(data)#" index="i">
						<tr class="#IIF(i MOD 2, DE(''), DE('odd'))# #data[i].phase#">
							<td>#data[i].ts#</td>
							<td>#data[i].action#</td>
							<td>#data[i].description#</td>
							<cfif structKeyExists(data[i],'eventType')>
								<td>#data[i].eventType#</td>
								<td>#data[i].eventData#</td>
								<td>#data[i].target#</td>
							<cfelse>
								<td> </td><td> </td><td> </td>
							</cfif>					
						</tr>
					</cfloop>
					</tbody>
				</table>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn temp/>
				
	</cffunction>
	
	<!---clear--->
	<cffunction name="clear" output="false" access="public" returntype="void">
		<cfset var scope = getScope() />
		<cfif scope eq 'request'>
			<cfif structKeyExists(request,'Event_Manager_Tracer_Scope')>
				<cfset request['Event_Manager_Tracer_Scope'] = arrayNew(1) />
			</cfif>
		<cfelseif scope eq 'session'>
			<cfif structKeyExists(session,'Event_Manager_Tracer_Scope')>
				<cfset session['Event_Manager_Tracer_Scope'] = arrayNew(1) />
			</cfif>
		<cfelseif scope eq 'instance'>
			<cfset variables.instance.log.clear() />	
		</cfif>	
	</cffunction>	
	
    <!---   scope   --->
	<cffunction name="getscope" access="public" output="false" returntype="string">
		<cfreturn variables.instance.scope/>
	</cffunction>
	<cffunction name="setscope" access="public" output="false" returntype="void">
		<cfargument name="scope" type="string" required="true"/>
		<cfset variables.instance.scope = arguments.scope/>
	</cffunction>

    <!---   log   --->
	<cffunction name="getlog" access="public" output="false" returntype="array">
		<cfreturn variables.instance.log/>
	</cffunction>
	<cffunction name="setlog" access="public" output="false" returntype="void">
		<cfargument name="log" type="array" required="true"/>
		<cfset variables.instance.log = arguments.log/>
	</cffunction>

	<!------------------------------------------- PRIVATE------------------------------------------->


</cfcomponent>