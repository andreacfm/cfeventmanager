<!---
Let's generate our default HTML documentation on myself: 
 --->
<cfset mappings = { '/com' = '/Users/andrea/dev/www/cfeventmanager/com'}/>
<cfapplication action="update" mappings="#mappings#" />
<cfscript>
	colddoc = createObject("component", "ColdDoc").init();
	strategy = createObject("component", "colddoc.strategy.api.HTMLAPIStrategy").init(expandPath("/cfeventmanager/docs"), "CF Event Manager - @projectVersion.@number [@date]");
	colddoc.setStrategy(strategy);
	colddoc.generate([
		{inputDir=expandPath("/cfeventmanager/com/andreacfm/cfem"), inputMapping="com.andreacfm.cfem", recurse = false},
		{inputDir=expandPath("/cfeventmanager/com/andreacfm/cfem/dispatch"), inputMapping="com.andreacfm.cfem.dispatch"},
		{inputDir=expandPath("/cfeventmanager/com/andreacfm/cfem/events"), inputMapping="com.andreacfm.cfem.events"},		
		{inputDir=expandPath("/cfeventmanager/com/andreacfm/cfem/factory"), inputMapping="com.andreacfm.cfem.factory"},		
		{inputDir=expandPath("/cfeventmanager/com/andreacfm/cfem/listener"), inputMapping="com.andreacfm.cfem.listener"},		
		{inputDir=expandPath("/cfeventmanager/com/andreacfm/cfem/stats"), inputMapping="com.andreacfm.cfem.stats"},		
		{inputDir=expandPath("/cfeventmanager/com/andreacfm/cfem/util"), inputMapping="com.andreacfm.cfem.util"}		

	]);
</cfscript>

<h1>Done!</h1>

<a href="docs">Documentation</a>
