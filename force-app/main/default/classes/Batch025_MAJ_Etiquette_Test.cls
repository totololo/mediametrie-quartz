@istest
public class Batch025_MAJ_Etiquette_Test {
    public static testMethod void Batch025_MAJ_Etiquette_Test (){
        
        
        //create foyer
        account acc=Test_Utils.createFoyer();
        insert acc;
        Etiquette__c et = new Etiquette__c();
        et.Date_de_debut__c=system.today();
        et.Date_de_fin__c=system.today();
        et.Statut__c=label.ETI_Statut_Actif;
        et.Foyer__c=acc.id;
        et.Nom_de_l_etiquette__c='Profession atypique';
        insert et;
         
        Test.startTest();
        
        Batch025_MAJ_Etiquette btch = new Batch025_MAJ_Etiquette();
        database.executeBatch(btch); 
        Test.stopTest();
        Etiquette__c eti = [select id ,Statut__c from Etiquette__c where id =:et.id];
        system.assertEquals('Inactif', eti.Statut__c);
    }
}