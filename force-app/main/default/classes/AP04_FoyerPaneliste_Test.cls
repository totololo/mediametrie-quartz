/*
* @date: 21/07/2021
* @ Description : tester la classe AP04_FoyerPaneliste
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @Coverage: 90%
History
* <Date of modification> <Author> 	<Description of modification>
*/
@isTest
public class AP04_FoyerPaneliste_Test {
    @isTest static void testFoyerPAnelsiteChute() {// tester la methode FoyerPAnelisteChute
        Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        // Créer un foyer pour l'insérer dans le panel
        Account foyerTest = new Account(Name='testPanel');
        insert foyerTest;
        // Créer un panel Aip
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        
        Referentiel_Panel__c refPanAIP = new Referentiel_Panel__c();
        refPanAIP.Name = 'AIP';
        refPanAIP.Type_de_panel__c = Label.RFP_TypePanel_AIP;
        referentielPanelToInsert.add(refPanAIP);
        
        insert referentielPanelToInsert;
  
        List<Foyer_paneliste__c> testPanelAip = new List<Foyer_paneliste__c>(); 
    
        Foyer_paneliste__c fp1 = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelAIP,Name='testAip1',Foyer__c=foyerTest.id,	Statut_Foyer_paneliste__c=Label.PAN_Statut_panel, referentiel_panel__c = refPanAIP.Id);
        testPanelAip.add(fp1);
        insert testPanelAip;  
        
        
        List<Id> panID=new List<Id>();
        for(Foyer_paneliste__c fp :testPanelAip){
            panID.add(fp.id);
        }
        AP04_FoyerPaneliste.FoyerPAnelisteChute(panID);
        Foyer_paneliste__c testFp =[SELECT Id,Statut_Foyer_paneliste__c FROM Foyer_paneliste__c Limit 1]; 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(foyerTest.id));       
        System.assertEquals(Label.PAN_Statut_Panel_Chute_temporaire,testFp.Statut_Foyer_paneliste__c);
        Test.stopTest();
        
        
    }
    
}