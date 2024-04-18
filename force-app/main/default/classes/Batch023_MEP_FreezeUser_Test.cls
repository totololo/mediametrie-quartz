/*
* @Auteur : Bastien Pinard
* @date: 08/03/2023
* @Classe: Batch023_MEP_FreezeUser
* * History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class Batch023_MEP_FreezeUser_Test {
    
    @isTest static void testFreezerUser() {
        Profile pfAdmin= [Select Id from profile where Name='Administrateur système' or  Name='System Administrator']; 
        Profile pfNonAdmin= [Select Id from profile where Name='Ambassadeur']; 
        List<User> listUserToInsert = new List<User>();
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'testFirst', 
                         lastName = 'testLast', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pfAdmin.Id
                        ); 
        
        insert uu;
        
        Integer RandomId2=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName2=orgId+dateString+RandomId2; 
        User uu2=new User(firstname = 'testFirst', 
                          lastName = 'testLast', 
                          email = uniqueName2 + '@test' + orgId + '.org', 
                          Username = uniqueName2 + '@test' + orgId + '.org', 
                          EmailEncodingKey = 'ISO-8859-1', 
                          Alias = uniqueName2.substring(18, 23), 
                          TimeZoneSidKey = 'America/Los_Angeles', 
                          LocaleSidKey = 'en_US', 
                          LanguageLocaleKey = 'en_US', 
                          ProfileId = pfNonAdmin.Id
                         ); 
        
        insert uu2;
        
        Test.startTest();
        Batch023_MEP_FreezeUser bccfb = new Batch023_MEP_FreezeUser();
        Id batchId = Database.executeBatch(bccfb);
        Test.stopTest();
        
        List<UserLogin> listUserLoginFreeze = [
            SELECT Id, IsFrozen, UserId
            FROM UserLogin
            WHERE UserId=:uu2.Id
        ];
        
        System.assertEquals(true, listUserLoginFreeze[0].IsFrozen);
    }
}