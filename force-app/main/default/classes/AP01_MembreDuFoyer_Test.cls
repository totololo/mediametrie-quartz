/*
* @author: Khaled Hammoudeh
* @date: 28/1/2020
* @ Description Class that test AP01_MembreDuFoyer . Associated Trigger : membreDuFoyerAfterInsert
* History
* <Date of modification>   <Author> 
Jerome HE 29/04/22 
Marliatou 15/12/22
<Description of modification>
*/
@istest
public class AP01_MembreDuFoyer_Test {
    public static testMethod void AP01_MembreDuFoyerTest(){
        User u = [SELECT id, Bypass_triggers__c FROM User WHERE isActive = true and Profile.name like '%dministra%' limit 1];
        Id recordTypeIdFoyerPanelisteAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
        
        System.runAs(u){
            list<Account> listFoyersToInsert = new list<Account>();
            account acc = Test_Utils.createFoyer();
            listFoyersToInsert.add(acc); 
            insert listFoyersToInsert;
            
            Referentiel_Panel__c refPanAIP = new Referentiel_Panel__c();
            refPanAIP.Type_de_panel__c = Label.RFP_Nom_AIP;
            refPanAIP.Name	= Label.RFP_TypePanel_AIP;
            insert refPanAIP;
            
            List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
            Foyer_Paneliste__c foyerPan = new Foyer_Paneliste__c();
            foyerPan.Referentiel_Panel__c = refPanAIP.Id;
            foyerPan.Statut_Foyer_paneliste__c = Label.PAN_Statut_Panel_Installe;
            foyerPan.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
            foyerPan.name = 'TestAP01_Contact';
            foyerPan.Foyer__c = acc.Id;
            foyerPan.Foyer_Paneliste_ExtId_SIPanel__c = 'AZE34';
            foyerPanelisteToInsert.add(foyerPan);
            Insert foyerPanelisteToInsert;
            
            list<Contact> listMembreFoyerToInsert = new list<Contact>();
            Contact Cont = Test_Utils.createMembreFoyer(acc.id); 
            Cont.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
            Cont.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
            Cont.CSP42__c = '132';
            COnt.CSP4__c='1';
            listMembreFoyerToInsert.add(Cont); 
                     
            Test.startTest();
            insert listMembreFoyerToInsert;  
            Cont.MobilePhone = '0123456789';
            update Cont;
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(Cont.Id));
            Test.stopTest();
        }
    }
    
   public static testMethod void AP01_CompoFoyerTest(){
       
           list <String> listContactIds = new List <String>();
           list<Account> listFoyer = new list<Account>();
           list<Contact> listContactToInsert = new list<Contact>(); 
           list<Foyer_Paneliste__c> listfoyerPan = new List<Foyer_Paneliste__c>();
           Id recordTypeIdPAME =Schema.SObjectType.Contact.getRecordTypeInfosByName().get(label.CON_RecordType_PaME).getRecordTypeId();
       
            account acc = Test_Utils.createFoyer();
            listFoyer.add(acc); 
            insert listFoyer;
                
            Contact contact = Test_Utils.createMembreFoyer(acc.id); 
            contact.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
            contact.RecordTypeId = recordTypeIdPAME;
       		contact.CSP4__c='2';
            contact.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
            listContactToInsert.add(contact);
            insert listContactToInsert;
       
            listContactIds.add(contact.Id);
       
           Individu_Paneliste__c indPantest = new Individu_Paneliste__c();
            indPanTest.name = 'indPanTest';
            indPanTest.Lettre__c = 'A';
            indPanTest.Composition_du_foyer__c = contact.id;
            indPanTest.Date_de_chute_de_l_individu__c = null;
            insert indPanTest;
            
            Foyer_Paneliste__c foyerP = Test_Utils.createFoyerPaneliste();  
			foyerP.Foyer__c = acc.Id;
            foyerP.Foyer_Paneliste_ExtId_SIPanel__c = 'AZB34';
            foyerP.Membre_du_foyer__c = contact.Id;
            listfoyerPan.add(foyerP);
            Insert listfoyerPan;
       
             indPanTest.Foyer_paneliste__c = foyerP.id;
             update indPanTest;
            
         
           Test.startTest(); 
            Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(contact.Id));
            List<AP01_MembreDuFoyer.CalloutResponse> resp = AP01_MembreDuFoyer.updateContactToSipanel(listContactIds);
           Test.stopTest();
             
          
         
     }
}