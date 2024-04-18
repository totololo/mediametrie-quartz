@isTest
public class TestTaskTrigger {
    
    @isTest static void TestTask(){
        Task T  = new Task(Subject='test task', ActivityDate=system.today());  
        insert T;
        Boolean TriggerDisabled;
        TaskTriggerHandler.isDisabled();
    }

}