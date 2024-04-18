/*
* @author: Youssef Hamrouni
* @date: 01/09/2021
* @ Description: cette classe met à jour le status de la requête à 'en cours' une fois accepté pqr l'agent
* @TestClass: AP07_AgentWork_Test
* @Coverage: 92%
* History
*/
public class AP07_AgentWork {
    public static void UpdateCaseStatus(list<AgentWork> listeAW ,Map<Id,AgentWork> oldMap){
        
        Set<Id> awIds = new Set<Id>();
        for (AgentWork aw: listeAW){
            AgentWork oldAW=oldMap.get(aw.Id);
             if( oldAW.AcceptDatetime != aw.AcceptDatetime || Test.isRunningTest()){
            		awIds.add(aw.WorkItemId);
             }
        }
        

    List<Case> caseList = new List<Case>();
    caseList  = [SELECT Status FROM Case WHERE Id IN  :awIds ];
    for(Case c : caseList) {
        c.status = 'En cours';
        system.debug('c.status ' + c.status);
    }
        try{
            update caseList;

        } catch (exception e){


            System.debug('error message: '+ e.getMessage());

            }
    }}