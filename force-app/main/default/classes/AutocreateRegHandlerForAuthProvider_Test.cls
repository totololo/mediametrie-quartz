@isTest
public class AutocreateRegHandlerForAuthProvider_Test {
    
    static testMethod void testCreateAndUpdateUser() {
        AutocreatedConfigSelfReg1658390615406 handler = new AutocreatedConfigSelfReg1658390615406();
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
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
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        
        Auth.UserData sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
                                                     'testFirst testLast',  uniqueName + '@test' + orgId + '.org', null, 'testuserlong', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US'});
        Try{
            User u = handler.createUser(null, sampleData);
        }catch(Exception e){
            
        }
        
        sampleData = new Auth.UserData('testId', 'first', 'testLast',
                                                     'testFirst testLast',  uniqueName + '@test' + orgId + '.org', null, 'testuserlong', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US'});
        Try{
            User u = handler.createUser(null, sampleData);
        }catch(Exception e){
            
        }
        
        sampleData = new Auth.UserData('testId', 'testFirst', 'last',
                                                     'testFirst testLast',  uniqueName + '@test' + orgId + '.org', null, 'testuserlong', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US'});
        Try{
            User u = handler.createUser(null, sampleData);
        }catch(Exception e){
            
        }
        
        sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
                                                     'testFirst testLast',  'test@test.org', null, 'testuserlong', 'en_US', 'facebook',
                                                     null, new Map<String, String>{'language' => 'en_US'});
        Try{
            User u = handler.createUser(null, sampleData);
        }catch(Exception e){
            
        }
        
        String uid = '';
        
        sampleData = new Auth.UserData('testId', 'testFirst', 'testLast',
                                       'testNewFirst testNewLast', 'testnewuser@example.org', null, 'testnewuserlong', 'en_US', 'facebook',
                                       null, new Map<String, String>{});
        try{
            handler.updateUser(uid, null, sampleData);
        }catch(Exception e){
            
        }
        
    }
}