Created: Object_A__c, Object_B__c, Object_C__c
Created: field in Object_B__c -> lookup to Object_A__c
Created: field in Object_C__c -> lookup to Object_B__c

NOTE --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
It was assumed that C could not look at A, since it wasn't specified in the requirement. Alternatively there could have been a formula field on C that copied the lookup from its parent B i.e.: 
A1
B1 looks up to A1
C1 looks up to B1 therefore - through formula field - looks up to A1.
END NOTE --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Created: relatedObjectsTable lwc, relatedObjectsTableController apxc and relatedObjectsTableControllerTest apxc

package.xml in manifest folder has everything
package.xml in this folder is the package with the metadata that would be sent to deployment
