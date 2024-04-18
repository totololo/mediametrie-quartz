/*
* Déclencheur à la création "after", de la classe AP01_Requete
* @version 1.00   13/10/2020
* @Auteur JSA EI
* History
* Date of modification :20/07/2021   Author :Ayoub GHAMMAZ    
    Description of modification: supprimer l'appel a la base de donnee dans une boucle for et la remplacer par le code allant de la ligne 18 a 27
                                 creer une commande si la requete est de type Recrute & sous type PackInitial
* <Date of modification>  	<Author>    		<Description of modification>
*	08/03/2022			 	Ayoub Ghammaz		appeller la methode X de la classe AP02_Requete 
*/
trigger RequeteAfterInsert on Case (after insert) {
    if(PAD.canTrigger('AP01_Requete')) {
        list<Case> ListCases = new list<Case>();
        Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        list<Case> ListCasesMM = new list<Case>();
         list<Case> ListCases2 = new list<Case>();
        
        list<String> listPanelsIds = new list<String>();
        
        for(case newCase : Trigger.new) {
            if(newCase.Foyer_paneliste__c != Null) {
                listPanelsIds.add(newCase.Foyer_paneliste__c);
            }
            if (newCase.Origin==Label.CAS_Origine_Email && newCase.AccountId==null && newCase.contactid==null ){
            	ListCases2.add(newCase);
            }
        }
        
        	if(ListCases2!=null && ListCases2.size()>0)
        {
            
           	AP01_Requete.associerCaseContact(ListCases2); 
            
        }
            
        
        	
        
        
        Map<ID,Foyer_paneliste__c> MaptPanels = new Map<ID,Foyer_paneliste__c>([Select id, RecordTypeId from Foyer_paneliste__c
                                    where id IN: listPanelsIds and RecordTypeId=:recordTypeIdPanelMediamatPame]);
        System.debug('map->'+MaptPanels);
        for(Case cs:trigger.new) { 
            //Id reqIdMM = [select recordTypeId from Panel__c where id=:cs.Paneliste__c].RecordTypeId;
            //reqIdMM==recordTypeIdPanelMediamatPame &&
            if( MaptPanels.containsKey(cs.Foyer_paneliste__c) && cs.description==Label.CASE_Description_InstallationNouveauFoyer && cs.Origin==Label.CAS_Origine_NouveauFoyer) {
                //ListCases.add(cs);
                    ListCasesMM.add(cs);
            }
        }
        if(ListCasesMM!=null && ListCasesMM.size()>0) {
            AP01_Requete.NouvelleIntervention(ListCasesMM);            
        }
    }
    
    if(PAD.canTrigger('AP01_Commande')){
        
        System.debug('***AP01_Commande : ');
        List<Case> requeteToInsertPackInitial= new List<Case>();
        List<Case> requeteToUpdateChute= new List<Case>();
        List<Case> requeteInfoList = new List<Case>();
        List<Id> caseIdList = new List<Id>();
        for(Case cs : Trigger.new){
            System.debug('***cs : ' + cs);
            if(cs.Type== Label.CAS_Type_Recrute 
               && (cs.Sous_type__c == Label.CAS_Sous_type_PackInitial
                   || cs.Sous_type__c == Label.CAS_Sous_type_PackInitial_SetMeter
                   || cs.Sous_type__c == Label.CAS_Sous_type_PackInitial_ROAv3_Setmeter
                   || cs.Sous_type__c == Label.CAS_Sous_type_PackInitial_ROAv3)){
                requeteToInsertPackInitial.add(cs);
            }
            caseIdList.add(cs.Id);
        }
        System.debug('***RequeteAfterInsert requeteToInsertPackInitial : ' + requeteToInsertPackInitial);
        requeteInfoList = [SELECT Id, AccountId, Foyer_paneliste__c,Foyer_paneliste__r.Date_de_chute__c, Chute_confirmee__c, Type 
                           FROM Case 
                           WHERE Id IN :caseIdList 
                           AND Foyer_paneliste__r.referentiel_panel__r.type_de_panel__c = :Label.RFP_TypePanel_AIP];
       /* for (Case cs:requeteInfoList) {
            if(cs.Chute_confirmee__c && cs.Type==Label.Cas_Type_DemandeChute){// si le chute est definitive => creer une commande de chute et chuter le foyer paneliste
                requeteToUpdateChute.add(cs);
            }
        }*/
        
        
        if(requeteToInsertPackInitial.size()>0 && requeteToInsertPackInitial!=null){

            AP01_Commande.creerCommandePackInitial(requeteToInsertPackInitial);  
        }
        
       /* if(requeteToUpdateChute.size()>0 && requeteToUpdateChute!=null){// creer commande de chute
            AP01_Commande.creerCommandeChute(requeteToUpdateChute);
        }*/
        
         
    } 
    
    if(PAD.canTrigger('AP04_FoyerPaneliste')){
        List<Id> ListFoyerPanId = new List<Id>();
        
        for(Case cs : Trigger.new){
            if(cs.Chute_confirmee__c && cs.Type==Label.Cas_Type_DemandeChute){
                ListFoyerPanId.add(cs.Foyer_paneliste__c);
            }
        }
        if(ListFoyerPanId.size()>0 && ListFoyerPanId!=null){// chuter paneliste
            system.debug('$$$ in requeteAfterUpdate FoyerPAnelisteChute');
            //AP04_FoyerPaneliste.FoyerPAnelisteChute(ListFoyerPanId);  
        }
    }
    // modification du 08/03/2022 : ghammaz : debut
    if(PAD.canTrigger('AP02_Requete')){
        AP02_Requete.attacheARequetePrincipale(Trigger.New);
    }
    //fin
}