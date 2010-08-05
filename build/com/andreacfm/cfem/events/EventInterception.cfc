<cfcomponent extends="com.andreacfm.cfem.events.AbstractEventInterception" output="false">
	
	<cffunction name="update" access="public" returntype="void">
		<cfargument name="event" type="com.andreacfm.cfem.events.AbstractEvent" required="yes" />
		
		<cfset var condition = getCondition() />
		
		<!--- we have a condition --->
		<cfif len(condition)>
			<cfif isConditionTrue(event)>
				<cfset execute(event)/>
			</cfif>
		<cfelse>
			<cfset execute(event) />	
		</cfif>
				
	</cffunction>
	
</cfcomponent>