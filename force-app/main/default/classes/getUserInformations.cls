public with sharing class getUserInformations {
    @AuraEnabled
    public static onLoadWrapper getInformations() {
        onLoadWrapper onLoadWrapper = new onLoadWrapper();
        List<ContactFormulaire.wrapperType> ChannelPrivilegeList = ContactFormulaire.getPicklistValues(Contact.Canal_privilegie__c);
        onLoadWrapper.ChannelPrivilegeList = ChannelPrivilegeList;
        
        User user =  [SELECT Id, Name, Email, PostalCode, Numero_paneliste__c, Solde_de_point__c, CompanyName, Title, MobilePhone, Acces_Replanification__c,
                      Contact.Account.ShippingAddress, Autoriser_Intervention__c, Provisioning_IAM__c, Tech_CanalPrivilegie__c,ContactId,
                      Contact.Birthdate, Contact.Account.Personne_de_reference__r.Name, Contact.Age__c, Contact.Email, Contact.MobilePhone
                      FROM User
                      WHERE Id=:UserInfo.getUserId()];
        
        
        onLoadWrapper.utilisateur = user;
        System.debug('user.Contact.Age__c ' + user.Contact.Age__c);
        if(user.Contact.Age__c < 18){
           onLoadWrapper.personneDeReference = user.Contact.Account.Personne_de_reference__r.Name; 
        }
        List<Individu_Paneliste__c> individuPan = [SELECT Id, Composition_du_foyer__r.Solde_de_points__c, Foyer_paneliste__r.Name, Foyer_paneliste__r.Solde_de_points_fid__c
                                                   FROM Individu_Paneliste__c 
                                                   WHERE Composition_du_foyer__c = :user.ContactId];
        if(individuPan.size() > 0){
            onLoadWrapper.utilisateur.Solde_de_point__c = String.valueOf(individuPan[0].Foyer_paneliste__r.Solde_de_points_fid__c);
            onLoadWrapper.utilisateur.Numero_paneliste__c = individuPan[0].Foyer_paneliste__r.Name;
            
        }
        return onLoadWrapper;
    }
    
    public static Integer FindAge(Date birthDate)
    {
        Integer days = birthDate.daysBetween(Date.Today());
        Integer age = Integer.valueOf(days/365);
        return age;
    }
    
    @AuraEnabled
    public static String updateUserInformations(User userToUpdate) {
        String message;
        User currentUser = [SELECT Id, ContactId
                            FROM User 
                            WHERE Id=:UserInfo.getUserId()];
        
        currentUser.Email = userToUpdate.Email;
        currentUser.MobilePhone = userToUpdate.MobilePhone;
        System.debug('bastien updateUserInformations currentUser : ' + currentUser);
        try {
            update currentUser;
            message = 'User Updated';
            
            if(String.isNotBlank(currentUser.ContactId)){
                Contact contactToUpdate = [SELECT Id, MobilePhone, Email
                                           FROM Contact 
                                           WHERE Id = :currentUser.ContactId ];
                contactToUpdate.Canal_privilegie__c = userToUpdate.Tech_CanalPrivilegie__c;
                contactToUpdate.MobilePhone = userToUpdate.MobilePhone;
                contactToUpdate.Email = userToUpdate.Email;
                try {
                    update contactToUpdate;
                    message += ', Contact Updated';
                            System.debug('bastien updateUserInformations currentUser : ' + currentUser);

                } catch(DmlException e) {
                    System.debug(', The following exception has occurred on Contact Update: ' + e.getMessage());
                    message += ', The following exception has occurred on Contact Update: ' + e.getMessage();
                }
            }
            
        } catch(DmlException e) {
            System.debug('The following exception has occurred on User Update: ' + e.getMessage());
            message = 'The following exception has occurred on User Update: ' + e.getMessage();
        }
        
        System.debug('message ' + message);
        return message;
    }
    
    /*WRAPPERS*/
    public class onLoadWrapper {
        public onLoadWrapper(){
            this.utilisateur = new User();
            this.ChannelPrivilegeList = new List<ContactFormulaire.wrapperType>();
            this.personneDeReference = '';
        }
        @AuraEnabled
        public User utilisateur;
        @AuraEnabled
        public List<ContactFormulaire.wrapperType> ChannelPrivilegeList;
        @AuraEnabled
        public String personneDeReference;
    }
}