/*
* @author: Elia KARAM
* @date: 01/03/2022
* @ Description Batch pour la RDD de l'objet Foyer
* @TestClass: BatchRDD01_Foyer_Test
* @Coverage: 90 %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD02_Foyer implements Database.Batchable<sObject>{
    
    public Database.Querylocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator([SELECT Id,Personne_de_reference__r.LastName,Name, Type_de_foyer__c, ShippingStreet, (SELECT Id, LastName FROM Contacts WHERE Type__c = :Label.CON_Type_MEMBRE)
                                         FROM Account 
                                         WHERE name like '%1%' OR name like '%2%' OR name like '%3%' OR name like '%4%' 
                                         OR name like '%5%' OR name like '%6%' OR name like '%7%' OR name like '%8%' 
                                         OR name like '%ç%' OR name like '%0%']);
    } 
    
    public void execute(Database.BatchableContext info, List<Account> scope){
        
        for(Account foyer : scope){
            Boolean NomModifie = false;
            
            if(foyer.Type_de_foyer__c == Label.ACC_Type_de_panel_AIP && !NomModifie && foyer.Contacts.size() >0) {
                foyer.name = foyer.Contacts[0].LastName;
                NomModifie = true;
            }
            if (foyer.ShippingStreet != null && !NomModifie) {
                if(foyer.ShippingStreet.StartsWith('Rue_'))  {
                    foyer.name = 'Foyer anonymisé'; 
                    NomModifie = true;
                }
            }
            if(foyer.Personne_de_reference__r.LastName != null && !NomModifie) {
                foyer.name = foyer.Personne_de_reference__r.LastName; 
                NomModifie = true;
            }
            
        }
        
        System.debug('$$$scope.size(): ' + scope.size());
        if(scope.size() > 0 && scope != null){
            try{ 
                database.update(scope, false);
            }Catch(exception ex){
                system.debug('Update Foyer Exception Error:' + ex.getmessage());
            }
        } 
    }     
    public void finish(Database.BatchableContext info){     
    } 
}