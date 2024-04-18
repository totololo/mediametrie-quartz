/*
* @date: 02/02/2022
* @ Description : Anonymiser les foyer lorsque la case à cocher "Anonymisation confirmée" a été cochée
* @Auteur : Téoman Sertçelik
* @Scheduler : SCHD019_CompositionFoyerAnonymisation
* @TestClass: Batch019_CompositionFoyerAnonymisation
* @Coverage: 100 %
History
* <Date of modification> 		<Author> 			<Description of modification>
*/

public with sharing class Batch019_CompositionFoyerAnonymisation implements Database.Batchable<sObject>, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext bC)
    {
        boolean aAnnonymiser = true;

        String query =
         'SELECT Id, Account.Id, FirstName, LastName, Birthdate, Email, Phone, HomePhone, Profession__c, ' +
         'Domaine_d_activite__c, Autre_activite__c, Date_d_anonymisation__c, A_anonymiser__c,  ' +
              /* '(SELECT Id, Date_d_anonymisation__c, Commentaire__c ' + 
                 'FROM Equipements_du_foyer__r ' +  
                 'WHERE Date_d_anonymisation__c = null), ' + */
                '(SELECT Id, Telephone_fixe__c, SuppliedPhone, ContactPhone, SuppliedEmail, SuppliedName, SuppliedCompany, Description, Date_d_anonymisation__c ' + 
                 'FROM Cases__r ' + 
                 'WHERE Date_d_anonymisation__c = null), ' +
                '(SELECT Id, Date_d_anonymisation__c ' + 
                 'FROM Paneliste__r ' + 
                 'WHERE Date_d_anonymisation__c = null) ' + 
         'FROM Contact ' +
         'WHERE Date_d_anonymisation__c = null ' + 
         'AND A_anonymiser__c = : aAnnonymiser';

        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bC, List<Contact> listContactInit)
    {
        final Date DATETOPASSCONTACT = Date.newInstance(1900, 01, 01);
        Date dateAnonymized = Date.today();
        List<Contact> listContactToUpdate = new List<Contact>();
        List<Equipements_du_foyer__c> listEquipFoyerToUpdate = new List<Equipements_du_foyer__c>();
        List<Equipement_du_foyer_de_l_individu__c> listEquipFoyerIndToUpdate = new List<Equipement_du_foyer_de_l_individu__c>();
        List<Case> listCaseToUpdate = new List<Case>(); 
        List<Individu_Paneliste__c> listIndividuPanToUpdate = new List<Individu_Paneliste__c>();

        //Téoman Sertçelik : added to take in consideration many to many relationship beetwen contact and  Equipements_du_foyer__c
        List<Equipement_du_foyer_de_l_individu__c> listEquipementFoyerInd = [SELECT Id, Composition_du_foyer__c,  Equipement_du_foyer__c//, Date_d_anonymisation__c
                                                                             FROM Equipement_du_foyer_de_l_individu__c
                                                                             WHERE Composition_du_foyer__c IN : listContactInit
                                                                             /*AND Date_d_anonymisation__c = null*/];

     
        for(Contact compFoyer : listContactInit ) {
          		//if(compFoyer.Statut_individu__c)
                //anonymization
                //***contact fields***
                compFoyer.FirstName = 'FirstName' + compFoyer.Account.Id;
                compFoyer.LastName = 'LastName' +  compFoyer.Account.Id;
                compFoyer.Birthdate = DATETOPASSCONTACT;
                compFoyer.Email = '';
                compFoyer.Phone = '';
                compFoyer.HomePhone = '';
                compFoyer.Profession__c = '';
                compFoyer.Domaine_d_activite__c = '';
                compFoyer.Autre_activite__c = '';
                //populate date d'anonymisation
                compFoyer.Date_d_anonymisation__c = dateAnonymized; 
                listContactToUpdate.add(compFoyer);

                //Téoman Sertçelik : added to take in consideration many to many relationship beetwen contact and  Equipements_du_foyer__c
                for(Equipement_du_foyer_de_l_individu__c eqmtFoyerInd : listEquipementFoyerInd) {

                   /*  eqmtFoyerInd.Date_d_anonymisation__c = dateAnonymized;
                    listEquipFoyerIndToUpdate.add(eqmtFoyerInd); */

                  //  if(eqmtFoyerInd.Date_d_anonymisation__c != null) {

                        Equipements_du_foyer__c equipementFoyerToAnonymize = new Equipements_du_foyer__c();

                        equipementFoyerToAnonymize.Id = eqmtFoyerInd.Equipement_du_foyer__c;
                        equipementFoyerToAnonymize.Date_d_anonymisation__c = dateAnonymized;
                        equipementFoyerToAnonymize.Commentaire__c = '';

                        listEquipFoyerToUpdate.add(equipementFoyerToAnonymize);
                   // }
                }
               // for(Equipements_du_foyer__c equipFoyer : compFoyer.Equipements_du_foyer__r){
                 //   equipFoyer.Commentaire__c = '';
                    /*  equipFoyer.Mode_de_communication__c = null;
                    equipFoyer.Modele_liste_limitee__c = null;
                    equipFoyer.Mod_le_de_console_de_jeux__c = null;
                    equipFoyer.Mod_le_de_tablette__c = null;
                    equipFoyer.Modele_de_telephone__c = null;
                    equipFoyer.Mod_le_magn_toscope__c = null; */
                    //populate date d'anonymisation
                   // equipFoyer.Date_d_anonymisation__c = dateAnonymized;
                //    listEquipFoyerToUpdate.add(equipFoyer);
                //}
                for(Case cs : compFoyer.Cases__r){
                    //anonymization
                    cs.Telephone_fixe__c = '';
                    cs.SuppliedPhone = '';
                    //cs.ContactPhone = ''; //field is not writeable
                    cs.SuppliedEmail = '';
                    cs.SuppliedCompany = ''; 
                    cs.SuppliedName = '';
                    cs.Description = '';
                    //populate date d'anonymisation
                    cs.Date_d_anonymisation__c = dateAnonymized;
                    listCaseToUpdate.add(cs);
                }
                for(Individu_Paneliste__c indPan : compFoyer.Paneliste__r) {
                    //LA250123 handeled by condition in batch 020 line 141 / on ne le prend plus en compte sur le bacth 020
                    /*if(compFoyer.Paneliste__r.size()>1)
                    {*/
                        //anonymization
                    //***individu paneliste fields***
                    //TODO : fields to anonymize to specify
                    //populate date d'anonymisation
                    indPan.Date_d_anonymisation__c = dateAnonymized;
                    //LA add fields ton anonymize
                    indPan.Name ='';
                    indPan.ID_Google__c ='';
                    indPan.Lien_meter__c = '';
                    listIndividuPanToUpdate.add(indPan);
                        
                    //}
                    
                    
                    
                }
            
        }

        if(listContactToUpdate.size() > 0)
        {
            update listContactToUpdate;
        }
        if(listEquipFoyerToUpdate.size() > 0)
        {
            update listEquipFoyerToUpdate;
        }
        if (listCaseToUpdate.size() > 0)
        {
            update listCaseToUpdate;
        }
        if (listIndividuPanToUpdate.size() > 0)
        {
            update listIndividuPanToUpdate;
        }
       /*  if(listEquipFoyerIndToUpdate.size()>0) 
        {
            update listEquipFoyerIndToUpdate;
        } */
    }

    public void finish(Database.BatchableContext bC){
        system.debug('Batch019_CompositionFoyerAnonymisation finished');
    }
}