<cfcomponent output="false">

<cfset this.path = expandPath('/cfeventmanager')>	
<cfset this.name = "#this.path#">

<cfset this.mappings = {
	"/com" = this.path & '/com/',
	"/colddoc" = this.path & '/colddoc/',
	"/logbox" = this.path & '/logbox/'			
}>	

</cfcomponent>