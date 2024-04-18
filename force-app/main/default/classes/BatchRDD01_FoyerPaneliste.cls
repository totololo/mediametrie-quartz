/*
* @author: Elia KARAM
* @date: 03/03/2022
* @ Description Batch pour la RDD de l'objet Foyer Panéliste
* @TestClass: BatchRDD01_FoyerPaneliste_Test
* @Coverage: 94 %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD01_FoyerPaneliste implements Database.Batchable<sObject>{
    public Database.Querylocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator([SELECT Id, name, RecordTypeId, Type_de_foyer__c, Motif_de_suspension__c, Suspendu__c, Date_de_suspension__c, Date_de_chute__c,
                                         Date_de_creation__c, Date_d_integration__c, Date_de_recensement__c, Date_d_installation__c, 
                                         Date_de_chute_temporaire__c, Date_de_descente__c, Date_de_visite_de_courtoisie__c, Intervention_en_cours__c,
                                         Statut_du_foyer__c, Statut_audimetrique__c, LastModifiedDate, Date_du_foyer_pilote__c, 
                                         Resultat_du_traitement__c, Solde_de_points__c, Freeze__c, Date_de_Freeze__c, ACC_EXTId_SIPanel__c,
                                         Nombre_de_mois_d_anciennete__c, Date_de_derniere_commande__c ,Single_source__c, (SELECT Id FROM Panelistes__r)
                                         FROM account WHERE Type_de_foyer__c = :Label.ACC_Type_de_panel_PaME OR Type_de_foyer__c = :Label.ACC_Type_de_panel_Mediamat
                                        ]);
    } 
    public void execute(Database.BatchableContext info, List<Account> scope){
        System.debug(info);
        List<Foyer_paneliste__c> foyerP = new List<Foyer_paneliste__c>();
        Id recordTypeIdMMATPaME = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_mediamatpame).getRecordTypeId();
        Id recordTypeIdEquipe = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.ACC_RecordType_FoyerEquipeTV).getRecordTypeId();
        Id recordTypeIdNonEquipe = Schema.SObjectType.Account.getRecordTypeInfosByName().get(Label.ACC_RecordType_FoyerNonEquipeTV).getRecordTypeId();
        List<Referentiel_Panel__c> refPan = [select Id, Type_de_panel__c from Referentiel_Panel__c ];
        Map<String,String> refPanel = new Map<String,String>();
        for(Referentiel_Panel__c ref : refPan){
            refPanel.put(ref.Type_de_panel__c,ref.id);
        }
        
        for(Account a : scope){ 
            if(a.Panelistes__r.isEmpty() && a.Panelistes__r.size() == 0) {
                
                List<String> nameList = new List<String>();
                nameList.addAll(a.name.split(' '));
                Foyer_paneliste__c  fp = new Foyer_paneliste__c ();
                fp.name = a.name;
                fp.recordTypeId = recordTypeIdMMATPaME;
                System.debug(a.Type_de_foyer__c);
                if (a.Type_de_foyer__c == Label.ACC_Type_de_panel_Mediamat) {
                    fp.Referentiel_Panel__c = refPanel.get(Label.RFP_TypePanel_MMAT);
                }
                else if (a.Type_de_foyer__c == Label.ACC_Type_de_panel_Pame) {
                    fp.Referentiel_Panel__c = refPanel.get(Label.RFP_TypePanel_PaME);
                }
                
                fp.Foyer__c = a.Id;
                if(a.RecordTypeId == recordTypeIdEquipe) {
                    fp.foyer_Equipe__c = true;
                }
                else if(a.RecordTypeId == recordTypeIdNonEquipe) {
                    fp.foyer_Equipe__c = false;
                }
                fp.Statut_Foyer_paneliste__c = a.Statut_du_foyer__c;
                System.debug('motif '+a.Motif_de_suspension__c);
                fp.Motif_de_suspension__c = a.Motif_de_suspension__c;
                fp.Suspendu__c = a.Suspendu__c;
                fp.Date_de_suspension__c = a.Date_de_suspension__c;
                fp.Date_de_chute__c = a.Date_de_chute__c;
                fp.Date_de_creation__c = a.Date_de_creation__c;
                fp.Date_d_integration__c = a.Date_d_integration__c;
                fp.Date_de_recensement__c = a.Date_de_recensement__c;
                fp.Date_d_installation__c = a.Date_d_installation__c;
                fp.Date_de_chute_temporaire__c = a.Date_de_chute_temporaire__c;
                fp.Date_de_descente__c = a.Date_de_descente__c;
                fp.Date_de_visite_de_courtoisie__c  = a.Date_de_visite_de_courtoisie__c;
                fp.Statut_Foyer_paneliste__c = a.Statut_du_foyer__c;
                fp.Statut_audimetrique__c = a.Statut_audimetrique__c;
                fp.Date_du_foyer_pilote__c = a.Date_du_foyer_pilote__c;
                fp.Resultat_du_traitement__c = a.Resultat_du_traitement__c;                 
                fp.Intervention_en_cours__c = a.Intervention_en_cours__c;
                fp.Freeze__c = a.Freeze__c;
                fp.Date_de_Freeze__c = a.Date_de_Freeze__c;
                if(a.Date_de_derniere_commande__c != null){
                    DateTime dT =a.Date_de_derniere_commande__c;
                    fp.Date_de_derni_re_commande__c = date.newinstance(dT.year(), dT.month(), dT.day());
                }
                
                fp.Foyer_Pilote__c = a.Single_source__c;
                fp.ACC_EXTId_SIPanel__c = a.ACC_ExtId_SIPanel__c;
                fp.Foyer_Paneliste_ExtId_SIPanel__c = nameList[0];
                foyerP.add(fp);
            }            
        }
        if(foyerP.size()>0 && foyerP !=null){
            //Insert foyerP;
            try{ 
                database.insert(foyerP, false);
            }Catch(exception ex){
                system.debug('Insert Foyer Panéliste Exception Error:' + ex.getmessage());
            }
        }
        
        
        
    }     
    
    public void finish(Database.BatchableContext info){    
        
    } 
    
}