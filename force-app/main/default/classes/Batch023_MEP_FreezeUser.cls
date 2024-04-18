/*
* @author: Bastien PINARD
* @date: 08/03/2023
* @ Description: Ce batch freeze tous les utilisateurs ayant un profil différent d'administrateur système, ce batch doit être lancé par un admin systeme et en francais
* @TestClass: Batch023_MEP_FreezeUser_Test
* @Coverage: 
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* */
global class Batch023_MEP_FreezeUser implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    global List<User> start(Database.BatchableContext bc) {
        List<User> userList = [
            SELECT Id, Name, ProfileId, profile.name
            FROM User 
            WHERE Profile.Name = 'Ambassadeur'
            OR Profile.Name = 'Techs externes'
            OR Profile.Name = 'Hotliner technique'
            OR Profile.Name = 'Pôle PRM contrôle - Offshore'
            OR Profile.Name = 'Pôle PRM contrôle France'
            OR Profile.Name = 'Pôle PRM agenda'
            OR Profile.Name = 'Superviseur PRM'
            OR Profile.Name = 'Pôle logistique'
            OR Profile.Name = 'Pilotage de panel'
            OR Profile.Name = 'Data managers'
            OR Profile.Name = 'Equipe SAV'
            OR Profile.Name = 'Equipe technique'

        ];
        return userList;
    }
    
    global void execute(Database.BatchableContext bc, List<User> scope){
		Map<Id,User> testu = new Map<Id,User>();
        Set<Id> setId = new Set<Id>();
        for(User u : scope){
            	setId.add(u.Id);
            testu.put(u.Id, u);
        }
        
        List<UserLogin> listUserLogin = [
            SELECT Id, IsFrozen, UserId
            FROM UserLogin 
            WHERE UserId =:setId
        ];
        
        for(UserLogin ul : listUserLogin){
            ul.IsFrozen = true;
        }
        update listUserLogin;
    }
    
    global void finish(Database.BatchableContext bc){

    }
    
}