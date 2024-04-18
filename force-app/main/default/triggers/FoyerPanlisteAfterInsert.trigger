/*
* Déclencheur à la création "after", de la classe AP01_Panel
* @version 1.00   
* @Auteur Khaled Hammoudeh EIT
* <Date of modification>   			<Author>   		 <Description of modification>
*		26/04/2022				Claire VEHRLE			Ajout/Suppression des valeurs du champ Types de panel sur Foyer
*/
trigger FoyerPanlisteAfterInsert on Foyer_paneliste__c (after insert) {
    /*if(PAD.canTrigger('AP01_FoyerPaneliste'))
    {
                    System.debug('$$$ FoyerPanlisteAfterInsert AP01_FoyerPaneliste');

        Id recordTypeIdPanelMediamatPame =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_mediamatpame).getRecordTypeId();
        //Id recordTypeIdPanelAIP =Schema.SObjectType.Foyer_paneliste__c.getRecordTypeInfosByName().get(label.PAN_recordType_AIP).getRecordTypeId();
                    System.debug('$$$recordTypeIdPanelMediamatPame : ' + recordTypeIdPanelMediamatPame);
                    //System.debug('$$$ recordTypeIdPanelAIP : ' + recordTypeIdPanelAIP);

        
        List<Foyer_paneliste__c> ListNewPanelisteMediamatPame = new List<Foyer_paneliste__c>();
        //List<Foyer_paneliste__c> ListNewPanelisteAIP = new List<Foyer_paneliste__c>();

        for(Foyer_paneliste__c Pan :Trigger.new)
        {
                                System.debug('$$$AP01_FoyerPaneliste Pan : ' + Pan);
                                System.debug('$$$AP01_FoyerPaneliste Pan.Statut_Foyer_paneliste__c : ' + Pan.Statut_Foyer_paneliste__c);
                                System.debug('$$$AP01_FoyerPaneliste Label.PAN_Statut_panel : ' + Label.PAN_Statut_panel);
                                System.debug('$$$AP01_FoyerPaneliste Label.PAN_Statut_Panel_Equipe : ' + Label.PAN_Statut_Panel_Equipe);
                                System.debug('$$$AP01_FoyerPaneliste pan.Foyer_equipe__c : ' + pan.Foyer_equipe__c);

            if((Pan.Statut_Foyer_paneliste__c == Label.PAN_Statut_panel || Pan.Statut_Foyer_paneliste__c == Label.PAN_Statut_Panel_Equipe) && pan.Foyer_equipe__c)  
            {
                                                System.debug('$$$AP01_FoyerPaneliste Pan.RecordTypeId : ' + Pan.RecordTypeId);

                if(Pan.RecordTypeId == recordTypeIdPanelMediamatPame)
                {
                    System.debug('mm -'+Pan);
                    ListNewPanelisteMediamatPame.add(Pan);
                }
                /*else if(Pan.RecordTypeId == recordTypeIdPanelAIP)
                {
                    ListNewPanelisteAIP.add(Pan);
                }*/
            /*}
        }
        if(ListNewPanelisteMediamatPame !=null && ListNewPanelisteMediamatPame.size()>0)
        {
            System.debug('mm -');
                                                System.debug('$$$AP01_FoyerPaneliste ListNewPanelisteMediamatPame : ' + ListNewPanelisteMediamatPame);
            AP01_FoyerPaneliste.NouvelleReq(ListNewPanelisteMediamatPame);
        }*/
        
        /*if(ListNewPanelisteAIP !=null && ListNewPanelisteAIP.size()>0)
        {
            AP01_FoyerPaneliste.NouvelleReqAIP(ListNewPanelisteAIP);
        }*/
    /*}*/
    
    if(PAD.canTrigger('AP08_FoyerPaneliste')) {
        List<Id> foyerIdList = new List<Id>();
        List<Id> foyerPanelisteIdList = new List<Id>();
        User user = [SELECT Bypass_RDD__c FROM User WHERE Id=:UserInfo.getUserId()];
        for(foyer_Paneliste__c foyerpaneliste: Trigger.New) {
            foyerIdList.add(foyerpaneliste.Foyer__c);
            foyerPanelisteIdList.add(foyerpaneliste.Id);
        }
        
        AP08_FoyerPaneliste.foyerAModifierInsert(foyerIdList, foyerPanelisteIdList, false, user.ByPass_RDD__c);
    }
    
    //FPan
    if(PAD.canTrigger('AP01_Commande')){
        List<Id> foyerPanelisteIdList = new List<Id>();
        List<foyer_Paneliste__c> listFoyerPan = new List<foyer_Paneliste__c>();
        List<foyer_Paneliste__c> listFoyerPantoUpdate = new List<foyer_Paneliste__c>();
        
        for(foyer_Paneliste__c foyerpaneliste : Trigger.new){
            foyerPanelisteIdList.add(foyerpaneliste.Id);
        }
        System.debug('$$$FoyerPanelisteAfterInsert foyerPanelisteIdList : ' + foyerPanelisteIdList);
        
        listFoyerPan = [SELECT Id, Foyer__c, Date_de_chute__c, Referentiel_panel__c 
                        FROM Foyer_Paneliste__c 
                        WHERE Id IN : foyerPanelisteIdList 
                        AND Referentiel_panel__r.type_de_panel__c = :Label.RFP_TypePanel_AIP];
       
        For (Foyer_Paneliste__c fp : listFoyerPan) {
            if(fp.Date_de_chute__c != null){   // Chute definitive => commande de chute 
                listFoyerPantoUpdate.add(fp);
            }
          system.debug('$$$ In FoyerPAnelisteAfterInsert listFoyerPantoUpdate '  + listFoyerPantoUpdate);
        }
               
       If(listFoyerPantoUpdate.size()>0 && listFoyerPantoUpdate!=null){// creer commande de chute
            //AP01_Commande.creerCommandeChuteFoyerPan(listFoyerPantoUpdate);
        }
        
         
    } 
    
    
    
    
    
}