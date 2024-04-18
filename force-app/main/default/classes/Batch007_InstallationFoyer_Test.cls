/*
* @author: Joyce Saidy
* @date: 5/10/2020
* @ Description Class that test Batch007_InstallationFoyer  
* History
* <Date of modification>   <Author>    <Description of modification>
*/ 
@isTest
public class Batch007_InstallationFoyer_Test {
    public static testMethod void Batch007_InstallationFoyerTest(){
         
        //Create foyer
        list<Account> listFoyersToInsert = new list<Account>();
        account testAccount = Test_Utils.createFoyer();
        testAccount.Numero_de_portable__c = '0611111121';
        listFoyersToInsert.add(testAccount); 
        testAccount.Statut_du_foyer__c=Label.ACC_Statut_du_foyer_Recrute;
        insert listFoyersToInsert;         
        
        //MD
        //Foyer Panéliste
        List<Foyer_paneliste__c> listFoyerPaneliste = new List<Foyer_paneliste__c>();
        Foyer_Paneliste__c foyerPaneliste = Test_Utils.createFoyerPaneliste();
        foyerPaneliste.Foyer__c = testAccount.id;
        foyerPaneliste.Name = 'test foyer panéliste';
        listFoyerPaneliste.add(foyerPaneliste);        
        insert listFoyerPaneliste;
        
        //MD
        //Create Case
        list<Case> listCaseToInsert = new list<Case>();
        Case testCase = Test_Utils.createCase(testAccount.id);
        testCase.Origin = Label.CAS_Origine_NouveauFoyer;
        testCase.Foyer_paneliste__c = foyerPaneliste.Id;
        listCaseToInsert.add(testCase);  
        insert listCaseToInsert;
                
        Test.startTest();
        Batch007_InstallationFoyer btch = new Batch007_InstallationFoyer();
        database.executeBatch(btch);
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
        Test.stopTest();
        
    }
}