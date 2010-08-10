<cfcomponent output="false">

<cfset this.path = expandPath('/cfeventmanager')>	
<cfset this.mappings = {
	com = this.path & '/com/',
	colddoc = this.path & '/colddoc/'	
}>	

</cfcomponent>