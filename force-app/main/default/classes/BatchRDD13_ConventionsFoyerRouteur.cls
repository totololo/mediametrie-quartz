/*
* @author: Bastien Pinard
* @date: 22/12/2022
* @ Description 
* @TestClass: BatchRDD013_Conventions_Test
* @Coverage: 
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD13_ConventionsFoyerRouteur implements Database.Batchable<sObject> { 
    
    public Database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Foyer__r.Date_de_reception_de_la_convention__c, Foyer__r.Date_de_signature_de_la_convention__c, 
            Foyer__r.Contact_principal__c, Foyer__r.personne_de_reference__c, Referentiel_Panel__r.Type_de_panel__c, Foyer__c, foyer__r.name
            FROM Foyer_Paneliste__c 
            WHERE Foyer__r.Date_de_reception_de_la_convention__c != null OR Foyer__r.Date_de_signature_de_la_convention__c != null
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Foyer_Paneliste__c> scope) {
        System.debug('$$$BatchRDD013_Conventions scope : '+ scope);
        List<Referentiel_convention__c> refConvList = [SELECT Id, Referentiel_Panel__r.Type_de_panel__c, Type_de_la_convention__c  
                                                       FROM Referentiel_convention__c 
                                                       WHERE Statut__c=:label.Ref_Conv_Statut_Actif];
        
        List<Convention__c> conventionToInsertList = new List<Convention__c>();
        List<Contact> compositionFoyerList = new List<Contact>();
        Map<Id, Id> foyerIdFoyerPanelisteIdMap = new map<Id, Id>();
        Map<Id, Id> foyerPanelisteIdCompositionFoyerIdMap = new Map<Id, Id>();
        for(Foyer_Paneliste__c foyerPan: scope) {
            if(foyerPan.Referentiel_Panel__r.Type_de_panel__c == label.RFP_TypePanel_AIP) {
                foyerIdFoyerPanelisteIdMap.put(foyerPan.Foyer__c, FoyerPan.Id);
            }
        }
            
        compositionFoyerList = [SELECT Id, AccountId, Account.personne_de_reference__c,age__c 
                                FROM Contact 
                                WHERE (AccountId IN :foyerIdFoyerPanelisteIdMap.keySet()) AND Type__c = :Label.CON_Type_Membre];
        for(Contact compoFoyer:compositionFoyerList) {
            if(compofoyer.age__c >= 18) {
                foyerPanelisteIdCompositionFoyerIdMap.put(foyerIdFoyerPanelisteIdMap.get(compoFoyer.AccountId), compoFoyer.Id);
            }
            else {
                foyerPanelisteIdCompositionFoyerIdMap.put(foyerIdFoyerPanelisteIdMap.get(compoFoyer.AccountId), compoFoyer.Account.personne_de_reference__c);
            }
            
        }
        
        for(Foyer_Paneliste__c foyerPan: scope) {
            Convention__c convention = new Convention__c();
            //Convention Foyer MMT
            if (foyerPan.Referentiel_Panel__r.Type_de_panel__c == label.RFP_TypePanel_MMAT) {
                for(Referentiel_convention__c refConv : refConvList){
                    if(refConv.Referentiel_Panel__r.Type_de_panel__c == label.RFP_TypePanel_MMAT && refConv.Type_de_la_convention__c == Label.RFC_Type_Convention_Foyer){
                        convention.Referentiel_convention__c = refConv.Id;
                    }
                }
                convention.name = 'Convention Foyer ' +  foyerPan.foyer__r.name + ' ' + label.RFP_TypePanel_MMAT;
                convention.foyer_Paneliste__c = foyerPan.Id;
                convention.composition_du_Foyer__c = foyerPan.Foyer__r.Contact_principal__c;
                convention.Type_de_signature__c = Label.RFC_Type_Signature_Electronique;
                if(foyerPan.Foyer__r.Date_de_signature_de_la_convention__c != null) {
                    convention.Date_de_signature_de_la_convention__c = foyerPan.Foyer__r.Date_de_signature_de_la_convention__c;
                }
                else {
                    convention.Date_de_signature_de_la_convention__c = foyerPan.Foyer__r.Date_de_reception_de_la_convention__c;
                }
            }
            
            //Convention PaME
            else if (foyerPan.Referentiel_Panel__r.Type_de_panel__c == label.RFP_TypePanel_PaME) {
                //Convention Foyer PaME
                for(Referentiel_convention__c refConv : refConvList){
                    if(refConv.Referentiel_Panel__r.Type_de_panel__c == label.RFP_TypePanel_PaME && refConv.Type_de_la_convention__c == Label.RFC_Type_Convention_Foyer){
                        convention.Referentiel_convention__c = refConv.Id;
                    }
                }
                convention.name = 'Convention Foyer ' +  foyerPan.foyer__r.name + ' ' + label.RFP_TypePanel_PaME;
                convention.foyer_Paneliste__c = foyerPan.Id;
                convention.composition_du_Foyer__c = foyerPan.Foyer__r.Contact_principal__c;
                if(foyerPan.Foyer__r.Date_de_signature_de_la_convention__c != null) {
                    convention.Date_de_signature_de_la_convention__c = foyerPan.Foyer__r.Date_de_signature_de_la_convention__c;
                	convention.Type_de_signature__c = Label.RFC_Type_Signature_Electronique;
                }
                else {
                    convention.Date_de_signature_de_la_convention__c = foyerPan.Foyer__r.Date_de_reception_de_la_convention__c;
                	convention.Type_de_signature__c = Label.RFC_Type_Signature_Papier;
                }
                
                //Convention Routeur PaME
                Convention__c conventionRouteur = new Convention__c();
                for(Referentiel_convention__c refConv : refConvList){
                    if(refConv.Referentiel_Panel__r.Type_de_panel__c == label.RFP_TypePanel_PaME && refConv.Type_de_la_convention__c == Label.RFC_Type_Convention_Routeur){
                        conventionRouteur.Referentiel_convention__c = refConv.Id;
                    }
                }
                conventionRouteur.name = 'Convention Routeur ' +  foyerPan.foyer__r.name + ' ' + label.RFP_TypePanel_PaME;
                conventionRouteur.foyer_Paneliste__c = foyerPan.Id;
                conventionRouteur.composition_du_Foyer__c = foyerPan.Foyer__r.Contact_principal__c;
                conventionRouteur.Type_de_signature__c = Label.RFC_Type_Signature_Electronique;
                if(foyerPan.Foyer__r.Date_de_signature_de_la_convention__c != null) {
                    conventionRouteur.Date_de_signature_de_la_convention__c = foyerPan.Foyer__r.Date_de_signature_de_la_convention__c;
                }
                else {
                    conventionRouteur.Date_de_signature_de_la_convention__c = foyerPan.Foyer__r.Date_de_reception_de_la_convention__c;
                }
                conventionToInsertList.add(conventionRouteur);
            }
            conventionToInsertList.add(convention);
        }
                
        if(conventionToInsertList.size() > 0 && conventionToInsertList != null) {
            try{ 
                database.insert(conventionToInsertList, true);
            }Catch(exception ex){
                system.debug('Insert convention Exception Error:' + ex.getmessage());
            }
        }
        
    }
    
    public void finish(Database.BatchableContext bc) {
    }
}