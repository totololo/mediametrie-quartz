@isTest
public class RequeteAfterUpdate_Test {

    @isTest
    static void testRequeteAfterUpdate() {
        User adminUser =[SELECT Id,UserRoleId FROM User WHERE Profile.Name='System Administrator'And IsActive=true Limit 1];
        adminUser.Bypass_validation_rules__c=true;
        update adminUser;
        
         System.runAs(adminUser){
        // Create a test Case record
        Case c = new Case(
            // Initialize your fields here. For example:
            Subject = 'Test Subject',
             Description = 'Test Description',
             Status = 'New'
        );
        insert c;

        // Update the Case record to fire the After update trigger
        Test.startTest();
        c.Status = 'Closed'; // Change a field's value to simulate an update
        update c;
        Test.stopTest();
         }
    }
}