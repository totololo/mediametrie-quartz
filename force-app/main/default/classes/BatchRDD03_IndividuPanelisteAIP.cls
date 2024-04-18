/*
* @author: Claire VEHRLE
* @date: 25/04/2022
* @ Description Batch pour la RDD de l'objet Individu panéliste AIP
* @TestClass:
* @Coverage:
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD03_IndividuPanelisteAIP implements Database.Batchable<sObject>{
    public Database.Querylocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator([select id,accountid, Statut_individu__c, Date_d_entree_individu__c, 
                                         Date_de_chute_individu__c, Lettre__c, Type__c,
                                         Id_google__c, Browser__c, Tv__c, CON_ExtId_SIPanel__c,
                                         Routeur__c, Mobile__c, Lien_meter__c, (SELECT Id FROM Paneliste__r),
                                         Date_de_synchronisation_Google__c, Signature_convention_individuelle_meter__c
                                         from Contact WHERE Account.Type_de_foyer__c = :Label.ACC_Type_de_panel_AIP AND Type__c != '2']);
    } 
    public void execute(Database.BatchableContext info, List<Contact> scope){
        System.debug(info);
        List<Id> foyerId = new List<Id>();
        Map<String,String> foyerPaneFoyer = new Map<String,String>();
        Map<String,String> foyerPaneExternalId = new Map<String,String>();
        for(Foyer_paneliste__c fp : [Select id , Foyer__c, Foyer_Paneliste_ExtId_SIPanel__c from Foyer_paneliste__c]){
            foyerPaneFoyer.put(fp.Foyer__c,fp.id);
            foyerPaneExternalId.put(fp.Foyer__c,fp.Foyer_Paneliste_ExtId_SIPanel__c);
        }
        List<Individu_Paneliste__c> individuP = new List<Individu_Paneliste__c>();
        for(Contact compoFoyer : scope){ 
            if (compoFoyer.Paneliste__r.isEmpty() && compoFoyer.Paneliste__r.size() == 0) {
                if (compoFoyer.Type__c != '2') {
                    Individu_Paneliste__c  ip = new Individu_Paneliste__c ();
                    ip.Foyer_paneliste__c = foyerPaneFoyer.get(compoFoyer.AccountId); 
                    ip.Composition_du_foyer__c = compoFoyer.Id;
                    ip.Date_d_entree_de_l_individu__c = compoFoyer.Date_d_entree_individu__c;
                    ip.Date_de_chute_de_l_individu__c = compoFoyer.Date_de_chute_individu__c;
                    ip.Lettre__c = compoFoyer.Lettre__c;
                    ip.Id_google__c = compoFoyer.Id_google__c; 
                    ip.Browser__c = compoFoyer.Browser__c; 
                    ip.Tv__c = compoFoyer.Tv__c;
                    ip.Routeur__c = compoFoyer.Routeur__c;
                    ip.Mobile__c = compoFoyer.Mobile__c;
                    ip.Lien_meter__c = compoFoyer.Lien_meter__c; 
                    ip.Date_de_synchronisation_Google__c = compoFoyer.Date_de_synchronisation_Google__c; 
                    ip.Signature_convention_individuelle_meter__c = compoFoyer.Signature_convention_individuelle_meter__c;
                    ip.CON_EXTId_SIPanel__c = compoFoyer.CON_EXTId_SIPanel__c;
                    individuP.add(ip);
                }
                
            }
            
            
        }
        if(individuP.size() > 0 && individuP != null){
            try{ 
                database.insert(individuP, false);
            }Catch(exception ex){
                system.debug('Insert Individu Paneliste AIP Exception Error:' + ex.getmessage());
            }
        }
        
    }     
    public void finish(Database.BatchableContext info){    
        
    }
}