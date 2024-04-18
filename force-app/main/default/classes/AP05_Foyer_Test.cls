/** 
* @author: Claire VEHRLE
* @date: 10/08/2021
* @description: Class that test AP05_Foyer . Associated Trigger : FoyerAfterUpdate
*/
@isTest
global class AP05_Foyer_Test {
	global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('Successfull');
        response.setStatusCode(200);
        return response; 
    }
    
    @isTest
	static void envoyerFoyerMulesoftTest(){
        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        u.Bypass_triggers__c = 'AP02_Foyer';
        update u;
        
        System.runAs(u){
            Account foyerTest = new Account();
            foyerTest.Name='testPanel';
            foyerTest.ACC_ExtId_SIPanel__c='ABC1254158545';
            foyerTest.Numero_de_portable__c = '0123456789';
            insert foyerTest;
            
            Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
            
            List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
            Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
            refPanMMAT.Name = 'MMAT';
            refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
            referentielPanelToInsert.add(refPanMMAT);
            
            insert referentielPanelToInsert;
            
            Foyer_paneliste__c foyerPan = new Foyer_paneliste__c();
            foyerPan.RecordTypeId = recordTypeIdPanelMediamatPame;
            foyerPan.Name='testMMAT';
            foyerPan.Foyer__c = foyerTest.id;
            foyerPan.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
            foyerPan.Referentiel_Panel__c = refPanMMAT.Id;
            insert foyerPan;
            
            foyerTest.Jardin__c = true;
            
            //IndividuPanelisteCallout_Mock fakeGetfoyerTest = new IndividuPanelisteCallout_Mock(foyerTest.ACC_ExtId_SIPanel__c);
            IndividuPanelisteCallout_Mock fakeGetfoyerTest = new IndividuPanelisteCallout_Mock(foyerTest.Id);
            
            Test.startTest();
            update foyerTest;
            Test.setMock(HttpCalloutMock.class, fakeGetfoyerTest); 
            Test.stopTest();
            
        }
    }
}