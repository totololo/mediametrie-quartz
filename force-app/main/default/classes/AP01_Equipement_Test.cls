/*
* @author: Khaled Hammoudeh
* @date: 28/09/2020
* @ Description: Class that test AP01_Equipement . Associated Trigger : equipementAfterUpdate
* History
* <Date of modification>	   <Author> 	   <Description of modification>
*/
@istest
public class AP01_Equipement_Test {
    
    public static testmethod void testUpdateEtiquettesStatus() {
        
        //Create Foyers
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount);
        
        insert listFoyersToInsert;
        
        //Create Foyer pan 
        Foyer_paneliste__c testAccountPan = Test_Utils.createFoyerPaneliste();
        testAccountPan.Statut_Foyer_paneliste__c='0';
        insert  testAccountPan; 
        
        //Create composition foyer 
        List<Contact> ListCompositionFoyerToInsert = new List<Contact>();
        Contact compositionFoyer = Test_Utils.createMembreFoyer(testAccount.Id);
        compositionFoyer.Lien_parente__c = '5';
        compositionFoyer.CON_ExtId_SIPanel__c = '122223456';
        ListCompositionFoyerToInsert.add(compositionFoyer);
        insert ListCompositionFoyerToInsert;
        
        //Create équipement
        list<Asset> listEquipementToInsert = new list<Asset>();
        Asset testEquipement = Test_Utils.createEquipement(testAccount.Id);
        testEquipement.Statut_de_connexion__c = Label.ASS_StatutDeConnexion_Disconnected;
        testEquipement.Foyer_paneliste__c=testAccountPan.id;
        listEquipementToInsert.add(testEquipement);
        insert listEquipementToInsert;
       system.debug('nnn'+testEquipement.Name);
        //Create Conctrole
        list<Controle__c> listControleToInsert = new list<Controle__c>();
        Controle__c testCtrl = Test_Utils.createControle(testAccount.Id,null,testEquipement.id,null,system.today());
        testCtrl.Statut__c = Label.CTRL_Statut_Actif;
        testCtrl.Sous_type_de_controle__c = '7';
        testCtrl.Foyer_paneliste__c=testAccountPan.id;
        listControleToInsert.add(testCtrl);
        
        insert listControleToInsert;
        
        //Create Etiquette
        list<Etiquette__c> listEtiquetteToInsert = new list<Etiquette__c>();
        Etiquette__c testEtiquette = Test_Utils.createEtiquette(testAccount.Id, null, testEquipement.Id, date.today(), date.today() + 5);
        testEtiquette.Nom_de_l_etiquette__c=Label.ETI_Nom_de_l_etiquette_Travaux;
        testEtiquette.Statut__c = Label.ETI_Statut_Actif;
        listEtiquetteToInsert.add(testEtiquette);
        
        Insert listEtiquetteToInsert;
        system.debug('nnn'+testEquipement.Name); 
        testEquipement.Statut_de_connexion__c = Label.ASS_StatutDeConnexion_Connected;
        update testEquipement;
        system.debug('nnn'+testEquipement.Name);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccountPan.id)); 
        
        Test.stopTest();
    } 

}