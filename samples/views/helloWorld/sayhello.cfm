<cfset em = application.EventManager />

<cfset output = {name = 'Guest'} />
<cfset event = em.createEvent('beforeWelcomeOutput',output) />
<cfset em.dispatchEvent(event=event) />

<cfoutput>
<h1>Hello #output.name# !</h1>
<p>Welcome to EventManager</p>	
</cfoutput>