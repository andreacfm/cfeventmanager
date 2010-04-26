<!---
Let's generate our default HTML documentation on myself: 
 --->
<cfset mappings = { '/com' = '/home/andrea/dev/www/cfeventmanager/com'}/>
<cfapplication action="update" mappings="#mappings#" />
<cfscript>
	colddoc = createObject("component", "ColdDoc").init();

	strategy = createObject("component", "colddoc.strategy.api.HTMLAPIStrategy").init(expandPath("/cfeventmanager/docs"), "CF Event Manager");
	colddoc.setStrategy(strategy);
	colddoc.generate(expandPath("/cfeventmanager/com/andreacfm/cfem"), "com.andreacfm.cfem");
</cfscript>

<h1>Done!</h1>

<a href="docs">Documentation</a>
