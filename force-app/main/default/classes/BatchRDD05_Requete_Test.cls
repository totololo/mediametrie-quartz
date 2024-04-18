/*
* @Auteur Claire VEHRLE
* @date: 10/03/2022
* @Classe: BatchRDD05_Requete
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD05_Requete_Test {

    @isTest
    Static void RDD_Requete() {
        
        Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
		user u = [select id from user where profile.name like '%admin%' and isactive=true limit 1];
        u.Bypass_validation_rules__c=true;
        update u;
        system.runAs(u){
        List<Account> foyerList = new List<Account>();
        Account foyer1 = Test_Utils.createFoyer();
        foyer1.Name = 'Foyer 1';
        foyer1.Numero_de_portable__c = '0611111121';
        foyerList.add(foyer1);
        
        Account foyer2 = Test_Utils.createFoyer();
        foyer2.Name = 'Foyer 2';
        foyer2.Numero_de_portable__c = '0622222222';
        foyerList.add(foyer2);
        
        insert foyerList;
        
        List<Foyer_Paneliste__c> foyerPanelisteList = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste1 = new Foyer_Paneliste__c();
        foyerPaneliste1.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste1.Name = 'Foyer Paneliste 1';
        foyerPaneliste1.Foyer__c = foyer1.Id;
        foyerPanelisteList.add(foyerPaneliste1);
        
        Foyer_Paneliste__c foyerPaneliste2 = new Foyer_Paneliste__c();
        foyerPaneliste2.RecordTypeId = recordTypeIdFoyerPanelisteMMATPaME;
        foyerPaneliste2.Name = 'Foyer Paneliste 2';
        foyerPaneliste2.Foyer__c = foyer2.Id;
        foyerPanelisteList.add(foyerPaneliste2);
        
        insert foyerPanelisteList;
        

        Case requete = new Case();
        requete.AccountId = foyer2.Id;
        requete.Status = 'Nouveau';
        requete.Origin = 'Appel Entrant';
        
        insert requete;
        
        Test.startTest();
        BatchRDD05_Requete btch = new BatchRDD05_Requete();
        database.executeBatch(btch);
        Test.stopTest();
        
        List<Case> requeteBatch = [SELECT Id, Foyer_Paneliste__r.Id FROM Case WHERE AccountId = :foyer2.Id];
        System.debug('$$$requeteBatch: '+ requeteBatch);
        System.assertEquals(foyerPaneliste2.Id, requeteBatch[0].Foyer_Paneliste__r.Id);
        }
    }
}