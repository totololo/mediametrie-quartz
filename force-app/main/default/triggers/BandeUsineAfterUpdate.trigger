trigger BandeUsineAfterUpdate on Bande_Usine__c (after update) {
		
    if(PAD.canTrigger('AP01_BandeUsine')){
        //AP01_BandeUsine.checkDeprovisionningOCOM(Trigger.New,Trigger.old);

    }
    
    if(PAD.canTrigger('AP02_BandeUsine')){
        List<Id> BUProvisionnee = new List<Id>();
        List<Id> BUNonProvisionnee = new List<Id>();
        List<Id> BUAProvisionnee = new List<Id>();
        for (Bande_Usine__c bu: Trigger.New) {
            if (bu.Date_declaration_OCOM__c == null) {
                BUNonProvisionnee.add(bu.Id);
            }
            else if(bu.Statut_de_l_import__c == Label.BandeUsine_statut_Rejete && bu.Statut_de_l_import__c != Trigger.oldMap.get(Bu.Id).Statut_de_l_import__c) {
                   BUProvisionnee.add(bu.Id); 
                }
            else if (bu.Date_declaration_OCOM__c != null) {
                BUAProvisionnee.add(bu.Id);
            } 
        }
                     
            
        
        if(BUNonProvisionnee != null && BUNonProvisionnee.size() > 0) {
            AP02_BandeUsine.bandeUsineNonProvisionnee(BUNonProvisionnee);
        }
        if(BUProvisionnee != null && BUProvisionnee.size() > 0) {
            AP02_BandeUsine.deprovisionningBandeUsine(BUProvisionnee);
        }
        if(BUAProvisionnee != null && BUAProvisionnee.size() > 0) {
            AP02_BandeUsine.bandeUsineProvisionning(BUAProvisionnee);
        }


        

    }
}