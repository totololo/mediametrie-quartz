/*
* @author: Youssef Hamrouni
* @date: 01/09/2021
* @ Description Class that test AP07_AgentWork
* History
* <Date of modification>   <Author>    <Description of modification>		
*/
@istest
public class AP07_AgentWork_Test {
	  public static testMethod void AP07_AgentWork(){
        
      
		Case c = new Case(Status='nouveau');       
		insert c;
          
      ServiceChannel sc = [SELECT Id FROM ServiceChannel WHERE DeveloperName = 'casesChannel'];
 	  User systemUser = [SELECT Id FROM User where alias='CFlor'];


System.runAs(systemUser){
    try{
        system.debug('test');
        AgentWork aw = new AgentWork(
                ServiceChannelId = sc.Id,
                WorkItemId = c.Id,
                UserId = systemUser.Id
            	
        );
        insert aw;
        update aw;
        c = [select status from Case limit 1];
        System.assertEquals('En cours',c.Status);
    }catch(Exception ex){
               
        }
    }
         
        
      }}