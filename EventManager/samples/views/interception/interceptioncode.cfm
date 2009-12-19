<h2>Interception Event Example Code</h2>
<p>the example simulate an event dispatched before displaying a list of liks.</p>
<h3>Application.cfc</h3>
<pre>
	
	&lt;cfset application.EventManager = CreateObject('component','EventManager.EventManager').init(
				debug = true,
				scope = 'instance'
				)/><br/>
		
	&lt;cfset application.EventManager.loadXml('/EventManager/samples/config/interceptionExample.xml')/><br/>	
		
</pre>
<h3>Configs</h3>
<pre>
    &lt;events><br/>	
        
        &lt;event name="getLinks" type="EventManager.events.CollectDataEvent"><br/>	
            
            &lt;interception point="before">
                &lt;action name="dispatch" event="addDefaultLink" alias="true"/>   
            &lt;/interception><br/>	
            
            &lt;interception point="each">
                &lt;condition>&lt;![CDATA[getEventManager().getHelper('LinksHp').validateLinks(event.getItems())]]>&lt;/condition>
                &lt;action name="throw" type="ValidateLinkExeception" message="Any link must be a valid url" />
            &lt;/interception><br/>	
            
            &lt;interception point="after">
                &lt;condition>&lt;![CDATA[arraylen(event.getItems()) eq 1]]>&lt;/condition>
                &lt;action name="dispatch" alias="true" event="onMissingLinks"/>
            &lt;/interception><br/>	
            
        &lt;/event><br/>	
        
        &lt;event name="addDefaultLink" type="EventManager.events.CollectDataEvent"/><br/>	
        
        &lt;event name="onMIssingLinks" /><br/>	
        
    &lt;/events><br/>	
    
    &lt;listeners><br/>	
                
        &lt;listener 
            event="getLinks" 
            listener="EventManager.samples.handlers.linksHandler" /><br/>	
        
        &lt;listener 
            event="addDefaultLink" 
            listener="EventManager.samples.handlers.linksHandler" /><br/>	
        
        &lt;listener 
            event="onMIssingLinks" 
            listener="EventManager.samples.handlers.linksHandler"/><br/>	
        
    &lt;/listeners>
</pre>
<p>Let's analyze this.</p>
<p>We have an event of type <i>CollectionDataEvent</i> called 'getLinks'.</p>
<p>The event getLinks has some interceptions mapped to differents 'points':</p>
<ul>
	<li>BEFORE : before the first listener is called event 'addDeafultLink' is dispatched. In our example the a Listener add one link. 
	    Note that the action 'dispatch' with an attribute alias that says to EM to pass by to the new event the data scope of the original event. 
		This keeps event data reference intact.</li>
	<li>
		EACH : any time a listener is called a condition is evaluated (with the support of a helper class). If the condition is true
		the 'actions' are runned ( in this case the helper check that the link url added are valid url, if not the action 'throw' is executed ).
	</li>
	<li>AFTER : after all the listener are executed another condition is evaluated. In this case example check the links number. If links length is one means that 
		just the default link is present while no other listener added extra links. In this case a new event 'onMissingLinks' is dispatched. 
	</li>
</ul>
<h3>View : getLinks.cfm</h3>
<pre>
&lt;cfset ev = application.EventManager.createEvent('getLinks')/><br/>
&lt;cftry><br/>
	&lt;cfset application.EventManager.dispatchEvent(event=ev) />	
	&lt;cfset links = ev.getItems() /><br/>
	&lt;cfcatch type="ValidateLinkExeception">
		&lt;cfset links = [{href = "",text = cfcatch.message}] />	
	&lt;/cfcatch><br/>
&lt;/cftry><br/>
	
&lt;cfset data = ev.getData() /><br/>
&lt;cfoutput>
&lt;h3>My Links&lt;/h3>
	&lt;ul>
	&lt;cfloop array="#links#" index="link">
		&lt;li>
			&lt;a href="#link.href#">#link.text#&lt;/a>
		&lt;/li>	
	&lt;/cfloop>
	&lt;/ul>
	&lt;cfif structKeyExists(data,'msg')>
		&lt;strong>#data.msg#&lt;/strong>
	&lt;/cfif>
&lt;/cfoutput>
</pre>
<p>The view dispatch the getLinks event and evaluate what the events returns.</p>
<p>Note that in case a link is not valid an action throw an exeption of type 'ValidateLinkExeception' code will so 'try' and will prepare
also to manage this 'risk'</p>
<p>The link integrity is checked using a helper class. The helper class is added in application.cfc like this:</p>
<pre>
&lt;cfset LinksHelper = createObject('component','EventManager.samples.helpers.LinksHelper') />		
&lt;cfset application.EventManager.setHelper('LinksHp',LinksHelper) />
</pre>
<h3>Listeners</h3>
<p>For example purpose listener of getlinks event use url params to create different situations and to show the 'interceptions' at work.</p>