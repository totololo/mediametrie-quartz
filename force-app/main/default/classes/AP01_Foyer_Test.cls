/*
* @author: Joyce Saidy
* @date: 02/09/2020
* @ Description Class that test AP01_Foyer . Associated Trigger : FoyerAfterInsert ,FoyerBeforeInsert
* History
* <Date of modification>   <Author>    <Description of modification>
*/
@isTest 
public class AP01_Foyer_Test {
    public static testMethod void AP01_FoyerTest(){ 
        
        OperatingHours oh = new OperatingHours();
        oh.Name = 'OperatingHour1';
        insert oh; 
        
        ServiceTerritory ts = new ServiceTerritory();
        ts.name='Est';
        ts.OperatingHoursId=oh.id;
        insert ts;
        ServiceTerritory ts2 = new ServiceTerritory();
        ts2.name='Ouest';
        ts2.OperatingHoursId=oh.id;
        insert ts2;
        //Création custom setting
        Territoire_de_Service__c CustomSetting= new Territoire_de_Service__c();
        CustomSetting.name = '01';
        CustomSetting.Nom_du_territoire__c='Est';
        Territoire_de_Service__c CustomSetting2= new Territoire_de_Service__c();
        CustomSetting2.name = '12';
        CustomSetting2.Nom_du_territoire__c='Ouest';
        insert CustomSetting2;
        
        //Création foyer
        Account acc = new Account();
        acc.name='Dupond';
        acc.ShippingPostalCode='01234';
        acc.Statut_du_foyer__c=Label.ACC_Statut_du_foyer_Recrute;
        acc.Type_de_foyer__c = Label.ACC_Type_de_panel_Mediamat;
        acc.Numero_de_portable__c = '0611111121';

        //creation Code_Postal_Commune__c
        Code_Postal_Commune__c cp=new Code_Postal_Commune__c();
        cp.Name='VELIZY-VILLACOUBLAY';
        cp.Code_postal__c=78140;

        insert cp;

        test.startTest(); 
        insert acc; 
        Test.setMock(HttpCalloutMock.class, new MembreFoyerCallout_Mock(acc.id)); 
        Account acc1=[Select Id , ShippingPostalCode, ShippingCity,Personne_de_reference__c from Account Where Id=:acc.Id ];

        AP01_Foyer.NouvelleReq(new Account[]{acc1});
       // System.debug(acc1);
        acc1.ShippingPostalCode='78140';
        acc1.ShippingCity='VELIZY-VILLACOUBLAY';
       // System.debug(acc1);
        update acc1;
        test.stopTest();
    }
}