/*
* @author: Bastien Pinard
* @date: 09/10/2023
* @TestedClass: Batch027_SuppressionCookiesExpire
* @Coverage: 
*/
@isTest
public class Batch027_SuppressionCookiesExpireTest {
    @isTest
    public static void testDeleteCookieConsent(){
        
        CookieConsent__c l = new CookieConsent__c(Name='test');
        insert l;
        Test.setCreatedDate(l.Id, Date.today().addMonths(-14));
        
        SCHD0019_CookiesExpiration sh1 = new SCHD0019_CookiesExpiration();      
        String sch = '0 0 0 ? * * *';
        system.schedule('Test check', sch, sh1);
        
        Test.startTest();
        Batch027_SuppressionCookiesExpire bccfb = new Batch027_SuppressionCookiesExpire();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
        
        List<CookieConsent__c> listCookie = [SELECT Id, CreatedDate FROM CookieConsent__c];
        System.debug(listCookie);
        System.assertEquals(0, listCookie.size());
    }
}