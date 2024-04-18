/** 
* @author: Marleine Abi Khalil
* @date: 16/03/2022 
* @description: Class that test AP02_IndividuPaneliste . Associated Trigger : IndPanAfterUpdate
** History
* <Date of modification>   <Author>    <Description of modification>		
*  20/04/2022              Téoman Sertçelik    fixed class test 
* @Coverage : 100%
*/
@isTest
global class AP02_IndividuPaneliste_Test implements HttpCalloutMock {
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
        u.Bypass_triggers__c = 'AP01_MembreDuFoyer;AP02_Foyer; AP01_IndividuPaneliste;AP01_IndividuPaneliste;AP08_FoyerPaneliste;AP03_Individu_paneliste';
        u.Bypass_flows__c = true;
        update u;
        
        System.runAs(u){
            Account foyerTest = new Account(Name='testPanel');
            insert foyerTest;
            Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
           
            Referentiel_Panel__c refPan = new Referentiel_Panel__c();
            refPan.Name	= Label.RFP_TypePanel_PaME;
            refPan.Type_de_panel__c =  Label.REF_PANEL_TypePan_PAME;
            insert refPan;
           
            Foyer_paneliste__c foyerPan = new Foyer_paneliste__c(RecordTypeId = recordTypeIdPanelMediamatPame,Name='testAip',Foyer__c=foyerTest.id ,Statut_Foyer_paneliste__c=Label.PAN_Statut_panel, Referentiel_Panel__c = refPan.Id );
            insert foyerPan;
            
            Contact con = new Contact(LastName='test', FirstName='test', Birthdate=date.today(), Lien_parente__c = '3', Type__c = '1', CSP4__c='1', AccountId =foyerTest.id);
            insert con;

            Individu_Paneliste__c indPan = new Individu_Paneliste__c(Lettre__c='B');
            indPan.Foyer_paneliste__c = foyerPan.Id;
            indPan.Composition_du_foyer__c = con.Id;
            insert indPan;
            
            indPan.Date_de_chute_de_l_individu__c = date.today();

            Test.startTest();
            update indPan;
            Test.setMock(HttpCalloutMock.class, new AP02_IndividuPaneliste_Test());
            Test.stopTest();
        }
    }
}