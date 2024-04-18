/*
* @date: 07/07/2021
* Déclencheur à la modification "after"
* Description : -création d'une requête et une commande après modification d'un panel Aip avec un status recruté
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
* <Date of modification>   			<Author>   		 <Description of modification>
*		26/04/2022				Claire VEHRLE			Ajout/Suppression des valeurs du champ Types de panel sur Foyer
*		08/08/2023				Claire VEHRLE			TMASF-412 Création Enregistrement Statut Devices
*/
trigger FoyerPanelisteAfterUpdate on Foyer_paneliste__c (after update) {
    Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
    system.debug('$$$after update');
    
    if(PAD.canTrigger('AP01_FoyerPaneliste')) {
        map<Id, Foyer_paneliste__c> mapIdFoyerPan = new map<Id, Foyer_paneliste__c>([select id , (select Sous_type__c from Requetes__r where Sous_type__c=:Label.CAS_Sous_type_PackInitial)
                                                                                     from Foyer_paneliste__c where id IN :Trigger.new ]);
        List<Foyer_paneliste__c> ListNewPanelisteAIP = new List<Foyer_paneliste__c>();
        Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        List<Foyer_paneliste__c> ListNewPanelisteMediamatPame = new List<Foyer_paneliste__c>();
        
        for(Foyer_paneliste__c Pan :Trigger.new) {
            if(
                Pan.Statut_Foyer_paneliste__c == Label.PAN_Statut_panel 
                && pan.Foyer_equipe__c 
                && Pan.RecordTypeId == recordTypeIdPanelAIP 
                && mapIdFoyerPan.get(Pan.id).Requetes__r.size()==0
                && Trigger.oldMap.get(Pan.id).Date_de_creation__c == null
                && Pan.Date_de_creation__c != null ) {
                    ListNewPanelisteAIP.add(Pan);
                }
            
            if(
                (Pan.Statut_Foyer_paneliste__c == Label.PAN_Statut_panel || Pan.Statut_Foyer_paneliste__c == Label.PAN_Statut_Panel_Equipe) 
                && pan.Foyer_equipe__c 
                && Trigger.oldMap.get(Pan.id).Date_de_creation__c == null 
                && Pan.Date_de_creation__c != null
                && mapIdFoyerPan.get(Pan.id).Requetes__r.size()==0)  {
                    if(Pan.RecordTypeId == recordTypeIdPanelMediamatPame) {
                        ListNewPanelisteMediamatPame.add(Pan);
                    }
                }
        }
        
        if(ListNewPanelisteMediamatPame !=null && ListNewPanelisteMediamatPame.size()>0) {
            AP01_FoyerPaneliste.NouvelleReq(ListNewPanelisteMediamatPame);
        }
        
        if(ListNewPanelisteAIP !=null && ListNewPanelisteAIP.size()>0) {
            AP01_FoyerPaneliste.NouvelleReqAIP(ListNewPanelisteAIP);
        }
    }
    
    if(PAD.canTrigger('AP05_FoyerPaneliste')){
        List<Foyer_paneliste__c> listFoyerPanChuteDef = new list<Foyer_paneliste__c>();
        for(Foyer_paneliste__c Pan :Trigger.new){
            if(Pan.Statut_Foyer_paneliste__c == Label.PAN_Statut_Panel_Chute_definitive 
               && Pan.RecordTypeId == recordTypeIdPanelAIP 
               && Pan.Statut_Audimetrique__c == Label.PAN_Statut_Audimetrique_nonRepondant) {
                   listFoyerPanChuteDef.add(Pan);
               }
        }
        if(listFoyerPanChuteDef !=null && listFoyerPanChuteDef.size()>0) {
            AP05_FoyerPaneliste.MajStatusEquipementPerdu(listFoyerPanChuteDef);
        }
        
    }
    
    // MAK - Envoyer à Mulesoft les foyers panélistes d'un compte à la modification de l'un de ses foyers panélistes
    if(PAD.canTrigger('AP07_FoyerPaneliste')) {        
        
        List<Schema.FieldSetMember> fieldsAvecUserIntegration = Schema.SObjectType.Foyer_paneliste__c.fieldSets.Champs_envoyes_Mulesoft_Par_User_Integra.getFields();        
        List<Schema.FieldSetMember> fieldsSansUserIntegration = Schema.SObjectType.Foyer_paneliste__c.fieldSets.Champs_envoyes_a_Mulesoft.getFields();
        Set<String> foyerPanelisteIdSet = new Set<String>();
        
        for(Foyer_paneliste__c foyerPan: Trigger.new) {
            for(Schema.FieldSetMember foyerPanField : fieldsAvecUserIntegration) {
                if(foyerPan.get(foyerPanField.getFieldPath()) != Trigger.oldMap.get(foyerPan.Id).get(foyerPanField.getFieldPath())
                   && foyerPan.Date_d_anonymisation__c==null) {
                       foyerPanelisteIdSet.add(foyerPan.Id); 
                   }                
            }
            for(Schema.FieldSetMember foyerPanField : fieldsSansUserIntegration) {
                if(foyerPan.get(foyerPanField.getFieldPath()) != Trigger.oldMap.get(foyerPan.Id).get(foyerPanField.getFieldPath())
                   && foyerPan.Date_d_anonymisation__c==null
                   && !Userinfo.getUserName().Contains(Label.User_Technique_Username)) {
                       foyerPanelisteIdSet.add(foyerPan.Id); 
                   }
            }
        }
        
        if(foyerPanelisteIdSet.size() > 0 && foyerPanelisteIdSet!= null){
            AP07_FoyerPaneliste.envoyerFoyerPanDuCompte(foyerPanelisteIdSet);
        }
    }
    
    if(PAD.canTrigger('AP08_FoyerPaneliste')) {
        List<Id> foyerIdList = new List<Id>();
        List<Id> foyerPanelisteIdList = new List<Id>();
        User user = [SELECT Bypass_RDD__c FROM User WHERE Id=:UserInfo.getUserId()];
        for(Integer i = 0; i < Trigger.New.size(); i++) {
            if(Trigger.New[i].Statut_Foyer_Paneliste__c != Trigger.Old[i].Statut_Foyer_Paneliste__c) {
                foyerIdList.add(Trigger.New[i].Foyer__c);
                foyerPanelisteIdList.add(Trigger.New[i].Id);
            }
            
        }
        if(foyerIdList.size()>0 && foyerIdList != null && foyerPanelisteIdList.size()>0 && foyerPanelisteIdList != null ){
            AP08_FoyerPaneliste.foyerAModifier(foyerIdList, foyerPanelisteIdList, false, user.Bypass_RDD__c);
        }
        
    }
    
    if(PAD.canTrigger('AP06_Equipement')) {
        
        List<String> foyerPanSynchroGoogle = new List<String>();
        for (Foyer_paneliste__c Pan :Trigger.new) {
            if(Pan.Identifiant_foyer_pame__c != null && Trigger.oldMap.get(Pan.id).Identifiant_foyer_pame__c == null) {
                foyerPanSynchroGoogle.add(Pan.Id);
            }
        }
        	if (System.IsBatch() == false && System.isFuture() == false){
                
        	AP06_Equipement.sendAssetToMulesoft(foyerPanSynchroGoogle, 'POST');
        	}	
    }
    
    if(PAD.canTrigger('AP10_FoyerPaneliste')) {
        
        Id recordTypeIdFoyerPanPaME =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        List<Foyer_paneliste__c> foyerPanelisteList = new List<Foyer_paneliste__c>();
        
        for(Foyer_paneliste__c Pan :Trigger.new){
            
            if(
                Pan.Identifiant_foyer_pame__c != Trigger.oldMap.get(Pan.id).Identifiant_foyer_pame__c 
                && Trigger.oldMap.get(Pan.id).Identifiant_foyer_pame__c == null
                && Pan.Identifiant_foyer_pame__c != null
                && Pan.RecordTypeId == recordTypeIdFoyerPanPaME
                && Pan.TECH_TypePanel__c == label.RFP_TypePanel_PaME           
            ) {
                foyerPanelisteList.add(Pan);
            }
            
        }
        
        if(foyerPanelisteList.size()>0 && foyerPanelisteList != null){
            AP10_FoyerPaneliste.newIdIndividuPaneliste(foyerPanelisteList);
        }
        
    }
    
    if(PAD.canTrigger('AP07_FoyerPaneliste')) {
        List<Foyer_paneliste__c> listFoyerPanToUpdate = new List<Foyer_Paneliste__c> ();
        List<Individu_Paneliste__c> listIndividuPanToUpdate= new List<Individu_Paneliste__c> ();
        map<Id, Account> mapIdFoyer = new map<Id, Account>();
        
        Set<String> indPanIds = new Set<String>(); 
        Set<String> foyerIds = new Set<String>(); 
        Set<String> foyerPanIds = new Set<String>();
        
        map<Id, Integer> mapFoyerFoyerPanCount = new map<Id, Integer>();
        map<Id, Integer> mapFoyerFoyerPanAnonymCount = new map<Id, Integer>();
        
        Date DATEANONYMIZED = Date.today();
        map<Id, Foyer_paneliste__c> mapIdFoyerPan = new map<Id, Foyer_paneliste__c>([select Id,Tech_FP_Anonym_SIP__c, Name, Date_d_anonymisation__c, A_anonymiser__c
                                                                                     from Foyer_paneliste__c 
                                                                                     where id IN :Trigger.new ]);
        for(Foyer_paneliste__c newPan :Trigger.new){
            Foyer_paneliste__c oldPan= Trigger.oldMap.get(newPan.Id);
            if(newPan.A_anonymiser__c != oldPan.A_anonymiser__c){
                if(newPan.A_anonymiser__c  && !newPan.Tech_FP_Anonym_SIP__c)
                {
                    Foyer_paneliste__c pan=mapIdFoyerPan.get(newPan.Id);
                    pan.Tech_FP_Anonym_SIP__c=True;
                    listFoyerPanToUpdate.add(pan);
                    foyerPanIds.add(pan.Id);
                    
                }
                else if(!newPan.A_anonymiser__c && newPan.Tech_FP_Anonym_SIP__c){
                    Foyer_paneliste__c pan=mapIdFoyerPan.get(newPan.Id);
                    pan.Tech_FP_Anonym_SIP__c=False;
                    listFoyerPanToUpdate.add(pan);
                    foyerPanIds.add(pan.Id);
                }
            }
            
        }
        
        if (listFoyerPanToUpdate.size() > 0) {   
            try{
                update listFoyerPanToUpdate;
            } catch(DmlException e) {
                System.debug('Error While updating FoyerPan' + e.getMessage());
            }
            if(System.isFuture() == true){
                AP07_FoyerPaneliste.envoyerAMulesoft(foyerPanIds);
            }
            
        }
        
    }
        
    if(PAD.canTrigger('AP01_Commande')){
        List<foyer_Paneliste__c> listFoyerPantoUpdate = new List<foyer_Paneliste__c>();
        List<Id> ListFoyerPanId = new List<Id>();        
        
        For(foyer_Paneliste__c foyerPan : Trigger.new){
            if(foyerPan.Date_de_chute__c != trigger.oldMap.get(foyerPan.Id).Date_de_chute__c 
               && trigger.oldMap.get(foyerPan.Id).Date_de_chute__c== null && foyerPan.TECH_TypePanel__c == Label.RFP_TypePanel_AIP){               
                   listFoyerPantoUpdate.add(foyerPan);
                   ListFoyerPanId.add(foyerPan.Id);
               }
        }
        if(listFoyerPantoUpdate.size()>0 && listFoyerPantoUpdate!=null){  // creer commande de chute
            AP01_Commande.creerCommandeChuteFoyerPan(listFoyerPantoUpdate);
        }
        if(ListFoyerPanId.size()>0 && ListFoyerPanId!=null){// chuter paneliste
            // AP04_FoyerPaneliste.FoyerPAnelisteChute(ListFoyerPanId);  
        }
    }
    
    if(PAD.canTrigger('AP11_FoyerPaneliste')) {
        List<Id> foyerIdList = new List<Id>();
        
        for(Foyer_Paneliste__c foyerPan: Trigger.new) {
            if(foyerPan.statut_foyer_paneliste__c == Label.PAN_Statut_Panel && foyerPan.statut_foyer_paneliste__c != trigger.oldMap.get(foyerPan.Id).statut_foyer_paneliste__c) {
                foyerIdList.add(foyerPan.Foyer__c);
            }
            
        }
        if(foyerIdList.size()>0 && foyerIdList!=null){
            AP11_FoyerPaneliste.creationStatutDevice(foyerIdList);
        }
    }
    
    if(PAD.canTrigger('AP12_FoyerPaneliste')) {
        List<String> foyerPanelisteIdList = new List<String>();
        
        for(Foyer_Paneliste__c foyerPan: Trigger.new) {
            if(foyerPan.statut_foyer_paneliste__c == Label.PAN_Statut_Panel && foyerPan.statut_foyer_paneliste__c != trigger.oldMap.get(foyerPan.Id).statut_foyer_paneliste__c) {
                foyerPanelisteIdList.add(foyerPan.Foyer_Paneliste_ExtId_SIPanel__c);
            }
            
        }
        if(foyerPanelisteIdList.size()>0 && foyerPanelisteIdList!=null){
            AP12_FoyerPaneliste.creationFoyerPaneliste(foyerPanelisteIdList);
        }
    }
}