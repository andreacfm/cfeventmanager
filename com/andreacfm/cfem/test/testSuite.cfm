<cfparam name="URL.output" default="extjs">
<cfscript>	
 testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite();
 testSuite.addAll("com.andreacfm.cfem.test.RegressionTest");
 testSuite.addAll("com.andreacfm.cfem.test.EventManagerTest");
 results = testSuite.run();
</cfscript>
<cfoutput>#results.getResultsOutput(URL.output)#</cfoutput>  
<!--- <p><hr /></p>
<p>Using CFDUMP against <code>mxunit.TestResult.getResults()</code> method</p>
<cfdump var="#results.getResults()#" label="MXUnit Sample Test Results" />
 --->