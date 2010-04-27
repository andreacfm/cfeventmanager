<cfparam name="URL.output" default="extjs">
<cfinclude template="settings.cfm">
<cfscript>	
 testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();
 testSuite.addAll("#cfcroot#.EventManagerTest");
 testSuite.addAll("#cfcroot#.AppenderTest");
 results = testSuite.run();
</cfscript>
<cfoutput>#results.getResultsOutput(URL.output)#</cfoutput>  
<!--- <p><hr /></p>
<p>Using CFDUMP against <code>mxunit.TestResult.getResults()</code> method</p>
<cfdump var="#results.getResults()#" label="MXUnit Sample Test Results" />
 --->