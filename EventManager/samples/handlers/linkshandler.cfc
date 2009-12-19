<cfcomponent>

	<cffunction name="init" returntype="EventManager.samples.handlers.linksHandler">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getLinks" access="public" returntype="void" output="false">     
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		
		<cfif structKeyExists(url,'nolink')>
		
			<cfset myLinks = [] />
		
		<cfelseif structKeyExists(url,'invalidLink')>
		
			<cfset myLinks = [
				{text = 'Yahoo', href = 'tp://www.yahoo.com'},
				{text = 'Goooogle',href = 'http://www.google.com'}
			] />			
		
		<cfelse>
		
			<cfset myLinks = [
				{text = 'Yahoo', href = 'http://www.yahoo.com'},
				{text = 'Goooogle',href = 'http://www.google.com'}
			] />
		
		</cfif>	
		
		<cfloop array="#myLinks#" index="link">
			<cfset event.addItem(link) />		
		</cfloop>
		
	
	</cffunction>

	<cffunction name="addDefaultLink" access="public" returntype="void" output="false">     
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		
		<cfset link ={text = 'Default Link ( Railo )',href = 'http://www.getrailo.com'}/>
		<cfset event.addItem(link) />		
	
	</cffunction>


	<cffunction name="onMissingLinks" access="public" returntype="void" output="false">     
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		
		<cfset var data = event.getData()/>
		<cfset data['msg'] = 'Just the default Link ..... come on add more links!!!!' />
		
		<cfset event.setData(data) />		
			
	</cffunction>
	
</cfcomponent>