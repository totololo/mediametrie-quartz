/** 
* @author: Marleine Abi Khalil
* @date: 21/03/2022 
* @description: Class that test AP07_FoyerPaneliste . Associated Trigger : FoyerPanelisteAfterUpdate
*/
@isTest
global class AP07_FoyerPaneliste_Test implements HttpCalloutMock {
	// Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('Successfull');
        response.setStatusCode(200);
        return response; 
    }
    
    @isTest
	static void deprovisionningGoogleTest(){
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
            foyerPan.Referentiel_Panel__c = refPanMMAT.Id;
            insert foyerPan;
            
            foyerPan.Date_d_installation__c= date.today();
            foyerPan.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
                        
            IndividuPanelisteCallout_Mock fakeGetfoyerPaneliteTest = new IndividuPanelisteCallout_Mock(foyerPan.Id);
            
            Test.startTest();
            update foyerPan;
            Test.setMock(HttpCalloutMock.class, fakeGetfoyerPaneliteTest); 
            Test.stopTest();
        }
    }  

}