/*
* @Auteur Claire VEHRLE
* @date: 10/03/2022
* @Classe: BatchRDD06_Controle
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD06_Controle_Test {

    @isTest
    Static void RDD_Controle() {
        
        Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();

        List<Account> foyerList = new List<Account>();
        Account foyer1 = Test_Utils.createFoyer();
        foyer1.Name = 'Foyer 1';
        foyer1.Numero_de_portable__c = '0611111121';
        foyerList.add(foyer1);
        
        Account foyer2 = Test_Utils.createFoyer();
        foyer2.Name = 'Foyer 2';
        foyer2.Numero_de_portable__c = '0622222222';
        foyer2.Type_de_foyer__c=Label.ACC_Type_de_panel_Mediamat;
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
        
        Controle__c controle = new Controle__c();
        controle.Foyer__c = foyer2.Id;
        controle.Foyer_paneliste__c = foyerPaneliste1.Id;
        
        insert controle;
        
        Test.startTest();
        BatchRDD06_Controle btch = new BatchRDD06_Controle();
        database.executeBatch(btch);
        Test.stopTest();
        
        Controle__c controleBatch = [SELECT Id, Foyer_Paneliste__c FROM Controle__c WHERE Foyer__c = :foyer2.Id];
        
        System.assertEquals(foyerPaneliste2.Id, controleBatch.Foyer_Paneliste__c);
        
    }
}