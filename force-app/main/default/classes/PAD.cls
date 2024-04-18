public without sharing class PAD 
{
        public static String bypassTrigger; //List of bypassed triggers
        
        public static final User user;
        
        static {
            
            user = [Select Bypass_triggers__c
                   from User 
                   where Id=:UserInfo.getUserId()];
            bypassTrigger = ';'+ user.Bypass_triggers__c+ ';';        
        }
          
         public static boolean canTrigger(string Name){
            return (bypassTrigger.indexof(';' + Name + ';') == -1);

         }      
        
}