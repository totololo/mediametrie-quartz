@isTest
public class BatchRDD07_Etiquette_Test {
    
    @isTest
    Static void etiqu(){
         Id recordTypeIdFoyerPanelisteMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();

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
        Etiquette__c et = new Etiquette__c();
        et.Foyer__c = foyer2.id;
        et.Nom_de_l_etiquette__c = 'Foyer test';
        insert et;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(et.id));
        BatchRDD07_Etiquette btch = new BatchRDD07_Etiquette();
        database.executeBatch(btch);
        Test.stopTest();
        
        List<Etiquette__c> etiBatch = [SELECT Id, Foyer_Paneliste__c FROM Etiquette__c WHERE foyer__c = :foyer2.Id];
        
        System.assertEquals(foyerPaneliste2.Id, etiBatch[0].Foyer_Paneliste__c);
    }

}