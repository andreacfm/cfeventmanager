<cfcomponent output="false">
	
	<!--- Application name, should be unique --->
	<cfset this.name = "EventManager Tests">
	<!--- Should we even use sessions? --->
	<cfset this.sessionManagement = true>
	
	<!--- define custom coldfusion mappings. Keys are mapping names, values are full paths  --->
	<cfset this.mappings = structNew()>
	<!--- define a list of custom tag paths. --->
	<cfset this.customtagpaths = "">

</cfcomponent>