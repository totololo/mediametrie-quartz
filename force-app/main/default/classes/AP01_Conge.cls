/*
* @author: Maribelle ZARAZIR
* @date: 31/03/2021
* @ Description: Quand un Congé est créé, modifié ou supprimé, il faut vérifier s'il appartient à un Foyer et/ou Individu et lancer leur mise à jour
* @TestClass: AP01_Conge_Test
* @Coverage: 
* History
* <Date of modification>   <Author>    <Description of modification>
*  Aug 2021 				MZ			ticket 272 - envoyer le congé principal
*  Aug 2022					Salah Mansour Akridiss (SMA)			ticket 846 - Ajout de règles de validation sur objet Congés 
*/

public class AP01_Conge {
/*
    public static void sendRelatedObjectToSIPanel(list<Conge__c> listCreatedConge) {
        list<String> listContactIdsToProcess = new list<String>();
        list<String> listAccountsIdsToProcess = new list<String>();
        list<String> listContactExtIdsToProcess = new list<String>();
        list<String> listAccountsExtIdsToProcess = new list<String>();
        
        for(Conge__c congeCree : listCreatedConge) {
            if(congeCree.Conge_de_l_individu__c != null && PAD.canTrigger('AP01_MembreDuFoyer')) {
                listContactIdsToProcess.add(congeCree.Conge_de_l_individu__c);
            } else if(congeCree.Foyer__c != null && PAD.canTrigger('AP02_Foyer')) {
                listAccountsIdsToProcess.add(congeCree.Foyer__c);
            }
            if(listContactIdsToProcess.size() != 0 || listAccountsIdsToProcess.size() != 0) {
                break;
            }
        }
        
        if(listContactIdsToProcess.size() == 1){
            listContactExtIdsToProcess.add([SELECT CON_ExtId_SIPanel__c FROM Contact WHERE Id IN :listContactIdsToProcess LIMIT 1].CON_ExtId_SIPanel__c);
            AP01_MembreDuFoyer.sendUpdatedContactToSiPanel(listContactExtIdsToProcess);
        }
        if(listAccountsIdsToProcess.size() == 1){
            listAccountsExtIdsToProcess.add([SELECT ACC_ExtId_SIPanel__c FROM Account WHERE Id IN :listAccountsIdsToProcess LIMIT 1].ACC_ExtId_SIPanel__c);
            AP02_Foyer.sendAccountToSiPanel(listAccountsExtIdsToProcess);
        }
    }
   */
    
    public static Integer nbrExecutions = 0;
    
    // Méthode modifiée par SMA pour résolution du ticket 846
    public static void congeAnterieurExistant(list<Conge__c> listCreatedConge) {
        System.debug('Congés 1 : ' + nbrExecutions);
        if(nbrExecutions == 0) {
         	nbrExecutions++;
            list<id> listFoyid = new list<id>();
            list<id> listContid = new list<id>();
            for (conge__c con:listCreatedConge){
                listFoyid.add(con.Foyer__c);
            }
            for (conge__c con:listCreatedConge){
                listContid.add(con.Conge_de_l_individu__c);
            }
            
            list<conge__c> listCongesFoyer = [select id, Date_de_debut__c, Date_de_fin__c,Conge_de_l_individu__c from conge__c where Foyer__c =:listFoyid];
            list<conge__c> listCongesContact = [select id, Date_de_debut__c, Date_de_fin__c from conge__c where Conge_de_l_individu__c =:listContid];
            system.debug('test'+listCongesContact.size());
            system.debug('test'+listCongesFoyer.size());
           
        	for (conge__c newConge : listCreatedConge){
                if (newConge.Conge_de_l_individu__c==null){
                    system.debug('sss'+newConge.id);
                for (conge__c existingConge : listCongesFoyer){
                    if (((newConge.Date_de_debut__c >= existingConge.Date_de_debut__c && newConge.Date_de_debut__c <= existingConge.Date_de_fin__c) 
                        || (newConge.Date_de_fin__c >= existingConge.Date_de_debut__c && newConge.Date_de_fin__c <= existingConge.Date_de_fin__c)
                       	|| (newConge.Date_de_debut__c <= existingConge.Date_de_debut__c && newConge.Date_de_fin__c >= existingConge.Date_de_fin__c))&&
                        newConge.id!=existingConge.id && existingConge.Conge_de_l_individu__c==null){
                        newConge.addError('La période choisie chevauche avec des congés existants pour le même foyer!');
                            system.debug('ccc'+existingConge.Id);
                    }
                }
                }
            } 
            for (conge__c newConge : listCreatedConge){
              	if (newConge.Conge_de_l_individu__c!=null){
                for (conge__c existingConge : listCongesContact){
                    if ((newConge.Date_de_debut__c >= existingConge.Date_de_debut__c && newConge.Date_de_debut__c <= existingConge.Date_de_fin__c) 
                        || (newConge.Date_de_fin__c >= existingConge.Date_de_debut__c && newConge.Date_de_fin__c <= existingConge.Date_de_fin__c)
                       	|| (newConge.Date_de_debut__c <= existingConge.Date_de_debut__c && newConge.Date_de_fin__c >= existingConge.Date_de_fin__c)&&
                        newConge.id!=existingConge.id && existingConge.Conge_de_l_individu__c==newConge.Conge_de_l_individu__c){
                        newConge.addError('La période choisie chevauche avec des congés existants pour le même contact!');
                    }
                 }
                }
                
            }
        }
    }
    
    /*public static void sendConge(list<Conge__c> listUptaedConge,map<id,Conge__c> MapAllConge) {
		list<Id> listRelatedAccounts = new List<Id>();
		List <Conge__c > listConge = new list <  Conge__c >();
		list<String> listAccountsIdsToProcess = new list<String>();
        list<String> listAccountsExtIdsToProcess = new list<String>();
        
        for(Conge__c con :listUptaedConge) {
            system.debug('aaa'+listUptaedConge);
            Conge__c oldconge = MapAllConge.get(con.id);
            if (con.isCongePrincipalFoyer__c==oldconge.isCongePrincipalFoyer__c && oldconge.isCongePrincipalFoyer__c==true){
                listConge.add(con);
            }
        }
        system.debug('ccc'+listConge);
        for(Conge__c congeModifie : listConge) {
            if(congeModifie.Foyer__c != null) {
                listAccountsIdsToProcess.add(congeModifie.Foyer__c);
            }
        }
       // List<Account> relatedAccounts = [SELECT Id, ACC_ExtId_SIPanel__c FROM Account WHERE Id IN :listRelatedAccounts];
		
        if(listAccountsIdsToProcess.size() == 1){
            listAccountsExtIdsToProcess.add([SELECT ACC_ExtId_SIPanel__c FROM Account WHERE Id IN :listAccountsIdsToProcess LIMIT 1].ACC_ExtId_SIPanel__c);
            AP02_Foyer.sendAccountToSiPanel(listAccountsExtIdsToProcess);
        }
    }*/
    public static void determineCongePrincipal(list<Conge__c> listCreatedConge) {
        list<Id> listRelatedContacts = new List<Id>();
        list<Id> listRelatedAccounts = new List<Id>();
        
        list<String> listContactExtIdsToProcess = new list<String>();
        list<String> listAccountsExtIdsToProcess = new list<String>();
        
        for(Conge__c congeCree : listCreatedConge) {
            system.debug('foy conge'+congeCree.Foyer__c);
            if(congeCree.Conge_de_l_individu__c != null) {
                listRelatedContacts.add(congeCree.Conge_de_l_individu__c);
                system.debug('liste indiv'+listRelatedContacts);
            } 
        }
        for(Conge__c congeCree : listCreatedConge) {
            if(congeCree.Foyer__c != null) {
                listRelatedAccounts.add(congeCree.Foyer__c);
                system.debug('liste foyer'+listRelatedAccounts);
            }
        }
        
        //Récuperer tous les congés reliés aux mêmes Foyers et Individus
        list<Conge__c> listAllConges = [SELECT Id, Conge_de_l_individu__c, Foyer__c, Date_de_debut__c, Date_de_fin__c, isCongeEnCours__c
                                        FROM Conge__c
                                        WHERE Conge_de_l_individu__c IN :listRelatedContacts OR Foyer__c IN :listRelatedAccounts];
        
        system.debug('listAllConges >> ' + listAllConges);
        
        Map<Id,Map<String,Conge__c>> mapAccountCongesPrincipaux = new Map<Id,Map<String,Conge__c>>();
        Map<Id,Map<String,Conge__c>> mapContatCongesPrincipaux = new Map<Id,Map<String,Conge__c>>();
        Map<String,Conge__c> tempMapConges;
        
        for(Conge__c thisConge : listAllConges) {
            //Congé d'un Individu
            system.debug('test' + thisConge);
            if(thisConge.Conge_de_l_individu__c != null) {
                system.debug('test5'+thisConge.Conge_de_l_individu__c);
                if(!mapContatCongesPrincipaux.containsKey(thisConge.Conge_de_l_individu__c)){
                    tempMapConges = new Map<String,Conge__c>();
                    mapContatCongesPrincipaux.put(thisConge.Conge_de_l_individu__c, tempMapConges);
                    system.debug('test4'+tempMapConges);
                }
                if(thisConge.isCongeEnCours__c)
                {
                    mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).put('Current', thisConge);
                    system.debug('en cours individu'+mapContatCongesPrincipaux);
                    
                }
                else if(thisConge.Date_de_debut__c > system.today())
                {
                    if(!mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).containsKey('Upcoming'))
                    {
                        mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).put('Upcoming', thisConge);
                        
                    }
                    else if(mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).get('Upcoming').Date_de_debut__c > thisConge.Date_de_debut__c)
                    {
                        mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).put('Upcoming', thisConge);
                       
                    }
                }
                else if(thisConge.Date_de_fin__c < system.today())
                    
                	system.debug(thisConge.Date_de_fin__c);
                {
                    if(!mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).containsKey('Old'))
                    {
                        mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).put('Old', thisConge);
                        
                    }
                    else if(mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).get('Old').Date_de_fin__c < thisConge.Date_de_fin__c)
                    {
                        mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).put('Old', thisConge);
                        system.debug(thisConge);
                    }
                }
            }
            //End Congé d'un Individu
            
            //Congé d'un Foyer
            if(thisConge.Foyer__c != null && thisConge.Conge_de_l_individu__c == null) {
                system.debug('test2'+thisConge.Foyer__c);
                if(!mapAccountCongesPrincipaux.containsKey(thisConge.Foyer__c)){
                    tempMapConges = new Map<String,Conge__c>();
                    mapAccountCongesPrincipaux.put(thisConge.Foyer__c, tempMapConges);
                }
                
                if(thisConge.isCongeEnCours__c) 
                {
                    
                    mapAccountCongesPrincipaux.get(thisConge.Foyer__c).put('Current', thisConge);
                    system.debug('en cours foyer'+mapAccountCongesPrincipaux);
                }
                else if(thisConge.Date_de_debut__c > system.today())
                {
                    if(!mapAccountCongesPrincipaux.get(thisConge.Foyer__c).containsKey('Upcoming'))
                    {
                        mapAccountCongesPrincipaux.get(thisConge.Foyer__c).put('Upcoming', thisConge);
                    }
                    else if(mapAccountCongesPrincipaux.get(thisConge.Foyer__c).get('Upcoming').Date_de_debut__c > thisConge.Date_de_debut__c)
                    {
                        mapAccountCongesPrincipaux.get(thisConge.Foyer__c).put('Upcoming', thisConge);
                    }
                }
                else if(thisConge.Date_de_fin__c < system.today())
                    system.debug('r');
                	system.debug(thisConge.Date_de_fin__c);
                {
                    if(!mapAccountCongesPrincipaux.get(thisConge.Foyer__c).containsKey('Old'))
                    {
                        mapAccountCongesPrincipaux.get(thisConge.Foyer__c).put('Old', thisConge);
                    }
                    else if(mapAccountCongesPrincipaux.get(thisConge.Foyer__c).get('Old').Date_de_fin__c < thisConge.Date_de_fin__c)
                    {
                        mapAccountCongesPrincipaux.get(thisConge.Foyer__c).put('Old', thisConge);
                    }
                }
            }
            //End Congé d'un Foyer
        }
        
        List<Contact> relatedContacts = [SELECT Id, CON_ExtId_SIPanel__c FROM Contact WHERE Id IN :listRelatedContacts];
        List<Account> relatedAccounts = [SELECT Id, ACC_ExtId_SIPanel__c FROM Account WHERE Id IN :listRelatedAccounts];
        system.debug('liste foyer'+listRelatedAccounts);
        system.debug('foyer'+relatedAccounts);
        for(Contact thisContact : relatedContacts) {
            if(mapContatCongesPrincipaux.containsKey(thisContact.Id))
            {
                if(mapContatCongesPrincipaux.get(thisContact.Id).containsKey('Current'))
                {
                    thisContact.TECH_CongePrincipal__c = mapContatCongesPrincipaux.get(thisContact.Id).get('Current').Id;
                    system.debug('princip indiv'+thisContact.TECH_CongePrincipal__c);
                }
                else if(mapContatCongesPrincipaux.get(thisContact.Id).containsKey('Upcoming'))
                {
                    thisContact.TECH_CongePrincipal__c = mapContatCongesPrincipaux.get(thisContact.Id).get('Upcoming').Id;
                }
                else if(mapContatCongesPrincipaux.get(thisContact.Id).containsKey('Old'))
                {
                    thisContact.TECH_CongePrincipal__c = mapContatCongesPrincipaux.get(thisContact.Id).get('Old').Id;
                }
                listContactExtIdsToProcess.add(thisContact.CON_ExtId_SIPanel__c);
            }
        }
        
        for(Account thisAccount : relatedAccounts) {
            if(mapAccountCongesPrincipaux.containsKey(thisAccount.Id))
            {
                if(mapAccountCongesPrincipaux.get(thisAccount.Id).containsKey('Current'))
                {
                    thisAccount.TECH_CongePrincipal__c = mapAccountCongesPrincipaux.get(thisAccount.Id).get('Current').Id;
                     system.debug('princip foyer'+thisAccount.TECH_CongePrincipal__c);

                }
                else if(mapAccountCongesPrincipaux.get(thisAccount.Id).containsKey('Upcoming'))
                {
                    thisAccount.TECH_CongePrincipal__c = mapAccountCongesPrincipaux.get(thisAccount.Id).get('Upcoming').Id;
                }
                else if(mapAccountCongesPrincipaux.get(thisAccount.Id).containsKey('Old'))
                {
                    thisAccount.TECH_CongePrincipal__c = mapAccountCongesPrincipaux.get(thisAccount.Id).get('Old').Id;
                }
                listAccountsExtIdsToProcess.add(thisAccount.ACC_ExtId_SIPanel__c);
            }
                    //system.debug('mapconge'+mapAccountCongesPrincipaux.get(thisAccount.Id).get('Current').Id);

        }
        //Mettre a jour les foyers et les individus
        if(relatedContacts.size() > 0) {
            try{
                update relatedContacts;
            } catch(Exception e){
                system.debug(e);
            }
        }
        
        if(relatedAccounts.size() > 0) {
            try{
                update relatedAccounts;
            } catch(Exception e){
                system.debug(e);
            }
        }
        
        
        
        //send to SI Panels
        //le cas de modif d'un congé qui est déjà principale
        
        
        
    }

    
    
    /*public static list<string> determineCongePrincipalAccountBatch(list<Conge__c> listCreatedConge) {

        list<Id> listRelatedAccounts = new List<Id>();
        list<String> listAccountsExtIdsToProcess = new list<String>();
        
       
        for(Conge__c congeCree : listCreatedConge) {
            if(congeCree.Foyer__c != null) {
                listRelatedAccounts.add(congeCree.Foyer__c);
                system.debug('liste foyer'+listRelatedAccounts);
            }
        }
        
        //Récuperer tous les congés reliés aux mêmes Foyers et Individus
        list<Conge__c> listAllConges = [SELECT Id, Conge_de_l_individu__c, Foyer__c, Date_de_debut__c, Date_de_fin__c, isCongeEnCours__c
                                        FROM Conge__c
                                        WHERE  Foyer__c IN :listRelatedAccounts];
        
        system.debug('listAllConges >> ' + listAllConges);
        
        Map<Id,Map<String,Conge__c>> mapAccountCongesPrincipaux = new Map<Id,Map<String,Conge__c>>();
        Map<String,Conge__c> tempMapConges;
        
        for(Conge__c thisConge : listAllConges) {
            
            
            //Congé d'un Foyer
            if(thisConge.Foyer__c != null && thisConge.Conge_de_l_individu__c == null) {
                system.debug('test2'+thisConge.Foyer__c);
                if(!mapAccountCongesPrincipaux.containsKey(thisConge.Foyer__c)){
                    tempMapConges = new Map<String,Conge__c>();
                    mapAccountCongesPrincipaux.put(thisConge.Foyer__c, tempMapConges);
                }
                
                if(thisConge.isCongeEnCours__c) 
                {
                    
                    mapAccountCongesPrincipaux.get(thisConge.Foyer__c).put('Current', thisConge);
                    system.debug('en cours foyer'+mapAccountCongesPrincipaux);
                }
                else if(thisConge.Date_de_debut__c > system.today())
                {
                    if(!mapAccountCongesPrincipaux.get(thisConge.Foyer__c).containsKey('Upcoming'))
                    {
                        mapAccountCongesPrincipaux.get(thisConge.Foyer__c).put('Upcoming', thisConge);
                    }
                    else if(mapAccountCongesPrincipaux.get(thisConge.Foyer__c).get('Upcoming').Date_de_debut__c > thisConge.Date_de_debut__c)
                    {
                        mapAccountCongesPrincipaux.get(thisConge.Foyer__c).put('Upcoming', thisConge);
                    }
                }
                else if(thisConge.Date_de_fin__c < system.today())
                    system.debug('r');
                	system.debug(thisConge.Date_de_fin__c);
                {
                    if(!mapAccountCongesPrincipaux.get(thisConge.Foyer__c).containsKey('Old'))
                    {
                        mapAccountCongesPrincipaux.get(thisConge.Foyer__c).put('Old', thisConge);
                    }
                    else if(mapAccountCongesPrincipaux.get(thisConge.Foyer__c).get('Old').Date_de_fin__c < thisConge.Date_de_fin__c)
                    {
                        mapAccountCongesPrincipaux.get(thisConge.Foyer__c).put('Old', thisConge);
                    }
                }
            }
            //End Congé d'un Foyer
        }
        
        List<Account> relatedAccounts = [SELECT Id, ACC_ExtId_SIPanel__c FROM Account WHERE Id IN :listRelatedAccounts];
        system.debug('liste foyer'+listRelatedAccounts);
        system.debug('foyer'+relatedAccounts);
               
        for(Account thisAccount : relatedAccounts) {
            if(mapAccountCongesPrincipaux.containsKey(thisAccount.Id))
            {
                if(mapAccountCongesPrincipaux.get(thisAccount.Id).containsKey('Current'))
                {
                    thisAccount.TECH_CongePrincipal__c = mapAccountCongesPrincipaux.get(thisAccount.Id).get('Current').Id;
                     system.debug('princip foyer'+thisAccount.TECH_CongePrincipal__c);

                }
                else if(mapAccountCongesPrincipaux.get(thisAccount.Id).containsKey('Upcoming'))
                {
                    thisAccount.TECH_CongePrincipal__c = mapAccountCongesPrincipaux.get(thisAccount.Id).get('Upcoming').Id;
                }
                else if(mapAccountCongesPrincipaux.get(thisAccount.Id).containsKey('Old'))
                {
                    thisAccount.TECH_CongePrincipal__c = mapAccountCongesPrincipaux.get(thisAccount.Id).get('Old').Id;
                }
                listAccountsExtIdsToProcess.add(thisAccount.ACC_ExtId_SIPanel__c);
            }
                    //system.debug('mapconge'+mapAccountCongesPrincipaux.get(thisAccount.Id).get('Current').Id);

        }
        //Mettre a jour les foyers 
        
        
        if(relatedAccounts.size() > 0) {
            try{
                update relatedAccounts;
            } catch(Exception e){
                system.debug(e);
            }
        }
       return listAccountsExtIdsToProcess;

    }*/
    
       
    
    /*public static List<String> determineCongePrincipalContactBatch2(list<Conge__c> listCreatedConge) {
        list<Id> listRelatedContacts = new List<Id>();
        list<String> listContactExtIdsToProcess = new list<String>();
       
        for(Conge__c congeCree : listCreatedConge) {
            if(congeCree.Conge_de_l_individu__c != null) {
                listRelatedContacts.add(congeCree.Conge_de_l_individu__c);
            
        }
        }
        system.debug('listrelatedcon'+listRelatedContacts);
        //Récuperer tous les congés reliés aux mêmes Foyers et Individus
        list<Conge__c> listAllConges = [SELECT Id, Conge_de_l_individu__c, Foyer__c, Date_de_debut__c, Date_de_fin__c, isCongeEnCours__c
                                        FROM Conge__c
                                        WHERE Conge_de_l_individu__c IN :listRelatedContacts ];
        
        system.debug('listAllConges >> ' + listAllConges);
        
        Map<Id,Map<String,Conge__c>> mapAccountCongesPrincipaux = new Map<Id,Map<String,Conge__c>>();
        Map<Id,Map<String,Conge__c>> mapContatCongesPrincipaux = new Map<Id,Map<String,Conge__c>>();
        Map<String,Conge__c> tempMapConges;
        
        for(Conge__c thisConge : listAllConges) {
            //Congé d'un Individu
            if(thisConge.Conge_de_l_individu__c != null) {
                if(!mapContatCongesPrincipaux.containsKey(thisConge.Conge_de_l_individu__c)){
                    tempMapConges = new Map<String,Conge__c>();
                    mapContatCongesPrincipaux.put(thisConge.Conge_de_l_individu__c, tempMapConges);
                }
                if(thisConge.isCongeEnCours__c)
                {
                    mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).put('Current', thisConge);
                    system.debug(thisConge);
                }
                else if(thisConge.Date_de_debut__c > system.today())
                {
                    if(!mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).containsKey('Upcoming'))
                    {
                        mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).put('Upcoming', thisConge);
                        system.debug(thisConge);
                    }
                    else if(mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).get('Upcoming').Date_de_debut__c > thisConge.Date_de_debut__c)
                    {
                        mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).put('Upcoming', thisConge);
                        system.debug(thisConge);
                    }
                }
                else if(thisConge.Date_de_fin__c < system.today())
                    system.debug('r');
                	system.debug(thisConge.Date_de_fin__c);
                {
                    if(!mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).containsKey('Old'))
                    {
                        mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).put('Old', thisConge);
                        system.debug(thisConge);
                    }
                    else if(mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).get('Old').Date_de_fin__c < thisConge.Date_de_fin__c)
                    {
                        mapContatCongesPrincipaux.get(thisConge.Conge_de_l_individu__c).put('Old', thisConge);
                        system.debug(thisConge);
                    }
                }
            }
            //End Congé d'un Individu
            
           
        }
        
        List<Contact> relatedContacts = [SELECT Id, CON_ExtId_SIPanel__c FROM Contact WHERE Id IN :listRelatedContacts];
       
           
        for(Contact thisContact : relatedContacts) {
            if(mapContatCongesPrincipaux.containsKey(thisContact.Id))
            {
                if(mapContatCongesPrincipaux.get(thisContact.Id).containsKey('Current'))
                {
                    thisContact.TECH_CongePrincipal__c = mapContatCongesPrincipaux.get(thisContact.Id).get('Current').Id;
                }
                else if(mapContatCongesPrincipaux.get(thisContact.Id).containsKey('Upcoming'))
                {
                    thisContact.TECH_CongePrincipal__c = mapContatCongesPrincipaux.get(thisContact.Id).get('Upcoming').Id;
                }
                else if(mapContatCongesPrincipaux.get(thisContact.Id).containsKey('Old'))
                {
                    thisContact.TECH_CongePrincipal__c = mapContatCongesPrincipaux.get(thisContact.Id).get('Old').Id;
                }
                listContactExtIdsToProcess.add(thisContact.CON_ExtId_SIPanel__c);
            }
            
        }
        
        system.debug('contact test'+relatedContacts);
        //send to SI Panels
          if(relatedContacts.size() > 0) {
            try{
                system.debug('test');
                for(Contact thisContact : relatedContacts) {
                    system.debug('conge princip'+ thisContact.TECH_CongePrincipal__c);
                }
              	update relatedContacts;
                
            list<Contact>  c=[select id,TECH_CongePrincipal__c from contact where id='0031j000012ZtYiAAK'];
                for (Contact cont: c){
                    system.debug('verification conge'+cont.TECH_CongePrincipal__c);
                }
                
            } catch(Exception e){
                system.debug(e);
            }
        }
      
         return listContactExtIdsToProcess;
    }*/

    
}