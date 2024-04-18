/*
* @date: 02/02/2022
* @ Description : cocher la case a anonymiser sur foyer panéliste et la composition du foyer (contact) et ind pan
* @Auteur : Téoman Sertçelik
* @Scheduler : SCHD020_AnonymisationConfirmee
* @TestClass: Batch020_AnonymisationConfirme_Test
* @Coverage: 91%
History
* <Date of modification>        <Author>            <Description of modification>
*/



public with sharing class Batch020_Eligibilite_Anonymisation implements Database.Batchable<sObject>{

    //@TestVisible private static  Integer yearsDiff ;
    //Added for email notification - START
    public String errorTxt = '';
    public Boolean containsErrors = false;
    //Added for email notification - END

    public Database.QueryLocator start(Database.BatchableContext bC)
    {  
               
        return Database.getQueryLocator([SELECT Id, Membre_du_foyer__c, A_anonymiser__c, Foyer__c, Demande_d_anonymisation__c,Date_d_anonymisation__c, Date_de_descente__c, Date_de_chute__c, Tech_NbAnneesChute__c, Statut_Foyer_paneliste__c, Foyer_Paneliste_ExtId_SIPanel__c, Date_d_integration__c, Date_de_creation__c, RecordTypeId, TECH_DateChuteSup__c, Date_de_signature_de_la_convention__c, Panel_ExtId_SIPanel__c, TECH_NombreAnneeDepuisCreation__c, Referentiel_Panel__r.Name 
        								 FROM Foyer_Paneliste__c 
       								     WHERE (Date_d_anonymisation__c = null AND A_anonymiser__c = false) AND ((Statut_Foyer_paneliste__c =:Label.PAN_Statut_Panel_Chute_definitive AND Tech_NbAnneesChute__c <=3) OR (Date_de_descente__c=null AND TECH_NombreAnneeDepuisCreation__c <= 3))]);
       							
    }

    public void execute(Database.BatchableContext bC, List<Foyer_paneliste__c> listFoyerPanelisteInit)
    {
        System.debug('listFoyerPanelisteInit : ' + listFoyerPanelisteInit);
       
        //Id recordTypeIdPaMeMMAT = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        //Id recordTypeIdAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();

        Set<String> setAccountIds = new Set<String>();
        List<Foyer_Paneliste__c> listFoyerPanToUpdate = new List<Foyer_Paneliste__c>();
        List<Foyer_Paneliste__c> listFoyerPanMAJ = new List<Foyer_Paneliste__c>();
        List<Foyer_Paneliste__c> listFoyerPanMAJF = new List<Foyer_Paneliste__c>();
        Map<String, List<Foyer_Paneliste__c>> mapCompIdToListFoyerPan = new Map<String, List<Foyer_Paneliste__c>>();
        Individu_Paneliste__c indToAnonymize;
        List<Individu_Paneliste__c> listIndivuPanToUpdate; 
        List<Contact> listContactToUpdate = new List<Contact>();
        List<Individu_Paneliste__c> listIndividuPanToUpdate = new List<Individu_Paneliste__c>();
        List<Convention__c> listConvention = new List<Convention__c>();
        
        For(Foyer_paneliste__c foyerPan : listFoyerPanelisteInit){
            setAccountIds.add(foyerPan.Foyer__c);
        }
        
        For(Foyer_Paneliste__c foyerPan : listFoyerPanelisteInit) 
        {
          /*   if(foyerPan.Date_d_integration__c != null) {
                yearsDiff= dt.daysBetween(foyerPan.Date_d_integration__c)/365;
            }
          */
           /*  for(Convention__c cnv : foyerPan.Conventions__r) {
                listConvention.add(cnv);
            } */
            if(foyerPan.Statut_Foyer_paneliste__c == Label.PAN_Statut_Panel_Integre && foyerPan.Foyer_Paneliste_ExtId_SIPanel__c != null ) 
            {
                if(foyerPan.Referentiel_Panel__r.Name == Label.RFP_Nom_MMAT || foyerPan.Referentiel_Panel__r.Name == Label.RFP_Nom_PaME) {
                              //foyerPan.A_anonymiser__c = true;
                              //foyerPan.Demande_d_anonymisation__c= true;    
                            listFoyerPanToUpdate.add(foyerPan);                              
                }
                else if (foyerPan.Referentiel_Panel__r.Name == Label.RFP_Nom_AIP
                          && foyerPan.TECH_NombreAnneeDepuisCreation__c <= 2) {   //yearsDiff <= 2   
                             //foyerPan.A_anonymiser__c = true;
                                //foyerPan.Demande_d_anonymisation__c= true; 
                            listFoyerPanToUpdate.add(foyerPan);
                    }

                    /*else if (foyerPan.Foyer_Paneliste_ExtId_SIPanel__c != null 
                            && foyerPan.TECH_NombreAnneeDepuisCreation__c >= 2) {//yearsDiff >= 2                                 
                             //foyerPan.A_anonymiser__c = true;
                                foyerPan.Demande_d_anonymisation__c= true;
                            listFoyerPanToUpdate.add(foyerPan);
                    }*/

                }
            }        
        
    // MD
    Map<String, List<Foyer_Paneliste__c>> mapFoyerToListFoyerPan = new Map<String, List<Foyer_Paneliste__c>>();
    Map<String, Foyer_Paneliste__c> mapIdToFoyerPan = new Map<String, Foyer_Paneliste__c>();
    Map<String, Foyer_Paneliste__c> mapAccIdFoyerPan = new Map<String, Foyer_Paneliste__c>();
        
      For(Foyer_Paneliste__c foyerPan : listFoyerPanToUpdate) {
          mapIdToFoyerPan.put(foyerPan.Id, foyerPan);
            if(!mapFoyerToListFoyerPan.containsKey(foyerPan.Foyer__c)) { 
              mapFoyerToListFoyerPan.put(foyerPan.Foyer__c, new List<Foyer_Paneliste__c>());
            }
           mapFoyerToListFoyerPan.get(foyerPan.Foyer__c).add(foyerPan);
        }
        
        
    //MD 
    For(string accId : mapFoyerToListFoyerPan.keySet()) {        
            for(Foyer_Paneliste__c foyerPaneliste : mapFoyerToListFoyerPan.get(accId)){
                if(!mapIdToFoyerPan.containsKey(foyerPaneliste.Id) && !mapAccIdFoyerPan.containsKey(foyerPaneliste.Foyer__c)){               
                    mapAccIdFoyerPan.put(foyerPaneliste.Foyer__c,foyerPaneliste);                    
                }
                System.debug('mapAccIdFoyerPan' + mapAccIdFoyerPan);
        
    }
    
}  
      integer i = 0;
      For(string accId : mapFoyerToListFoyerPan.keySet()) {   
             
         If(!mapAccIdFoyerPan.containsKey(accId)){ 
            for(Foyer_Paneliste__c foyerPaneliste : mapFoyerToListFoyerPan.get(accId)){
				foyerPaneliste.Demande_d_anonymisation__c= true;
				i++;
                listFoyerPanMAJ.add(foyerPaneliste);
           }
             
          if(listFoyerPanMAJ.size() > 0 && listFoyerPanMAJ.size() == mapFoyerToListFoyerPan.get(accId).size()){
             System.debug('listFoyerPanMAJ :' +  listFoyerPanMAJ);
             listFoyerPanMAJF.addAll(listFoyerPanMAJ);
             System.debug('listFoyerPanMAJF :' +  listFoyerPanMAJF);
                       
         }
      } 
         }   
      
      If(listFoyerPanMAJF.size() > 0) 
        {
            try {
                update listFoyerPanMAJF;
            }
            catch(exception e){
                errorTxt += 'Erreur durant la mise à jour des foyers: ' + e.getMessage() + '\n';
                containsErrors = true;
            }
        }
       //End 
         /*List<Individu_Paneliste__c> listIndividuPanelistes = [SELECT Id, Composition_du_foyer__c, 
                                                                     Foyer_Paneliste__c, Date_d_anonymisation__c,
                                                                     Foyer_Paneliste__r.Foyer__c, Foyer_Paneliste__r.Name, Foyer_Paneliste__r.Date_d_anonymisation__c, 
                                                                     Foyer_Paneliste__r.A_anonymiser__c, Composition_du_foyer__r.Id, Foyer_Paneliste__r.TECH_DateChuteSup__c
                                                               FROM Individu_Paneliste__c
                                                               WHERE Foyer_Paneliste__r.Foyer__c IN: setAccountIds];*/


      /*  for(Individu_Paneliste__c indu : listIndividuPanelistes)
        {
            if(!mapCompIdToListFoyerPan.containsKey(indu.Composition_du_foyer__r.Id))
            {
                mapCompIdToListFoyerPan.put(indu.Composition_du_foyer__r.Id, new List<Foyer_Paneliste__c>());
            }
            mapCompIdToListFoyerPan.get(indu.Composition_du_foyer__r.Id).add(indu.Foyer_Paneliste__r);
            
            if(indu.Foyer_Paneliste__r.A_anonymiser__c == true)  {
                indu.A_anonymiser__c = true;
                listIndividuPanToUpdate.add(indu);
            }
        }*/
                
        //Ajouté par KHA
        /*Map<String, boolean> mapCompIdToBooleanAllAnonymized = new Map<String, boolean>();
        for(Individu_Paneliste__c indu : listIndividuPanelistes)
        {
            if(!mapCompIdToBooleanAllAnonymized.containsKey(indu.Composition_du_foyer__r.Id))
            {
                mapCompIdToBooleanAllAnonymized.put(indu.Composition_du_foyer__r.Id, true);
            }
            
            if(indu.Foyer_paneliste__r.Date_d_anonymisation__c == null && indu.Foyer_paneliste__r.A_anonymiser__c == false)
            {
                mapCompIdToBooleanAllAnonymized.put(indu.Composition_du_foyer__r.Id, false);
            }
        }*/
       
      /*for(string contId : mapCompIdToBooleanAllAnonymized.keyset())
        {
            if(mapCompIdToBooleanAllAnonymized.get(contId) == true)
            {
                Contact compToAnonymize = new Contact(); 
                compToAnonymize.Id = contId;
                compToAnonymize.A_anonymiser__c = true;
                listContactToUpdate.add(compToAnonymize);
            }
        }*/

    
       

       /* if(listIndividuPanToUpdate.size() > 0 )
        {
            update listIndividuPanToUpdate;
        } 

        if(listContactToUpdate.size() > 0) 
        {
            update listContactToUpdate;
        } */ 
    }

    public void finish(Database.BatchableContext bC)
    {
        //Added for notifications - START
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toMailAddress = System.Label.BatchNotif_B020_ToAddress.split(';');
        
        mail.setToAddresses(toMailAddress);
        mail.setSenderDisplayName(System.Label.BatchNotif_B020_SenderName);
        mail.setSubject(System.Label.BatchNotif_B020_Subject+'-'+date.today().format());
        
        String emailBody = 'L\'exécution du batch Batch020_Eligibilite_Anonymisation s\'est terminée.\n';
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
    }
}