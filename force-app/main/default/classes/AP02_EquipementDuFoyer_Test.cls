/*
* @Auteur : Bastien PINARD
* @date: 26/08/2022
* @ Description : 
- A l'ajout d'un equipement lié à un poste Tv on calcule le nom de cette equipement en fonction du nom du poste tv

-à la suppression d'un poste tv on recalcule le nom de de tous les equipements liés aux postes tv encore existant pour le foyer donné


* @Class: AP02_EquipementDuFoyer
* @Coverage: 92%
History
* <Date of modification> 			<Author> 			<Description of modification>
* 		22/03/23					Marliat D.		     Nommage des accessoires 
* 		21/09/2023				Claire VEHRLE				TMASF-528
* @Coverage: 98%
*/
@isTest
public with sharing class AP02_EquipementDuFoyer_Test {
    
    @isTest
    public static void insertPeripherique(){
                
        Id devPeriRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_Peripheriques).getRecordTypeId();
        Id devPosteTVRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_PosteTV).getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'toto';
        insert acc;
        
        Equipements_du_foyer__c eq1 = new Equipements_du_foyer__c();
        eq1.Foyer__c = acc.Id;
        eq1.Name = 'azer';
        eq1.RecordTypeId = devPosteTVRecordTypeId;
        insert eq1;
        
        Equipements_du_foyer__c eq2 = new Equipements_du_foyer__c();
        eq2.Foyer__c = acc.Id;
        eq2.Name = 'azer';
        eq2.Type__c = Label.EQF_Type_Console_De_Jeux;
        eq2.Poste_TV__c=eq1.Id;
        eq2.RecordTypeId = devPeriRecordTypeId;
        eq2.Modele_de_console_de_jeux__c='28';
        insert eq2;
        
        Equipements_du_foyer__c eq3 = new Equipements_du_foyer__c();
        eq3.Foyer__c = acc.Id;
        eq3.Name = 'azer';
        eq3.Type__c = Label.EQF_Type_Magnetoscope;
        eq3.Poste_TV__c=eq1.Id;
        eq3.RecordTypeId = devPeriRecordTypeId;
        eq3.Marque_du_magnetoscope__c='558'; 
        insert eq3;
        
        //MD
        Equipements_du_foyer__c eq4 = new Equipements_du_foyer__c();
        eq4.Foyer__c = acc.Id;
        eq4.Name = 'Divers';
        eq4.Type__c = Label.EQF_Type_Divers;
        eq4.Poste_TV__c=eq1.Id;
        eq4.RecordTypeId = devPeriRecordTypeId;
        insert eq4;
                   
        //MD
        Equipements_du_foyer__c eq6 = new Equipements_du_foyer__c();
        eq6.Foyer__c = acc.Id;
        eq6.Name = 'DVD';
        eq6.Type__c = Label.EQF_Type_Lecteur_DVD;
        eq6.Poste_TV__c=eq1.Id;
        eq6.RecordTypeId = devPeriRecordTypeId;
        insert eq6;            
        
        Equipements_du_foyer__c eq7 = new Equipements_du_foyer__c();
        eq7.Foyer__c = acc.Id;
        eq7.Name = 'Test';
        eq7.Type__c = Label.EQF_Type_Caster;
        eq7.Poste_TV__c=eq1.Id;
        eq7.RecordTypeId = devPeriRecordTypeId;
        insert eq7;    
        
        List<Equipements_du_foyer__c> testEquipementFoyer = [SELECT Id , Name FROM Equipements_du_foyer__c WHERE Name = 'Console Poste 0 SONY - PLAYSTATION 3'];
        System.assertEquals(1, testEquipementFoyer.size()); 

  } 
    @isTest
    public static void insertDevice(){
        Id devDeviRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get('Devices').getRecordTypeId();
        Id devPosteTVRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get('Poste TV').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'toto';
        insert acc;
        
        Equipements_du_foyer__c eq2 = new Equipements_du_foyer__c();
        eq2.Foyer__c = acc.Id;
        eq2.Name = 'azer';
        eq2.Type__c = Label.EQF_Type_Smartphone;
        eq2.RecordTypeId = devDeviRecordTypeId;
        eq2.Marque_de_telephone__c ='15'; //MD
        insert eq2;
        
        Equipements_du_foyer__c eq3 = new Equipements_du_foyer__c();
        eq3.Foyer__c = acc.Id;
        eq3.Name = 'azer';
        eq3.Type__c =Label.EQF_Type_OrdinateurPortable;
        eq3.RecordTypeId = devDeviRecordTypeId;
        eq3.Marque_d_ordinateur__c ='1'; //MD
        insert eq3;
        
        //MD
        Equipements_du_foyer__c eq4 = new Equipements_du_foyer__c();
        eq4.Foyer__c = acc.Id;
        eq4.Name = 'Ord fixe';
        eq4.Type__c= Label.EQF_Type_OrdinateurFixe;
        eq4.RecordTypeId = devDeviRecordTypeId;
        eq4.Marque_d_ordinateur__c ='1'; 
        insert eq4;
        
        //MD
        Equipements_du_foyer__c eq5 = new Equipements_du_foyer__c();
        eq5.Foyer__c = acc.Id;
        eq5.Name = 'Tab';
        eq5.Type__c = Label.EQF_Type_Tablette;
        eq5.Marque_Tablette__c = '1';
        eq5.RecordTypeId = devDeviRecordTypeId;
        insert eq5;        
        
        List<Equipements_du_foyer__c> testEquipementFoyer = [SELECT Id , Name FROM Equipements_du_foyer__c WHERE Name = 'Mobile Samsung'];
        System.assertEquals(1, testEquipementFoyer.size()); 
    }
    
    @isTest
    public static void deleteUpdatePeripheriqueName(){
        Id devPeriRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get('Périphériques').getRecordTypeId();
        Id devPosteTVRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get('Poste TV').getRecordTypeId();
        
        Account acc = new Account();
        acc.Name = 'toto';
        insert acc;
        
        Equipements_du_foyer__c eq1 = new Equipements_du_foyer__c();
        eq1.Foyer__c = acc.Id;
        eq1.Name = 'azer';
        eq1.RecordTypeId = devPosteTVRecordTypeId;
        insert eq1;
        
        Equipements_du_foyer__c eq2 = new Equipements_du_foyer__c();
        eq2.Foyer__c = acc.Id;
        eq2.Name = 'azer';
        eq2.Type__c = Label.EQF_Type_Console_De_Jeux;
        eq2.Poste_TV__c=eq1.Id;
        eq2.RecordTypeId = devPeriRecordTypeId;
        eq2.Modele_de_console_de_jeux__c='28';
        insert eq2;
               
        Equipements_du_foyer__c eq3 = new Equipements_du_foyer__c();
        eq3.Foyer__c = acc.Id;
        eq3.Name = 'azer';
        eq3.RecordTypeId = devPosteTVRecordTypeId;
        insert eq3;
        
        Equipements_du_foyer__c eq4 = new Equipements_du_foyer__c();
        eq4.Foyer__c = acc.Id;
        eq4.Name = 'azer';
        eq4.Type__c = Label.EQF_Type_Console_De_Jeux;
        eq4.Poste_TV__c=eq3.Id;
        eq4.RecordTypeId = devPeriRecordTypeId;
        eq4.Modele_de_console_de_jeux__c='35';
        insert eq4;

        delete eq1;
        
        List<Equipements_du_foyer__c> testEquipementFoyer = [SELECT Id , Name FROM Equipements_du_foyer__c WHERE Name = 'Console Poste 0 MICROSOFT - XBOX One'];
        System.assertEquals(1, testEquipementFoyer.size()); 
    }
    
    @isTest
    public static void UpdateNameTest(){
 Id devPeriRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_Peripheriques).getRecordTypeId();
  Id devPosteTVRecordTypeId =Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_PosteTV).getRecordTypeId();
               
        Account acc = new Account();
        acc.Name = 'toto';
        insert acc;
        
        Equipements_du_foyer__c eq1 = new Equipements_du_foyer__c();
        eq1.Foyer__c = acc.Id;
        eq1.Name = 'azera';
        eq1.Fournisseur__c='3';
        eq1.RecordTypeId = devPosteTVRecordTypeId;
        insert eq1;
        
        eq1.Fournisseur__c='4';
        update eq1;
        
    }
}