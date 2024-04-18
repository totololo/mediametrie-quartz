/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 09-29-2022
 * @last modified by  : Anes BOUZOUINA
**/

public class TaskTriggerHandler extends TriggerHandler //implements ITriggerHandler
{
    private Map<Id, Task> newMap;
    private Map<Id, Task> oldMap;
    private List<Task> triggerNew;
    private List<Task> triggerOld;
    
    public TaskTriggerHandler(){
        this.newMap = (Map<Id, Task>) Trigger.newMap;
        this.oldMap = (Map<Id, Task>) Trigger.oldMap;
        this.triggerNew= (List<Task>) Trigger.New;
        this.triggerOld= (List<Task>) Trigger.Old;
    }
    public static Boolean TriggerDisabled = false;
    public Boolean isDisabled(){
        return TriggerDisabled;
    }
    public override void beforeInsert() {
        Group q = [SELECT Id FROM Group WHERE Name = 'PRM MC2'and type='Queue' ];
	for(Task  l:triggerNew){
   		
			l.ownerid=q.id;
   		 }
    }
    	//mis en commentaire pas bastien pinard pour déploiement en prod 04/07/2023
       /*public override void afterUpdate()  {   
        for( Task taskItr : triggerNew){
            system.debug('this.oldMap.get(taskItr.Id).qualificationCase__c '+this.oldMap.get(taskItr.Id).qualificationCase__c);
            system.debug('taskItr.qualificationCase__c   ' + taskItr.qualificationCase__c  );
            if( this.oldMap.get(taskItr.Id).qualificationCase__c   != taskItr.qualificationCase__c   ){
               
                // try to remove this line ;)
                String tryId = taskItr.UUI__c.substringAfter('|');
                system.debug('tryId=  '+tryId) ;
                system.debug('taskItr.AgentId__c=  '+taskItr.AgentId__c) ;
                system.debug('taskItr.qualificationCase__c=  '+taskItr.qualificationCase__c) ;
                //AP09_WebService_Avaya.QualifyTry(tryId ,taskItr.AgentId__c,taskItr.qualificationCase__c);
            }
        }
        
     }*/

         /*
          *     public override void afterInsert() {
       
    {
    }
    
    public override void beforeUpdate() {}
    

    
    public override void beforeDelete() {}
    
    public override void afterDelete() {}
    
    public override void afterUnDelete() {}*/
}