/*
* @Auteur Bastien Pinard
* @date: 10/03/2022
* @Classe: BatchRDD04_CompositionDuFoyer
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD04_CompositionDuFoyer_Test {
    @isTest
    public static void testBatch() {
        list<Contact> listMembreFoyerToInsert = new list<Contact>();
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'Foyer1';
        insert acc1; 
        
        Referentiel_Panel__c refPan = new Referentiel_Panel__c();
        refPan.Name	= Label.RFP_Nom_AIP;
        refPan.Type_de_panel__c =  Label.RFP_TypePanel_AIP;
        insert refPan;
        
        Foyer_paneliste__c fp1 = new Foyer_paneliste__c();
        fp1.RecordTypeId = recordTypeIdFoyerPanelisteAIP;
        fp1.Name = 'FoyerPan1';
        fp1.Referentiel_Panel__c = refPan.Id;
        fp1.Foyer_equipe__c = true;
        fp1.Foyer__c = acc1.Id;
        insert fp1;
        
        
        Contact Compo1 = new Contact();
        Compo1.A_anonymiser__c = true;
        Compo1.Date_d_anonymisation__c = null;
        Compo1.FirstName = 'Compo1';
        Compo1.LastName = 'Compo1';
        Compo1.Type__c = '1';
        Compo1.Birthdate = date.newInstance(1993, 02, 25);
        Compo1.Nombre_d_heures_travaillees__c=3;
        Compo1.Date_de_chute_individu__c = Date.today();
        Compo1.AccountId = acc1.Id;
        Compo1.Lien_parente__c = '1';
        Compo1.MobilePhone='1234567891';
        Compo1.Lettre__c = 'A';
        Compo1.Lien_de_parente_stat__c = '1';
        Compo1.CON_ExtId_SIPanel__c = '122223456';
        Compo1.Lien_parente__c = Label.CON_LienParente_ChefDeFamille;
        Compo1.Activite_actuelle__c = System.Label.CON_ActiviteActuelle_A_la_recherche_premier_emploi;
        Compo1.Code_profession__c = 132;
        
        insert Compo1;     
        System.debug('bastien Compo1 CSP42__c: ' +Compo1.CSP42__c);
        System.debug('bastien Compo1 Code_profession__c: ' +Compo1.Code_profession__c);
        System.debug('bastien Compo1 Date_de_chute_individu__c: ' +Compo1.Date_de_chute_individu__c);
        System.debug('bastien Compo1 Date_de_suppression__c: ' +Compo1.Date_de_suppression__c);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(Compo1.id));
        BatchRDD04_CompositionDuFoyer bccfb = new BatchRDD04_CompositionDuFoyer();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
        
        List<Contact> compList = [
            SELECT Id, Code_profession__c, CSP42__c, Date_de_suppression__c, Date_de_chute_individu__c 
            FROM Contact 
            WHERE Id=:Compo1.Id
        ];
        
        System.debug('bastien : ' +compList);
        System.assertNotEquals(null, compList[0].CSP42__c); 
        System.assertNotEquals(null, compList[0].Date_de_suppression__c); 
    }
}