/*
* @date: 23/07/2021
* @ Description : Attacher les fidelisations du foyer a la nouvelle personne de reference du foyer
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* @TestClass: AP04_Foyer_Test
* @Coverage: 90%
 History
* <Date of modification>   	     <Author>    		  <Description of modification>
* 		02/08/2021				Youssef Hamrouni		met à jour l'adresse sur le rdv une fois elle est changé sur le foyer
*/
public class AP04_Foyer {//personne de ref 
    public static void UpdateAddress(list<Account> ListAccUpdated, map<id,Account> MapAllAccount){
        Map < Id,  Account > mapAccount = new Map < Id, Account >();
        List<ServiceAppointment> ServiceAppointmentlist = new List<ServiceAppointment>();
        List<ServiceAppointment> listSaToUpdate = new List<ServiceAppointment>();
        // User U = [select Id, username from User where Id = :UserInfo.getUserId()];
        //	U.Bypass_validation_rules__c=True;
        //   update U;
        
        
        
        for(Account acc:listAccUpdated)
        {
            if(acc.ShippingStreet!= MapAllAccount.get(acc.Id).ShippingStreet ||  acc.ShippingCountry!= MapAllAccount.get(acc.Id).ShippingCountry ||  acc.ShippingCity!= MapAllAccount.get(acc.Id).ShippingCity   ||  acc.ShippingpostalCode!= MapAllAccount.get(acc.Id).ShippingpostalCode|| acc.Adresse_e_mail_principale__c!=MapAllAccount.get(acc.Id).Adresse_e_mail_principale__c || acc.Contact_principal__c!=MapAllAccount.get(acc.Id).Contact_principal__c){
                mapAccount.put(acc.Id, acc);
            }
        }
        if (mapAccount.size()>0){
            ServiceAppointmentlist = [ SELECT Address,contactid, AccountId,mail__c FROM ServiceAppointment WHERE AccountId IN : mapAccount.keySet() and Status !=:label.RDV_Statut_Annule and status !=: label.RDV_Statut_Termine ];
        }
        
        for ( ServiceAppointment sa : ServiceAppointmentlist) {
            sa.street = mapAccount.get(sa.AccountId).ShippingStreet;
            sa.city = mapAccount.get(sa.AccountId).ShippingCity;
            sa.country = mapAccount.get(sa.AccountId).ShippingCountry;
            sa.PostalCode=mapAccount.get(sa.AccountId).ShippingPostalCode;
            sa.mail__c=MapAccount.get(sa.AccountId).Adresse_e_mail_principale__c;
            sa.ContactId=mapAccount.get(sa.AccountId).Contact_principal__c;
            listSaToUpdate.add(sa);// en cas ou on a une condition après la boucle for 
            
        }
        if (ServiceAppointmentlist.size()>0 && ServiceAppointmentlist !=null){
        	update ServiceAppointmentlist;
        }
        // U.Bypass_validation_rules__c=False;
        //  update U;
    }
    
    public static void MajRefFoyer(List<Account> FoyerToUpdate){
        /*
         List<Fidelisation__c> listFidToUpdate = new List<Fidelisation__c>();
        // chercher les fidelisations des foyers 
        List<Fidelisation__c> fidelisationList = new List<Fidelisation__c>();
        fidelisationList = [select id ,foyer__c , Composition_du_foyer__c from Fidelisation__c where foyer__c IN :FoyerToUpdate];
        System.debug('------->fidelisationList : ' + fidelisationList);
        For(Fidelisation__c fdl : fidelisationList){
            For(Account acc :FoyerToUpdate ){
                if(fdl.Foyer__c==acc.id){// si la fidelisation appartient au foyer => update composition du foyer
                    System.debug('------->acc.Personne_de_reference__c : ' + acc.Personne_de_reference__c);
                    fdl.Composition_du_foyer__c=acc.Personne_de_reference__c;
                    listFidToUpdate.add(fdl);
                }
            }
        }
        if(listFidToUpdate!=null && listFidToUpdate.size()>0){
            try{ 
                database.update(listFidToUpdate);
            }Catch(exception ex){
                system.debug('Update fidelisation Exception Error:'+ex.getmessage());
            }
        }
        */
        //optimzed version 
        Map<Id, String> foyerIdToPersonneMap = new Map<Id, String>();
        List<Fidelisation__c> listFidToUpdate = new List<Fidelisation__c>();
        for (Account acc : FoyerToUpdate) {
            foyerIdToPersonneMap.put(acc.Id, acc.Personne_de_reference__c);
        }
        List<Fidelisation__c> fidelisationList = [
            SELECT Id, Foyer__c, Composition_du_foyer__c
            FROM Fidelisation__c
            WHERE Foyer__c IN :foyerIdToPersonneMap.keySet()
        ];
        for (Fidelisation__c fdl : fidelisationList) {
            String personneDeRef = foyerIdToPersonneMap.get(fdl.Foyer__c);
            if (personneDeRef != null) {
                fdl.Composition_du_foyer__c = personneDeRef;
                listFidToUpdate.add(fdl);
            }
        }
        if (!listFidToUpdate.isEmpty()) {
            try {
                update listFidToUpdate;
            } catch (Exception ex) {
                System.debug('Update fidelisation Exception Error: ' + ex.getMessage());
            }
        }
        

	}
}