/*
* @author: Khaled Hammoudeh
* @date: 05/10/2020
* @ Description Class that test AP01_Equipement . Associated Trigger : FoyerBeforeInsert
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@istest
public class AP01_Evenement_Test {
    
    public static testmethod void AP01_EvenementTest()
    {
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount);  
        insert listFoyersToInsert; 
        
        //Create Equipement
        list<Asset> listEquipementToInsert = new list<Asset>();
        Asset TestEquip = Test_Utils.createEquipement(testAccount.Id); 
        listEquipementToInsert.add(TestEquip); 
        Insert listEquipementToInsert;
        
        //Create Etiquette
        list<Etiquette__c> listEtiquetteToInsert = new list<Etiquette__c>();
        Etiquette__c testEtiquette = Test_Utils.createEtiquette(testAccount.Id, null, TestEquip.id, date.today(), date.today() + 5);
        testEtiquette.Nom_de_l_etiquette__c=Label.ETI_Nom_de_l_etiquette_Travaux;
        testEtiquette.Statut__c = Label.ETI_Statut_Actif;
        listEtiquetteToInsert.add(testEtiquette); 
        Insert listEtiquetteToInsert;   
        
        //Create Evenement
        list<Evenement__c> listEvenementToInsert = new list<Evenement__c>();
        Evenement__c testEvent = Test_Utils.createEvenement(TestEquip.id); 
        testEvent.Etat__c = Label.EVENT_Etat_TV_ON;
        listEvenementToInsert.add(testEvent); 
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
        Insert listEvenementToInsert; 
        test.stopTest();
        
    }
}