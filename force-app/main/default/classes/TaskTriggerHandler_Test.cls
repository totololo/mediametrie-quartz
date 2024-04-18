@isTest
public class TaskTriggerHandler_Test {

    @isTest
    static void testBeforeInsert() {
        Task newTask = new Task(
            Subject = 'Test Task',
            Priority = 'Normal',
            Status = 'Not Started',
            ActivityDate = date.newInstance(2023, 07, 03)
            // any other required fields
        );

        Test.startTest();
        insert newTask;
        Test.stopTest();

        newTask = [SELECT Id, OwnerId FROM Task WHERE Id = :newTask.Id];
        Group expectedOwner = [SELECT Id FROM Group WHERE Name = 'PRM MC2' and type='Queue'];
        System.assertEquals(expectedOwner.Id, newTask.OwnerId, 'Task owner should be set to PRM MC2 queue');
    }

    @isTest
    static void testAfterUpdate() {
        Task newTask = new Task(
            Subject = 'Test Task',
            Priority = 'Normal',
            Status = 'Not Started',
            UUI__c = '|12345', // This is just an example, use an appropriate value for your org
            AgentId__c = 'yourAgentId', // replace with a valid agent Id for your org
            qualificationCase__c = 'yourCaseId', // replace with a valid case Id for your org
            ActivityDate = date.newInstance(2023, 07, 01)
            // any other required fields
        );
        insert newTask;

        // Update the qualificationCase__c field to simulate the scenario of the qualificationCase__c changing
        newTask.qualificationCase__c = 'anotherCaseId'; // replace with another valid case Id for your org

        Test.startTest();
        update newTask;
        Test.stopTest();

        // Add assertions to verify the expected behavior of your afterUpdate trigger
        // As your trigger method is mostly doing debug logging, there may not be much to assert here
    }
}