@isTest
public class Batch0018_MajCtrl_Precode_RS_TEST{
    @isTest
    public static void testTest(){
        
   		date Jminus3 = system.today().adddays(-3);
 	
        account testAccount = Test_Utils.createFoyer();
        insert testAccount;
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.Name = 'MMAT';
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        insert(refPanMMAT);
        
        Id recordTypeIdFoyerPanelisteMMATPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPanelisteMMAT = new Foyer_Paneliste__c();
        foyerPanelisteMMAT.recordTypeId = recordTypeIdFoyerPanelisteMMATPame;
        foyerPanelisteMMAT.Name = 'FP MMAT';
        foyerPanelisteMMAT.Foyer__c = testAccount.Id;
        foyerPanelisteMMAT.Foyer_equipe__c = true;
        foyerPanelisteMMAT.Referentiel_Panel__c = refPanMMAT.Id;
        foyerPanelisteToInsert.add(foyerPanelisteMMAT);
        insert foyerPanelisteToInsert;
        
        controle__c c= new controle__c(Statut__c='Actif',Foyer_Paneliste__c=foyerPanelisteMMAT.Id,Libelle_de_pre_codage__c='',foyer__c=testAccount.Id,tech_reconnecte__c=true, tech_date_precodage__c =Jminus3);
     	insert c;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
        Batch0018_MajCtrl_Precode_RS  btch = new Batch0018_MajCtrl_Precode_RS ();
        database.executeBatch(btch);
        Test.stopTest();
        
       
    }
}