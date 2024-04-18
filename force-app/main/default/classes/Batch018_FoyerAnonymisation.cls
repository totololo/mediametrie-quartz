/*
* @date: 02/02/2022
* @ Description : Anonymiser les foyer pan et les objets liés lorsque la case à cocher "Anonymisation confirmée" a été cochée et date d'anonymisation non renseignée
* @Auteur : Téoman Sertçelik
* @Scheduler : SCHD018_FoyerPanAnonymisationConfirm
* @TestClass: Batch018_FoyerAnonymisation_Test
* @Coverage: 98%
History
* <Date of modification> 		<Author> 			<Description of modification>
*/

public with sharing class Batch018_FoyerAnonymisation implements Database.Batchable<sObject> {
    
    //Added for email notification - START
    public String errorTxt = '';
    public Boolean containsErrors = false;
    //Added for email notification - END
    public Database.QueryLocator start(Database.BatchableContext bC){
        
        Boolean anonymisation = true; 
        

        String query =
            'SELECT Id, Name, Foyer__c,Demande_d_anonymisation__c, A_anonymiser__c, Date_d_anonymisation__c ' +
            'FROM Foyer_Paneliste__c ' +
            //Mikael
            // 'WHERE A_anonymiser__c =: anonymisation'; //ajout des condition
            'WHERE (A_anonymiser__c =: anonymisation  AND Tech_FP_Anonym_SF__c= False AND Tech_FP_Anonym_SIP__c=TRUE)'+//Mikael
            	'OR (A_anonymiser__c =: anonymisation  AND Date_d_anonymisation__c=null AND Tech_FP_Anonym_SF__c= False)'+//Mikael
                'OR (Demande_d_anonymisation__c =: anonymisation  AND Date_d_anonymisation__c=null)';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bC, List<Foyer_paneliste__c> listFoyerPanelisteInit){
        
        System.debug('MD listFoyerPanelisteInit' + listFoyerPanelisteInit);
        Set<String> setAccountIds = new Set<String>();
        
        for(Foyer_Paneliste__c foyerPan : listFoyerPanelisteInit)
        {
            setAccountIds.add(foyerPan.foyer__c);
        }
        
        System.debug('MD setAccountIds' + setAccountIds);
        
        List<Foyer_Paneliste__c> listFoyerPaneliste = [SELECT Id, Name, Date_d_anonymisation__c, A_anonymiser__c, Foyer__c, Statut_Foyer_paneliste__c, Date_de_chute__c, Foyer__r.Name, Foyer__r.Nom_de_famille__c,
                                                       Foyer__r.ShippingStreet, Foyer__r.Complement_d_adresse__c, Foyer__r.Digicode_Interphone__c,
                                                       Foyer__r.Adresse_e_mail_principale__c, Foyer__r.Numero_de_telephone_fixe__c,
                                                       Foyer__r.Phone, Foyer__r.Creneaux_de_disponibilite__c, Foyer__r.Commentaire__c,
                                                       Foyer__r.Date_d_anonymisation__c, Foyer__r.Id, 
                                                       (SELECT Id, Cause_de_controle__c, Date_d_anonymisation__c FROM Controles__r WHERE Date_d_anonymisation__c = null), // controle
                                                       (SELECT Id, Name, Date_d_entree_de_l_individu__c, Date_d_anonymisation__c FROM Panelistes__r WHERE Date_d_anonymisation__c = null), //ind pan
                                                        //(SELECT Id, Name, Date_d_entree_de_l_individu__c, Date_d_anonymisation__c FROM Panelistes__r), //ind pan Mikael
                                                       (SELECT Id, Commentaire__c, Date_d_anonymisation__c FROM Fidelisations__r WHERE Date_d_anonymisation__c = null), //fidelisation
                                                       (SELECT Id, Description, Remarques__c, Date_d_anonymisation__c FROM Interventions__r WHERE (Date_d_anonymisation__c = null AND Status !=:Label.Intervention_Statut_Terminee)), //workorder
                                                       (SELECT Id, Telephone_fixe__c, SuppliedPhone, ContactPhone,
                                                        SuppliedEmail, SuppliedName, SuppliedCompany, Description, Date_d_anonymisation__c
                                                        FROM Requetes__r WHERE Date_d_anonymisation__c = null), //Case
                                                       (SELECT Id, Adresse_d_expedition__c, Description, Date_d_anonymisation__c FROM Commandes__r WHERE Date_d_anonymisation__c = null), //Order
                                                       (SELECT Id, Commentaire__c, Modele_de_console_de_jeux__c,
                                                        Modele_du_magnetoscope__c, Modele_tv__c, Date_d_anonymisation__c
                                                        FROM Equipements_du_foyer__r WHERE Date_d_anonymisation__c = null ), //Equipement du foyer
                                                       (SELECT Id, Description, Address, Adresse_e_mail__c, Commentaires__c
                                                        FROM Rendez_vous_de_service__r
                                                        WHERE Date_d_anonymisation__c = null ) //Rendez-vous de service
                                                       FROM Foyer_Paneliste__c  // foyer pan
                                                       WHERE foyer__c IN : setAccountIds
                                                       AND Statut_Foyer_paneliste__c =: Label.PAN_Statut_Panel_Chute_definitive //MD
                                                       AND Date_de_chute__c != null];  //MD
                                                           
        
        
        final Date DATETOPASSCONTACT = Date.newInstance(1900, 01, 01);
        //Mikael
        // Date DATEANONYMIZED = Date.today();
        
        List<Foyer_paneliste__c> listFoyerPanToUpdate = new List<Foyer_Paneliste__c> ();
        List<Controle__c> listControleToUpdate = new List<Controle__c> ();
        List<WorkOrder> listWorkOrderToUpdate = new List<WorkOrder> ();
        List<Case> listCaseToUpdate= new List<Case> ();
        List<Fidelisation__c> listFidelisationToUpdate= new List<Fidelisation__c> ();
        List<Individu_Paneliste__c> listIndividuPanToUpdate= new List<Individu_Paneliste__c> ();
        List<Order> listOrderToUpdate= new List<Order> ();
        List<Equipements_du_foyer__c> listEquipFoyerToUpdate= new List<Equipements_du_foyer__c> ();
        List<Account> listFoyerToUpdate= new List<Account> ();
        List<ServiceAppointment> listRdvServToUpdate= new List<ServiceAppointment> ();
        //Account foyerToAnonymize = new Account();
        Set<String> indPanIds = new Set<String>(); 
        Set<String> foyerIds = new Set<String>(); 
        Set<String> foyerPanIds = new Set<String>(); 

        Map<String, List<Account>> mapAccountToUpdate = new Map<String, List<Account>>();
        Map<String, List<Foyer_Paneliste__c>> mapAccIdToListFoyerPaneliste = new Map<String, List<Foyer_Paneliste__c>>();
        Map<String, List<ServiceAppointment>> mapFoyerPanIdToListRdvService = new Map<String, List<ServiceAppointment>>(); 
        Map<String, Foyer_Paneliste__c> mapAccIdFoyerPan = new Map<String, Foyer_Paneliste__c>(); 
       
        for(Foyer_Paneliste__c foyerPan : listFoyerPaneliste)
        {
            if(!mapAccIdToListFoyerPaneliste.containsKey(foyerPan.Foyer__c))
            {
                mapAccIdToListFoyerPaneliste.put(foyerPan.Foyer__c, new List<Foyer_Paneliste__c>());
            }
            
            mapAccIdToListFoyerPaneliste.get(foyerPan.Foyer__c).add(foyerPan);
        }
        
        /* for(ServiceAppointment srvAppt : listRdvService) 
{
if(!mapFoyerPanIdToListRdvService.containsKey(srvAppt.Intervention__r.Foyer_paneliste__c))
{

mapFoyerPanIdToListRdvService.put(srvAppt.Intervention__r.Foyer_paneliste__c, new List<ServiceAppointment>());
}

mapFoyerPanIdToListRdvService.get(srvAppt.Intervention__r.Foyer_paneliste__c).add(srvAppt);
} */
      
    //MD Start
     For(string accId : mapAccIdToListFoyerPaneliste.keySet()) {        
            for(Foyer_Paneliste__c foyerPaneliste : mapAccIdToListFoyerPaneliste.get(accId)){
                if(foyerPaneliste.Statut_Foyer_paneliste__c!=Label.PAN_Statut_Panel_Chute_definitive || foyerPaneliste.Date_de_chute__c == null
                    && !mapAccIdFoyerPan.containsKey(foyerPaneliste.Foyer__c)){               
                    mapAccIdFoyerPan.put(foyerPaneliste.Foyer__c,foyerPaneliste);                    
                }
                System.debug('MD mapAccIdFoyerPan' + mapAccIdFoyerPan);
        
    }
    
} //End
                
        
        Date DATEANONYMIZED;
        integer count;
        for(string accId : mapAccIdToListFoyerPaneliste.keySet())
        {
          If(!mapAccIdFoyerPan.containsKey(accId)){ //MD
            count = 0;
            for(Foyer_Paneliste__c foyerPaneliste : mapAccIdToListFoyerPaneliste.get(accId))
            {
                DATEANONYMIZED=foyerPaneliste.Date_d_anonymisation__c==null?Date.today():foyerPaneliste.Date_d_anonymisation__c;
                if(foyerPaneliste.A_anonymiser__c && foyerPaneliste.Date_d_anonymisation__c == null && foyerPaneliste.Date_de_chute__c != null 
                    && foyerPaneliste.Statut_Foyer_paneliste__c == Label.PAN_Statut_Panel_Chute_definitive)  //MD
                { 
                    count++;
                    System.debug(' MD IN ' +  count);
                    /*  if(foyerPaneliste.Name == foyerPaneliste.Foyer__r.Nom_de_famille__c) {
foyerPaneliste.Name = ''; // to specify 
} */
                    foyerPaneliste.Date_d_anonymisation__c = DATEANONYMIZED;
                    foyerPaneliste.Tech_FP_Anonym_SF__c= True;
                    listFoyerPanToUpdate.add(foyerPaneliste);   
                    foyerPanIds.add(foyerPaneliste.Id); 
                    if(foyerPaneliste.Date_d_anonymisation__c != null) {
                        
                        //objet pas dans les specs
                        for(Controle__c contr : foyerPaneliste.controles__r){
                            //Anonymiser les contrôles
                            contr.Cause_de_controle__c = 'Cause_de_controle__c'; //+ acc.Id;
                            //populate date d'anonymisation
                            contr.Date_d_anonymisation__c = DATEANONYMIZED;
                            listControleToUpdate.add(contr);
                        }
                        
                        for(WorkOrder wrkordr : foyerPaneliste.Interventions__r) {
                            //anonymization
                            wrkOrdr.Description = '';
                            wrkOrdr.Remarques__c ='';
                            //populate date d'anonymisation
                            wrkOrdr.Date_d_anonymisation__c = DATEANONYMIZED;
                            listWorkOrderToUpdate.add(wrkordr);
                            
                        }
                        
                        for(Case cs : foyerPaneliste.Requetes__r){
                            //anonymization
                            cs.Telephone_fixe__c = '';
                            cs.SuppliedPhone = '';
                            //cs.ContactPhone = ''; //field is not writeable
                            cs.SuppliedEmail = '';
                            cs.SuppliedCompany = ''; 
                            cs.SuppliedName = '';
                            cs.Description = '';
                            //populate date d'anonymisation
                            cs.Date_d_anonymisation__c = DATEANONYMIZED;
                            listCaseToUpdate.add(cs);
                            
                        }
                        
                        for(Fidelisation__c fid : foyerPaneliste.Fidelisations__r){
                            //anonymization
                            fid.Commentaire__c ='';
                            //populate date d'anonymisation
                            fid.Date_d_anonymisation__c = DATEANONYMIZED;
                            listFidelisationToUpdate.add(fid);
                        }
                        
                        //dans les specs il a été confondu contact et individu : individu field non spécifié
                       /* for(Individu_Paneliste__c indPan : foyerPaneliste.Panelistes__r) {
                            //anonymization
                            //***individu paneliste fields***
                            //TODO : fields to anonymize to specify
                            //populate date d'anonymisation
                            indPan.Date_d_anonymisation__c = DATEANONYMIZED;
                            indPanIds.add(indPan.Id);
                            listIndividuPanToUpdate.add(indPan);
                        }*/
                        
                        for(Order ordr : foyerPaneliste.Commandes__r){
                            //anonymization
                            ////ordr.Adresse_d_expedition__c = ''; //field is not writeable formula field : on le vide sur le champ parent
                            ordr.Description = '';
                            //populate date d'anonymisation
                            ordr.Date_d_anonymisation__c = DATEANONYMIZED;
                            listOrderToUpdate.add(ordr);
                        }
                        
                        
                        for(Equipements_du_foyer__c equipFoyer : foyerPaneliste.Equipements_du_foyer__r){
                            //anonymization
                            equipFoyer.Commentaire__c = '';
                            /*  
equipFoyer.Modele_liste_limitee__c = null;
equipFoyer.Mod_le_de_console_de_jeux__c = null;
equipFoyer.Mod_le_de_tablette__c = null;
equipFoyer.Modele_de_telephone__c = null;
equipFoyer.Mod_le_magn_toscope__c = null; */
                            //populate date d'anonymisation
                            equipFoyer.Date_d_anonymisation__c = DATEANONYMIZED;
                            listEquipFoyerToUpdate.add(equipFoyer);
                        }
                        for(ServiceAppointment rdv : foyerPaneliste.Rendez_vous_de_service__r ) {
                            //anonymization
                            rdv.Adresse_e_mail__c = '';
                            //rdv.Address = ''; //not writeable 
                            rdv.Description = '';
                            rdv.Commentaires__c = ''; 
                            //populate date d'anonymisation
                            rdv.Date_d_anonymisation__c = DATEANONYMIZED;
                            listRdvServToUpdate.add(rdv);
                        } 
                        
                        /*
if(mapFoyerPanIdToListRdvService.containsKey(foyerPaneliste.Id) ) {
for(ServiceAppointment rdv : mapFoyerPanIdToListRdvService.get(foyerPaneliste.Id)) {
//anonymization
rdv.Adresse_e_mail__c = '';
//rdv.Address = ''; //not writeable 
rdv.Description = '';
rdv.Commentaires__c = ''; 
//populate date d'anonymisation
rdv.Date_d_anonymisation__c = DATEANONYMIZED;
listRdvServToUpdate.add(rdv);
} 

}
*/
                    }
                } 
                else if(foyerPaneliste.Date_d_anonymisation__c != null) {
                    count++;
                }
            }
            
            
            if(count == mapAccIdToListFoyerPaneliste.get(accId).size())  
            { System.debug(' MD count create foyer ' +  count);
                Account foyerToAnonymize = new Account();
                foyerToAnonymize.Id = accId;                
                foyerToAnonymize.Name = 'Foyer Anonymisé'; //MD
                foyerToAnonymize.ShippingStreet = 'ShippingStreet';  //MD
                foyerToAnonymize.Complement_d_adresse__c = '';
                foyerToAnonymize.Digicode_Interphone__c = '';
                foyerToAnonymize.Adresse_e_mail_principale__c = '';
                foyerToAnonymize.Numero_de_telephone_fixe__c = '0123456789'; //change to LABEL
                foyerToAnonymize.Numero_de_portable__c = '';
                foyerToAnonymize.Phone = '';
                foyerToAnonymize.Creneaux_de_disponibilite__c = null;
                foyerToAnonymize.Commentaire__c = '';
                //populate date d'anonymisation
                foyerToAnonymize.Date_d_anonymisation__c = DATEANONYMIZED;
                listFoyerToUpdate.add(foyerToAnonymize);
                foyerIds.add(foyerToAnonymize.Id);
            }
          } //End If  MD
        }
        
        //MD Start
        List<Contact> listContactToUpdate = new List<Contact>();
        List<Contact> listContacts = [SELECT Id, Name, AccountId, A_anonymiser__c
                                      FROM Contact WHERE AccountId IN : foyerIds];
        
        For(Account foyer: listFoyerToUpdate){
            for(Contact contact : listContacts){
                if(contact.AccountId == foyer.Id){
                    contact.A_anonymiser__c = true;
                    listContactToUpdate.add(contact);
                    
                }
                
            }
            System.debug(' MD listContactToUpdate' +  listContactToUpdate);
        }
        //End MD
        
        //update list records section
        if (listFoyerPanToUpdate.size() > 0)
        {
            try{
            update listFoyerPanToUpdate;
            }
            catch(exception e) {
                errorTxt += 'Erreur durant la mise à jour des foyers : ' + e.getMessage() + '\n';
                containsErrors = true;
            }
            // if(System.IsBatch() == true && System.isFuture() == true){
            //     AP07_FoyerPaneliste.envoyerAMulesoftBatch(foyerPanIds);
            // }
            //recupérere id et appeller envoyerAMulesoftBatch
        }
        
         if (listControleToUpdate.size() > 0)
        {
            try{
            	update listControleToUpdate;
            }
            catch(exception e){
                errorTxt += 'Erreur durant la mise à jour des contrôles : ' + e.getMessage() + '\n';
                containsErrors = true;
            }
        }
        
        if (listWorkOrderToUpdate.size() > 0)
        {
            try{
            	update listWorkOrderToUpdate;
            }
            catch (exception e){
                errorTxt += 'Erreur durant la mise à jour des interventions : ' + e.getMessage() + '\n';
                containsErrors = true;
            }
        }
        
        if (listCaseToUpdate.size() > 0)
        {
            try{
                update listCaseToUpdate;
            }
            catch (exception e){
                errorTxt += 'Erreur durant la mise à jour des requetes : ' + e.getMessage() + '\n';
                containsErrors = true;
            }
        }
        
        if (listFidelisationToUpdate.size() > 0)
        {
            try{  
            	update listFidelisationToUpdate;
            }
            catch (exception e){
                errorTxt += 'Erreur durant la mise à jour des fidélisations : ' + e.getMessage() + '\n';
                containsErrors = true;
            }
        }
        
     /*  if (listIndividuPanToUpdate.size() > 0)
        {
            update listIndividuPanToUpdate;
            // if(System.IsBatch() == true && System.isFuture() == true){
            //     AP03_IndividuPaneliste.envoyerAMulesoftUpdateBatch(indPanIds);
            // }
            //recupérere id et appeller envoyerAMulesoftUpdateBatch
        }*/
        
        if (listOrderToUpdate.size() > 0)
        {
            try {
            	update listOrderToUpdate;
            }
            catch (exception e){
                errorTxt += 'Erreur durant la mise à jour des interventions : ' + e.getMessage() + '\n';
                containsErrors = true;
            }
        }
        
        if(listEquipFoyerToUpdate.size() > 0)
        {
            try {
            	update listEquipFoyerToUpdate;
            }catch (exception e){
                errorTxt += 'Erreur durant la mise à jour des equipements : ' + e.getMessage() + '\n';
                containsErrors = true;
            }
        }
        if(listRdvServToUpdate.size() > 0)
        {
            try {
                update listRdvServToUpdate;
            }
            catch (exception e){
                errorTxt += 'Erreur durant la mise à jour des rdv : ' + e.getMessage() + '\n';
                containsErrors = true;
            }
        }
        
        if(listFoyerToUpdate.size()>0){
            try{
            update listFoyerToUpdate;
            }
            catch (exception e){
                errorTxt += 'Erreur durant la mise à jour des foyers : ' + e.getMessage() + '\n';
                containsErrors = true;
            }
            // if(System.IsBatch() == true && System.isFuture() == true){
            //     AP05_Foyer.envoyerAMulesoftBatch(foyerIds);
            // }
            //recupérere id et appeller envoyerAMulesoft
        }
        
         if (listContactToUpdate.size() > 0)
        {
            try{
            	update listContactToUpdate;
            }
            catch (exception e){
                errorTxt += 'Erreur durant la mise à jour des contacts : ' + e.getMessage() + '\n';
                containsErrors = true;
            }
        }
    } 
    
    public void finish(Database.BatchableContext bC){
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B018_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B018_SenderName);
        mail.setSubject(System.Label.BatchNotif_B018_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch018_FoyerAnonymisation s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
            emailBody += errorTxt;
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.';
        }
        mail.setPlainTextBody(emailBody);
        
        if(!Test.isRunningTest()) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        //Added for notifications - END
        system.debug('Batch018_FoyerAnonymisation finished');
    }
}