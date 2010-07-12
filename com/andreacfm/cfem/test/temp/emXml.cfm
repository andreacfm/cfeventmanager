<?xml version="1.0" encoding="UTF-8"?>
<event-manager>

		    		<events>
		        		
		        		<event name="oneEvent"/>
		        		
		        		<event name="anotherEvent" type="com.andreacfm.cfem.test.mocks.Event"/>
		        		
				      	<event name="oneMoreEvent">
				            
				            <interception point="before">
				                <action event="addDefaultSidebar" name="dispatch"/>   
				            </interception>
				
				            <interception class="com.andreacfm.cfem.test.mocks.Interception" point="each"/>
				            
				            <interception point="after">
				                <condition><![CDATA[arraylen(event.getItems()) eq 0]]></condition>
				                <action event="onSidebarMissingItems" eventAlias="true" name="dispatch"/>
				            </interception>
				            
				        </event>
		        		
		    		</events>
				</event-manager>
