<cfset xmlPath = '/EventManager/test/EventManager.xml' />			
<cfset application.em = createObject('component','EventManager.eventManager').init(debug=true,scope="instance",xmlPath=xmlPath) />
<cfset data = {label = 'testLoadXml1'} />
<cfset ev = application.em.createEvent('MxUnit1',data,getTemplatepath(),'asynch')/>
<cfset application.em.dispatchEvent(event=ev) />
<cfset ev2 = application.em.createEvent('MxUnit2',data,getTemplatepath())/>
<cfset application.em.dispatchEvent(event=ev2) />
<cfset application.em.dispatchEvent(event=ev2) />
<cfset sleep(2000) />
<cfoutput>#application.em.renderDebug()#</cfoutput>
