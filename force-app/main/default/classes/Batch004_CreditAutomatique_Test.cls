/*
* @author: Joyce Saidy
* @date: 28/09/2020
* @ Description Class that test Batch004_CreditAutomatique1foisparMois 
* History
* <Date of modification>   <Author>    <Description of modification>
    10/08/2021               ER         Corrections faites pour ajouter le type d'enregistrement et le nombre de TV aux comptes créés (ticket MEDIAMETRIE-261) 
*/

@isTest
public class Batch004_CreditAutomatique_Test {
    public static testMethod void Batch004_CreditAutomatiqueTest(){
        Boolean isChristmas = (Date.Today().month() == 1);
       
        //insert Account(foyer)
        list<Account> listFoyersToInsert = new list<Account>();
        Id recordTypeIdEquipe = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(label.Acc_TypeD_Enregistrement_Equipe).getRecordTypeId(); //Added by ER for MEDIAMETRIE-261
        account testAccount = Test_Utils.createFoyer();
        testAccount.Date_d_installation__c=System.today()-30;
        testAccount.Numero_de_portable__c = '0611111121';
        //Added by ER for MEDIAMETRIE-261 Start
        testAccount.RecordTypeId = recordTypeIdEquipe;
        testAccount.Nombre_TV__c = '3'; 
        //Added by ER for MEDIAMETRIE-261 End
        listFoyersToInsert.add(testAccount);
        //acc
        account testAccount1 = Test_Utils.createFoyer();
         testAccount1.RecordTypeId = recordTypeIdEquipe;
        testAccount1.Date_d_integration__c=system.today()-23;
        testAccount1.Statut_du_foyer__c='1';
        testAccount1.Date_d_installation__c=system.today()-23;
          listFoyersToInsert.add(testAccount1);
        
        account testAccount2 = Test_Utils.createFoyer();
         testAccount2.RecordTypeId = recordTypeIdEquipe;
        testAccount2.Date_d_installation__c=system.today()-23;
        
        testAccount2.Statut_du_foyer__c='1';
        testAccount2.Freeze__c=true;
        testAccount2.Date_de_Freeze__c=system.today();
          listFoyersToInsert.add(testAccount2);
       
       
        
       account annivAccount = Test_Utils.createFoyer();
        annivAccount.Date_d_installation__c = date.newInstance(system.today().year() - 2, system.today().month() - 1, system.today().day());
        annivAccount.Numero_de_portable__c = '0611131121';
        annivAccount.Statut_du_foyer__c='1';
        //Added by ER for MEDIAMETRIE-261 Start
        annivAccount.RecordTypeId = recordTypeIdEquipe;
        annivAccount.Nombre_TV__c = '3'; 
        //Added by ER for MEDIAMETRIE-261 End
        listFoyersToInsert.add(annivAccount);
        
        account annivAccount2 = Test_Utils.createFoyer();
        annivAccount2.Date_d_installation__c = date.newInstance(system.today().year() - 1, system.today().month() - 1, system.today().day());
        annivAccount2.Numero_de_portable__c = '0611131121';
        //Added by ER for MEDIAMETRIE-261 Start
        annivAccount2.RecordTypeId = recordTypeIdEquipe;
        annivAccount2.Nombre_TV__c = '3'; 
        annivAccount.Statut_du_foyer__c='1';
        //Added by ER for MEDIAMETRIE-261 End
        listFoyersToInsert.add(annivAccount2);
        
        account annivAccount1 = Test_Utils.createFoyer();
        annivAccount1.Date_d_installation__c = date.newInstance(system.today().year() - 2, system.today().month() - 1, system.today().day());
        annivAccount1.Numero_de_portable__c = '0611131171';
     	annivAccount1.Freeze__c=true;
        annivAccount1.Statut_du_foyer__c='3';
        annivAccount1.Date_de_Freeze__c=system.today();
        annivAccount1.RecordTypeId = recordTypeIdEquipe;
        annivAccount1.Nombre_TV__c = '3';
        
       
        listFoyersToInsert.add(annivAccount1);
        
        insert listFoyersToInsert;	 
        Test.startTest();
        
        Batch004_CreditAutomatique1foisparMois btch = new Batch004_CreditAutomatique1foisparMois();
        database.executeBatch(btch);
        Batch005_CreditAutomatique1foisparAn btch1 = new Batch005_CreditAutomatique1foisparAn();
        database.executeBatch(btch1);
        Batch006_CreditAutomatique1foisparAn btch2 = new Batch006_CreditAutomatique1foisparAn(true);
        database.executeBatch(btch2);
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(testAccount.id)); 
        Test.stopTest();
    }
}