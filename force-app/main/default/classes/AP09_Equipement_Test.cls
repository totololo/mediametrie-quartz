/*
* @author: Claire 
* @date: 20/12/2022
* @ Description : Unicité du MeterId (Audimetre__c) pour les équipements
* @Coverage: --%

* History
* <Date of modification>   <Author>    <Description of modification>
*/
@IsTest
public class AP09_Equipement_Test {
    
    @isTest
    static void meterIdUnique() {
        
        Account foyer = new Account();
        foyer.Name = 'Test';
        insert foyer;
        
        List<Asset> eqtListToInsert1 = new List<Asset>();
        Asset eqt1 = new Asset();
        eqt1.accountId = foyer.Id;
        eqt1.Audimetre__c = '123456';
        eqt1.Name='123';
        eqtListToInsert1.add(eqt1);
        //
        insert eqtListToInsert1;
        
        List<Asset> eqtListToInsert2 = new List<Asset>();
        Asset eqt2 = new Asset();
        eqt2.accountId = foyer.Id;
        eqt2.Audimetre__c = '123456';
        eqtListToInsert1.add(eqt2);
        
        Database.SaveResult[] results = Database.insert(eqtListToInsert2, false);
        
    }

}