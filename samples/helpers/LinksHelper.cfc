<cfcomponent>
	
	<cffunction name="validateLinks" returntype="boolean" output="false">    
		<cfargument name="links" type="Array" required="true" />
		<cfscript>
		var iterator = arguments.links.iterator();
		var href = '';
		while(iterator.hasNext()){
			href = iterator.next().href; 
			if(not isValid('url',href)){
				return true;
			}
		}
		return false;
		</cfscript>	
	</cffunction>
	
</cfcomponent>