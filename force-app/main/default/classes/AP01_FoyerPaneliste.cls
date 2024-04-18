/*
* @author: Khaled Hammoudeh
* @date: 18/06/2021
* @ Description classe qui cré une requête à la création d'un enregistrement Panel Mediamat / Pame ou AIP
* @TestClass: AP01_Panel_Test
* @Coverage: 92%
* History
* Date of modification :05/07/2021   Author :Ayoub GHAMMAZ    
Description of modification: Modification de la méthode NouvelleReqAIP pour créer une requête qui contient une commande et les produits commandés

* <Date of modification>   <Author>    <Description of modification>
*/
public class AP01_FoyerPaneliste {
    
    //Create new case for "Installation nouveau foyer" 
    public static void NouvelleReq(List<Foyer_paneliste__c> ListNewPanelisteMMPame)
    {
        system.debug('$$$NouvelleReq');
        
        Id recordTypeIdRequeteDemandePaneliste =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePaneliste).getRecordTypeId();
        List<Case> listCaseToInsert = new List<Case>();
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = true;
        for(Foyer_paneliste__c pan : ListNewPanelisteMMPame)
        {
            Case caseDemandePanel = createRequete(Label.CASE_Description_InstallationNouveauFoyer, recordTypeIdRequeteDemandePaneliste, 
                                                  Label.CAS_Origine_NouveauFoyer, pan.id,pan.Foyer__c, Label.CAS_Type,
                                                  Label.CAS_Sous_type_Installation_Nouveau_Foyer, dmo);
            listCaseToInsert.add(caseDemandePanel); 
            system.debug('ggg' +caseDemandePanel);
        }
        
        if(listCaseToInsert!=null && listCaseToInsert.size()>0)
        {
            try{ 
                system.debug('ttt');
                database.insert(listCaseToInsert);
            }Catch(exception ex){
                system.debug('Insert Case Nouveau Foyer Exception Error:'+ex.getmessage());
            }
        }
    }
    
    //Create new case Pack initial for panel AIP
    public static void NouvelleReqAIP(List<Foyer_paneliste__c> ListNewPanelisteAIP)
    {
        system.debug('$$$NouvelleReqAIP');

        Id recordTypeIdRequeteDemandePanelisteAIP =Schema.SObjectType.Case.getRecordTypeInfosByName().get(label.CAS_Recordtype_DemandePanelisteAIP).getRecordTypeId();
        List<Case> listCaseToInsert = new List<Case>();  
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = true;
        
        
        for(Foyer_paneliste__c pan : ListNewPanelisteAIP) {
            System.debug('$$$ AP01_FOyerpaneliste Création requête');
            
            String sousType;
            if(pan.Nombre_de_set_meters__c > 0 && pan.Nom_pilote__c == Label.PAN_Nom_Pilote_ROAv3){
                System.debug('***ROA setmeter');
                sousType = Label.CAS_Sous_type_PackInitial_ROAv3_Setmeter;
            }
            else if(pan.Nom_pilote__c == Label.PAN_Nom_Pilote_ROAv3){
                System.debug('***ROA');
                sousType = Label.CAS_Sous_type_PackInitial_ROAv3;
            }
            else if (pan.Nombre_de_set_meters__c > 0) {
                System.debug('***setmeter');
				sousType = Label.CAS_Sous_type_PackInitial_SetMeter;                
            }
            else {
                System.debug('***pager');
                sousType = Label.CAS_Sous_type_PackInitial;
            }
            
            Case caseDemandePanelAIP = createRequete(Null, recordTypeIdRequeteDemandePanelisteAIP, Label.CAS_Origine_NouveauFoyer,
                                                     pan.id,pan.Foyer__c, Label.CAS_Type_Recrute, sousType, dmo);
            listCaseToInsert.add(caseDemandePanelAIP); 
            System.debug('*** caseDemandePanelAIP' + caseDemandePanelAIP);
        }
        System.debug('*** listCaseToInsert' + listCaseToInsert);
        
        if(listCaseToInsert!=null && listCaseToInsert.size()>0) {
            try{ 
                database.insert(listCaseToInsert);
                System.debug('***Insertion réussi');
            } Catch(exception ex) {
                system.debug('Insert Case Pack Initial/Welcome call Exception Error:'+ex.getmessage());
            }
        }
        System.debug('*** listCaseToInsert' + listCaseToInsert);
        
    }
    
    
    //Method to create requête
    // String membreDuFoyerId,
    public static case createRequete(String descriptionRequete, String recTypeId, String origineRequete, String panelId, String foyerId,
                                     String typeRequete, String sousTypeRequete, Database.DMLOptions dmo)
    {
        Case cs = new Case();
        cs.description = descriptionRequete;
        cs.RecordTypeId = recTypeId;
        cs.Origin = origineRequete;
        cs.AccountId=foyerId;
        cs.Foyer_paneliste__c = panelId ;
        //cs.ContactId = membreDuFoyerId;
        cs.Type = typeRequete;
        cs.Sous_type__c = sousTypeRequete;
        cs.setOptions(dmo);
        
        return cs;
    }
}