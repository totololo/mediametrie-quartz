/*
* @author: Khaled Hammoudeh
* @date: 25/09/2020
* @ Description Class that updates the status of Étiquettes when the connection status on the equipments (Assets) is changed
* @TestClass: AP01_Equipement_Test
* @Coverage: 100 %
* History
* <Date of modification>   <Author>    <Description of modification>
* 28/07/2021				MZ			Ticket MEDIAMETRIE-257 - replaced updateEtiquettesStatus() with updateEtiquettesControlesRequetes()
*/
public class AP01_Equipement {
    
    public static void updateEtiquettesControlesRequetes(list<asset> listEquipements, List<Id> listIdEquipements, List<Id> listIdRelatedFoyers) {
        
        
        integer i=0;
        boolean asset_ctrl=false;
        list<Etiquette__c> listRelatedEtiquettes = [SELECT id, Date_de_debut__c, Date_de_fin__c, Nom_de_l_etiquette__c, Poste__c, Foyer__c, Statut__c 
                                                    FROM Etiquette__c
                                                    WHERE Date_de_fin__c >=: date.today()
                                                    AND Statut__c =: Label.ETI_Statut_Actif
                                                    AND Poste__c IN :listIdEquipements];
        
        list<Controle__c> listRelatedControles = [SELECT id, Statut__c, Date_de_controle__c, Requete__c,Audimetre__c
                                                  FROM Controle__c
                                                  Where Statut__c =: Label.CTRL_Statut_Actif 
                                                  AND createdDate >= yesterday AND tech_reconnecte__c=false
                                                  AND (Audimetre__c IN :listIdEquipements OR Foyer__c IN :listIdRelatedFoyers)
                                                  AND (Sous_type_de_controle__c	= '7' or Sous_type_de_controle__c='16')]; // sous type = audimetre non connecté
        
   		list<asset> AssetFoyer = [select id,Statut_de_connexion__c from asset where Foyer_paneliste__c in:listIdRelatedFoyers  and RecordType.name=:label.ASS_RecordType_PaMe ];
		list<controle__c> listCtrlToUpdate = new list<controle__c>();
        List<Id> listIdCases = new List<Id>();
        List<Id> listIdControls = new List<Id>();
        List<Case> listCaseToUpdate = new List<Case>();
        
        for(Etiquette__c etiquette : listRelatedEtiquettes)
        {
            etiquette.Statut__c = Label.ETI_Statut_Inactif;
        }
        
        for(Controle__c controle : listRelatedControles)
        {
            for (asset a: AssetFoyer){
               
                if (a.Statut_de_connexion__c=='ConnectedCol' || a.Statut_de_connexion__c=='ConnectedSup'|| a.Statut_de_connexion__c=='ConnectedExp' || a.Statut_de_connexion__c=='Connected') {
                    i=i+1; 
                    if (controle.Audimetre__c==a.Id){
                        
                        asset_ctrl=true;
                    }
                }
                
                
            }
            if (AssetFoyer.size()==i || asset_ctrl==true){
                controle.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_ReconnecteSeul;
                controle.Statut__c = Label.CTRL_Statut_Precode;
                listIdCases.add(controle.Requete__c);
                listIdControls.add(controle.Id);
                listCtrlToUpdate.add(controle);
            }
        }
        
        List<Case> listRelatedCases = [SELECT Id, status,
                                       (SELECT Id
                                        FROM Controles__r
                                        WHERE Statut__c =: Label.CTRL_Statut_Actif
                                        AND createdDate >= yesterday
                                        AND Id NOT IN :listIdControls)
                                       FROM Case
                                       WHERE Id IN :listIdCases];
        
        for(Case requete : listRelatedCases)
        {
            if(requete.Controles__r.size() == 0 && requete.Status!=label.CAS_Statut_En_cours)
            {
                requete.Status = Label.CAS_Statut_Cloture;
                requete.Motif_de_statut__c = Label.CTRL_LibellePrecodage_ReconnecteSeul;
                listCaseToUpdate.add(requete);
            }
        }
        
        if(listRelatedEtiquettes.size() > 0) 
        {
            update listRelatedEtiquettes;
        }
        
        if(listCtrlToUpdate.size() > 0) 
        {
            system.debug('liste '+listCtrlToUpdate);
            for(Case requete : listRelatedCases){
                if (requete.Status!=label.CAS_Statut_En_cours){
                	update listCtrlToUpdate;
                }
            }
            
        }
        
        if(listCaseToUpdate.size() > 0) 
        {
            update listCaseToUpdate;
        }
    }
    
    /*
    public static void updateEtiquettesStatus(list<asset> listEquipements)
    {
        system.debug('$$$ listEquipements ' + listEquipements);
        list<Asset> listEquipWithEtiquettes = [Select id, Statut_de_connexion__c, 
                                               (Select id, Date_de_debut__c, Date_de_fin__c, Nom_de_l_etiquette__c, Poste__c, Foyer__c, Statut__c 
                                                from Etiquettes__r
                                                Where Date_de_fin__c >=: date.today()
                                                AND Statut__c =: Label.ETI_Statut_Actif),
                                               (Select id, Statut__c, Date_de_controle__c, Requete__c
                                                FROM Controles__r
                                                Where Statut__c =: Label.CTRL_Statut_Actif AND createdDate >= yesterday)
                                               From Asset
                                               Where Id IN: listEquipements];
        
        list<Etiquette__c> listEtiquetteToUpdate = new list<Etiquette__c>();
        list<Controle__c> listControlsToUpdate = new list<Controle__c>();
        Map<Id,Id> mapControleRequete = new Map<Id,Id>(); //257
        
        for(Asset equipement : listEquipWithEtiquettes)
        {
            for(Etiquette__c etiquette : equipement.Etiquettes__r)
            {
                etiquette.Statut__c = Label.ETI_Statut_Inactif;
                listEtiquetteToUpdate.add(etiquette);
            }
            
            //Precode associated controls if the poste was connected on its own between 3 and 27 hours from the date of the control
            for(Controle__c controle : equipement.Controles__r)
            {
                //datetime dateControle = datetime.newInstance(2020, 10, 4, 14, 30, 00);
                Long timeNow = DateTime.now().getTime();
                Long timeControl = controle.Date_de_controle__c.getTime();
                Long milliseconds = timeNow - timeControl;
                Long seconds = milliseconds / 1000;
                Long minutes = seconds / 60;
                Long hours = minutes / 60;
                system.debug('$$$ KHA hours ' + hours);
                if(hours >= 3 && hours <= 27)
                {
                    controle.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_ReconnecteSeul;
                    controle.Statut__c = Label.CTRL_Statut_Precode;
                    listControlsToUpdate.add(controle);
                    mapControleRequete.put(controle.Id, controle.Requete__c);//257
                }
            }
        }
        
        if(listEtiquetteToUpdate.size() > 0)
        {
            update listEtiquetteToUpdate;
        }
        
        if(listControlsToUpdate.size() > 0)
        {
            update listControlsToUpdate;
        }
    }*/
}