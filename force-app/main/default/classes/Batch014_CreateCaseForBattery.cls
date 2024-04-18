/*
* @author: Ayoub GHAMMAZ
* @date: 16/07/2021
* @ Description: Ce batch permet de verifier le niveau de batterie des beacon des foyer ,
si la batterie et a moins de 20% ou à 0% ou elle n'a pas transmit de données depuis 2 mois un contrôle esr généré
* @TestClass: Batch014_CreateCaseForBattery_test
* @Coverage: 96%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* 		12/11/2021			Claire VEHRLE		Changement suite aux retour de Médiamétrie
*		11/01/2022			Ayoub GHAMMAZ		creation d'une requete de controle AIP si elle n'existe pas , sinon on rattache le nouveau controle a la requete controle AIP existante
* */
global class Batch014_CreateCaseForBattery implements Database.Batchable<sObject>, Database.AllowsCallouts  {
    
     //Added for email notification - START
    global String errorTxt = '';
    global Boolean containsErrors = false;
    //Added for email notification - END

    global List<Foyer_paneliste__c> start(Database.BatchableContext bc) {
        date lastmonth=date.today().adddays(-30);
       /* List<Asset> beaconList = [
            SELECT id, Batterie__c,AccountId, Foyer_paneliste__c, Type_de_materiel__c, Date_de_derniere_detection__c, ContactId, Status, Product2.Version__c, Product2.Code_article_prestataire__c,
            Foyer_paneliste__r.Statut_Foyer_paneliste__c, Foyer_paneliste__r.Date_de_premiere_collecte__c, Date_d_affectation__c, Product2Id, Produit_commande__c
            FROM Asset
            WHERE Type_de_materiel__c = :Label.ASS_Type_De_Materiel_Beacon
            AND Batterie__c != -1
            AND Batterie__c != null
            AND (Product2.Code_article_prestataire__c=:label.PROD_Code_article_prestataire_Beacon_V2
            OR Product2.Code_article_prestataire__c=:label.PROD_Code_article_prestataire_Beacon_V1)
            AND Foyer_paneliste__c !=null
            AND AccountId!=:label.Foyer_Cordon
            AND Foyer_paneliste__r.Statut_Foyer_paneliste__c != :label.PAN_Statut_Panel_Chute_definitive
            AND Foyer_paneliste__r.Statut_Foyer_paneliste__c != :label.PAN_Statut_Panel_Chute_temporaire
        ];
        
        List<Asset> beaconList = [
            SELECT id, Batterie__c,AccountId, Foyer_paneliste__c, Type_de_materiel__c, Date_de_derniere_detection__c, ContactId, Status, Product2.Version__c, Product2.Code_article_prestataire__c,
            Foyer_paneliste__r.Statut_Foyer_paneliste__c, Foyer_paneliste__r.Date_de_premiere_collecte__c, Date_d_affectation__c, Product2Id, Produit_commande__c
            FROM Asset
            WHERE id ='02i3O00000Jjy1RQAR'];*/
        //return beaconList;
        //
        List<Foyer_paneliste__c> FoyerPan = [ select id,Statut_Foyer_paneliste__c,Date_de_premiere_collecte__c,foyer__c, (select id,Batterie__c,AccountId, Foyer_paneliste__c, Type_de_materiel__c, Date_de_derniere_detection__c, ContactId, Status, Product2.Version__c, Product2.Code_article_prestataire__c,
        Date_d_affectation__c, Product2Id, Produit_commande__c from Equipements__r where 
        Batterie__c != -1 and
        Batterie__c != null and 
        Batterie__c <30 and (
        Product2.Code_article_prestataire__c=:label.PROD_Code_article_prestataire_Beacon_V2
        OR Product2.Code_article_prestataire__c=:label.PROD_Code_article_prestataire_Beacon_V1
         )  and     
        Foyer_paneliste__c!=null and
        AccountId!=:label.Foyer_Cordon) 
        from Foyer_paneliste__c where 
        Statut_Foyer_paneliste__c != :label.PAN_Statut_Panel_Chute_definitive AND 
        Statut_Foyer_paneliste__c != :label.PAN_Statut_Panel_Chute_temporaire ];
        //Date_de_premiere_collecte__c >= :lastmonth];
        return FoyerPan;
    }
    global void execute(Database.BatchableContext bc, List<Foyer_paneliste__c> scope){
        System.debug('#####'+scope);
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.AssignmentRuleHeader.useDefaultRule = true;
        Id recordTypeIdControleAIP = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
        Id recordTypeIdFoyerPanelisteAIP = Schema.SObjectType.Foyer_Paneliste__c.getRecordTypeInfosByName().get(Label.PAN_recordType_AIP).getRecordTypeId();
        List<Controle__c> listControleToInsert = new List<Controle__c>();
        List<Id> FoyerPanListId = new List<Id>() ;
        List<Case> requeteToUpdate = new List<Case>();
        List<Case> requeteToInsert = new List<Case>();
        List<Controle__c> listControleWithCaseToInsert = new List<Controle__c>();
        List<Controle__c> listControleWithoutCaseToInsert = new List<Controle__c>();
        Set<Id> setIdFoyerPan = new Set<Id>();
        List<String> listFoyer = new list<String>();
        Map<Id, Asset> mapAsset = new Map<Id,Asset>();
        for(Foyer_paneliste__c a : scope){
            	setIdFoyerPan.add(a.Id); 
            listFoyer.add(a.Foyer__c);
            	//mapAsset.put(a.Produit_commande__c, a);
        }
        system.debug('mapAsset '+mapAsset);
        List<Asset> listPager = [
            SELECT Id, Date_de_premiere_collecte_d_audience__c, Foyer_paneliste__c
            FROM Asset
            WHERE Foyer_paneliste__c IN :setIdFoyerPan
            AND Type_de_materiel__c = :Label.ASS_TypeMateriel_Pager 
            AND Date_de_premiere_collecte_d_audience__c < :date.today().addDays(-30)
        ];

        Set<Id> newSetFoyerPan = new Set<Id>();
        for(Asset p : listPager){
            newSetFoyerPan.add(p.Foyer_paneliste__c);
        }
        
        //Recupération des id des foyer paneliste ayant été non répondant les 7 derniers jours
        List<Foyer_paneliste__History> listFoyPanHist = [
            SELECT  Id, ParentId,  Field, NewValue, OldValue, CreatedDate 
            FROM Foyer_paneliste__History  
            WHERE Field ='Statut_Audimetrique__c' 
            AND CreatedDate > :Date.Today().addDays(-7)
            AND ParentId IN :newSetFoyerPan
            AND Parent.RecordTypeId=:recordTypeIdFoyerPanelisteAIP
            ORDER BY CreatedDate DESC
        ];

        List<Foyer_paneliste__c> listFoyerPanRepondant = [
            SELECT Id
            FROM Foyer_paneliste__c
            WHERE Statut_Audimetrique__c !=:label.PAN_Statut_Audimetrique_nonRepondant
            AND Id IN :newSetFoyerPan
            AND RecordTypeId=:recordTypeIdFoyerPanelisteAIP
        ];

        Set<Id> setFoyPan = new Set<Id>();
        for(Foyer_paneliste__History c : listFoyPanHist){
            
            setFoyPan.add(c.ParentId);
        }
        
        for(Foyer_paneliste__c f : listFoyerPanRepondant){
            setFoyPan.add(f.Id);
        }        
        Date expeditionLastWeek = Date.Today().addDays(-7);
        //Récupération des dernier orders pour chaque foyer pan
        List<Order> listOrder = [
            SELECT Id, Foyer_paneliste__c, Date_d_expedition__c,EffectiveDate,(
                SELECT Id, Product2Id 
                FROM OrderItems 
                WHERE Product2.Code_article_prestataire__c=:label.PROD_Code_article_prestataire_Beacon_V2
                OR Product2.Code_article_prestataire__c=:label.PROD_Code_article_prestataire_Beacon_V1
            )
            FROM Order
            WHERE Foyer_paneliste__c IN :setFoyPan
            AND Date_d_expedition__c >=:expeditionLastWeek
            ORDER BY Date_d_expedition__c DESC
        ];
/*
        Map<Id, Order> mapLastOrder = new Map<Id, Order>(); 
        for(Order o : listOrder){
            if(mapLastOrder.get(o.Foyer_paneliste__c) == null && o.OrderItems != null){
                mapLastOrder.put(o.Foyer_paneliste__c, o);
            }
        }
        system.debug('mapLastOrder '+mapLastOrder);
        List<Asset> listBeaconsFromLastOrder = new List<Asset>();
        for(Order o : mapLastOrder.values()){
            for(OrderItem I : o.OrderItems){
                if(mapAsset.get(I.Id) != null ){
                    listBeaconsFromLastOrder.add(mapAsset.get(I.Id));
                }
            }
        }
system.debug('listBeaconsFromLastOrder '+listBeaconsFromLastOrder);*/
        // modification AYoub du 11/01/2022 :DEBUT
        //RecordTypeId de la requete controle AIP
        Id recordTypeIdRequeteControleAIP = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_ControleAIP).getRecordTypeId();
        // Map du foyer et ses requetes controle AIP pour verifier si ce foyer a deja une requete controle AIP 
        
        // ajout de statut et type et sous type si besoin
        // quel statut pour une requete ouverte  a laquelle on peut rattacher des controle
        //on test si une requ existe et on rattache le controle et si il n'ya pas de requ on la créée
        List<Case> listCases = [
            select Id ,RecordTypeId, type , Sous_type__c, AccountId from Case where RecordTypeId=:recordTypeIdRequeteControleAIP 
            and Foyer_Paneliste__c IN :setFoyPan 
            and Status =:label.CAS_Statut_Nouveau
            and Type=:Label.CTRL_LL_Type_Controle_Beacon
            and  (
                Sous_type__c=:Label.CAS_SousType_TousBeaconsInactifs
                or Sous_type__c=:Label.CAS_Sous_type_TousBeacons20
                or Sous_type__c=:Label.CAS_Sous_type_AuMoins1BeaconInactif
            )
        ];
        
        
        Map<Id, Case> mapCase = new Map<Id,Case>();
       //Set<Id> setCaseId = new Set<Id>();
        for(Case c: listCases){
            mapCase.put(c.AccountId, c);
           //setCaseId.add(c.Id);
        }
        
        /*List<Controle__c> listControleEnCours = [
            SELECT Id, Requete__c, CreatedDate
            FROM Controle__c
            WHERE Requete__c IN :setCaseId
            AND CreatedDate > :date.today().addDays(-7)
        ];
        
        Map<Id,Controle__c> mapControleEnCours = new Map<Id,Controle__c>();
        for(Controle__c con : listControleEnCours){
            mapControleEnCours.put(con.Requete__c, con);
        }*/
        
        AggregateResult[] groupedResults = [select AccountId, COUNT(Id) from Asset where Type_de_materiel__c=:Label.ASS_Type_De_Materiel_Beacon and AccountId in :listFoyer  group by AccountId];
        Map<String, Integer> mapAggRes = new Map<String, Integer>();
        for(AggregateResult a : groupedResults){
            mapAggRes.put(String.valueOf(a.get('AccountId')), Integer.valueOf(a.get('expr0')));
        }

        for(String foyer: listFoyer) {
            List<Asset> listBatteryLess20 = new List<Asset>();
            List<Asset> listBeaconInactif = new List<Asset>();
            List<Asset> assetWhichGeneratControleCase1 = new List<Asset>();
            List<Asset> assetWhichGeneratControleCase2 = new List<Asset>();
            List<Asset> assetWhichGeneratControleCase3 = new List<Asset>();
            for (Foyer_paneliste__c fp:scope){
            for (Asset equipement: fp.Equipements__r) {
                // verifier si la list contient l'id . cette liste sera utilisé pour recuperer des foyer pan dans la map
                if(equipement.AccountId == foyer){
                    Integer nbMoisNonDetecte = 0;
                    if(equipement.Date_de_derniere_detection__c != null) {// verifier combien de mois le beacon n'a pas transmit des données
                        nbMoisNonDetecte = equipement.Date_de_derniere_detection__c.monthsBetween(Date.today());   
                        System.debug('dd1->'+nbMoisNonDetecte);
                    }
            		System.debug('$$$Batch014_CreateCaseForBattery equipement.Batterie__c : ' + equipement.Batterie__c);
            		System.debug('$$$Batch014_CreateCaseForBattery equipement.Product2.Code_article_prestataire__c : ' + equipement.Product2.Code_article_prestataire__c);
            		System.debug('$$$Batch014_CreateCaseForBattery nbMoisNonDetecte : ' + nbMoisNonDetecte);
                    if(
                        (
                            (equipement.Batterie__c <= decimal.valueOf(Label.Batch_Niveau_batterie) && equipement.Product2.Code_article_prestataire__c==label.PROD_Code_article_prestataire_Beacon_V1)
                            || (equipement.Batterie__c <= decimal.valueOf(Label.Batch_Niveau_batterie_15) && equipement.Product2.Code_article_prestataire__c==label.PROD_Code_article_prestataire_Beacon_V2)
                        )
                        && equipement.Batterie__c !=0
                        && (nbMoisNonDetecte <= 1 && nbMoisNonDetecte != null)
                    ){
                        listBatteryLess20.add(equipement);
                        assetWhichGeneratControleCase1.add(equipement);
                    }
                    
                    else if(
                        (
                            (equipement.Product2.Code_article_prestataire__c==label.PROD_Code_article_prestataire_Beacon_V1 && equipement.Batterie__c <= decimal.valueOf(Label.Batch_Niveau_batterie_30) && nbMoisNonDetecte >= 12) ||
                            (equipement.Product2.Code_article_prestataire__c==label.PROD_Code_article_prestataire_Beacon_V2 && equipement.Batterie__c <= decimal.valueOf(Label.Batch_Niveau_batterie_15) && nbMoisNonDetecte >= 36)
                        )
                    ){
                        listBeaconInactif.add(equipement);
                        assetWhichGeneratControleCase2.add(equipement);
                    }
                    else if(equipement.Batterie__c == 0 || nbMoisNonDetecte >= 2 ){
                        listBeaconInactif.add(equipement);
                        assetWhichGeneratControleCase3.add(equipement);
                    }
                }
            }
        }
            

            for (Asset equipement: assetWhichGeneratControleCase1) {
                Controle__c controle = new Controle__c();
                controle.RecordTypeId = recordTypeIdControleAIP;
                controle.foyer__c = foyer;
                controle.Foyer_paneliste__c = equipement.Foyer_paneliste__c;
                controle.Membre_du_foyer__c = equipement.ContactId;
                controle.Type_de_controle__c = Label.CTRL_Type_Controle_Beacon;
                //controle.Resultat_d_appel__c = Label.CTRL_ResultatAppel_Commande_Beacon_Non_envoyee;
                controle.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_BatterieFaible;
                // verifier si toutes les batteries du foyer sont moins de 20%
                if(mapAggRes.get(foyer) <= listBatteryLess20.size()){
                    controle.Sous_type_de_controle__c = Label.CTRL_SousType_Tous_Beacons_Moins_20;
                    // modification AYoub du 11/01/2022 :DEBUT
                    if(mapCase.get(foyer)!=null && !FoyerPanListId.contains(equipement.Foyer_paneliste__c)){// verifier si le foyer pan a deja une requete controle AIP
                        //si oui , on associe le controle a la requete + on modifie le type et le sous type de la requete 
                        //if(mapControleEnCours.get(mapCase.get(foyer).Id) == null){
                            Case c = mapCase.get(foyer);
                            controle.Requete__c=c.id;
                            c.type= Label.CAS_Type_ControleBeacon_label;
                            c.Sous_type__c=Label.CAS_Sous_type_TousBeacons20;
                            if(!requeteToUpdate.contains(c)){
                                requeteToUpdate.add(c);
                            }
                            FoyerPanListId.Add(equipement.Foyer_paneliste__c);
                            listControleWithCaseToInsert.add(controle);
                    //}
                        
                    }else if(!FoyerPanListId.contains(equipement.Foyer_paneliste__c)){
                        // sinon , on cree une nouvelle requete controle AIP
                        listControleWithoutCaseToInsert.add(controle);// on ajoute le controle a cette liste pour pouvoir l'associer a la requete apres son insertion
                        case newCase = new case(RecordTypeId=recordTypeIdRequeteControleAIP,
                                                Foyer_paneliste__c=equipement.Foyer_paneliste__c ,
                                                AccountId=equipement.AccountId,
                                                Origin=Label.CAS_Origine_Controle,
                                                type=Label.CAS_Type_ControleBeacon_label,
                                                Sous_type__c=Label.CAS_Sous_type_TousBeacons20);
                        FoyerPanListId.Add(equipement.Foyer_paneliste__c);
                        requeteToInsert.add(newCase);
                    }
                }
                
            }
            // fin 
            
            for (Asset equipement: assetWhichGeneratControleCase2) {
                Controle__c controle = new Controle__c();
                controle.RecordTypeId = recordTypeIdControleAIP;
                controle.foyer__c = foyer;
                controle.Foyer_paneliste__c = equipement.Foyer_paneliste__c;
                controle.Membre_du_foyer__c = equipement.ContactId;
                controle.Type_de_controle__c = Label.CTRL_Type_Controle_Beacon;
                //controle.Resultat_d_appel__c = Label.CTRL_ResultatAppel_Commande_Beacon_Non_envoyee;
                controle.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_BeaconsInactifs;
                // verifier si tous les beacon du foyer sont inactifs
                if(mapAggRes.get(foyer) == listBeaconInactif.size()){
                    controle.Sous_type_de_controle__c = Label.CTRL_SousType_Tous_Beacons_Inactifs;
                    // modification AYoub du 11/01/2022 :DEBUT
                    if(mapCase.get(foyer)!=null && !FoyerPanListId.contains(equipement.Foyer_paneliste__c)){// verifier si le foyer pan a deja une requete controle AIP
                        //si oui , on associe le controle a la requete + on modifie le type et le sous type de la requete 
                        //if(mapControleEnCours.get(mapCase.get(foyer).Id) == null){
                            
                            Case c = mapCase.get(foyer);
                            controle.Requete__c=c.id;
                            c.type= Label.CAS_Type_ControleBeacon_label;
                            c.Sous_type__c=Label.CAS_SousType_TousBeaconsInactifs;
                            if(!requeteToUpdate.contains(c)){
                                requeteToUpdate.add(c); 
                            }
                            FoyerPanListId.Add(equipement.Foyer_paneliste__c);
                            listControleWithCaseToInsert.add(controle);// on ajoute le controle a cette liste pour l'insere directement
                        //}
                    }else if(!FoyerPanListId.contains(equipement.Foyer_paneliste__c)){
                        // sinon , on cree une nouvelle requete controle AIP
                        listControleWithoutCaseToInsert.add(controle);// on ajoute le controle a cette liste pour pouvoir l'associer a la requete apres son insertion
                        case newCase = new case(RecordTypeId=recordTypeIdRequeteControleAIP,
                                                Foyer_paneliste__c=equipement.Foyer_paneliste__c ,
                                                AccountId=equipement.AccountId,
                                                Origin=Label.CAS_Origine_Controle,
                                                type=Label.CAS_Type_ControleBeacon_label,
                                                Sous_type__c=Label.CAS_SousType_TousBeaconsInactifs);
                        FoyerPanListId.Add(equipement.Foyer_paneliste__c);
                        requeteToInsert.add(newCase);
                    }
                }
            }
            
            
            // FIN
            // verifier si au moins un beacon du foyer est inactif
            
            for (Asset equipement: assetWhichGeneratControleCase3) {
                Controle__c controle = new Controle__c();
                controle.RecordTypeId = recordTypeIdControleAIP;
                controle.foyer__c = foyer;
                controle.Foyer_paneliste__c = equipement.Foyer_paneliste__c;
                controle.Membre_du_foyer__c = equipement.ContactId;
                controle.Type_de_controle__c = Label.CTRL_Type_Controle_Beacon;
                //controle.Resultat_d_appel__c = Label.CTRL_ResultatAppel_Commande_Beacon_Non_envoyee;
                controle.Libelle_de_pre_codage__c = Label.CTRL_LibellePrecodage_UnBeaconInactif;
                if(listBeaconInactif.size() >= 1 && !FoyerPanListId.contains(equipement.Foyer_paneliste__c)){
                    controle.Sous_type_de_controle__c = Label.CTRL_SousType_Au_Moins_Un_Beacon_Inactif;
                    // modification AYoub du 11/01/2022 :DEBUT
                    if(mapCase.get(foyer)!=null && !FoyerPanListId.contains(equipement.Foyer_paneliste__c)){// verifier si le foyer pan a deja une requete controle AIP
                        //si oui , on associe le controle a la requete + on modifie le type et le sous type de la requete 
                        //if(mapControleEnCours.get(mapCase.get(foyer).Id) == null){
                            
                            Case c = mapCase.get(foyer);
                            controle.Requete__c=c.id;
                            c.type= Label.CAS_Type_ControleBeacon_label;
                            c.Sous_type__c=Label.CAS_Sous_type_AuMoins1BeaconInactif;
                            if(!requeteToUpdate.contains(c)){
                                requeteToUpdate.add(c); 
                            }
                            FoyerPanListId.Add(equipement.Foyer_paneliste__c);
                            listControleWithCaseToInsert.add(controle);
                        //}
                    }else if(!FoyerPanListId.contains(equipement.Foyer_paneliste__c)){
                        // sinon , on cree une nouvelle requete controle AIP
                        listControleWithoutCaseToInsert.add(controle);// on ajoute le controle a cette liste pour pouvoir l'associer a la requete apres son insertion
                        case newCase = new case(RecordTypeId=recordTypeIdRequeteControleAIP,
                                                Foyer_paneliste__c=equipement.Foyer_paneliste__c ,
                                                AccountId=foyer,
                                                Origin=Label.CAS_Origine_Controle,
                                                type=Label.CAS_Type_ControleBeacon_label,
                                                Sous_type__c=Label.CAS_Sous_type_AuMoins1BeaconInactif);
                        FoyerPanListId.Add(equipement.Foyer_paneliste__c);
                        requeteToInsert.add(newCase);
                    }
                    // FIN
                }
                
            }
            //listControleToInsert.add(controle);
        }
        
        // modification AYoub du 11/01/2022 :DEBUT        
        if(listControleWithCaseToInsert!=null && listControleWithCaseToInsert.size()>0){// insert the new cases
            try{ 
                database.insert(listControleWithCaseToInsert);
            }Catch(exception ex){
                errorTxt += 'Erreur durant la création des controles : ' + ex.getMessage() + '\n';
                    containsErrors = true;
                system.debug('Insert controle Exception Error:'+ex.getmessage());
            }
        }
        System.debug('requeteToUpdate: ' + requeteToUpdate);
        if(requeteToUpdate!=null && requeteToUpdate.size()>0){// update cases
            try{ 
                database.update(requeteToUpdate);
            }Catch(exception ex){
                errorTxt += 'Erreur durant la MAJ des requêtes : ' + ex.getMessage() + '\n';
                    containsErrors = true;
                system.debug('Update requete Exception Error:'+ex.getmessage());
            }
        }
        System.debug('requeteToInsert: ' + requeteToInsert);
        if(requeteToInsert!=null && requeteToInsert.size()>0){// insert the new cases
            try{ 
                database.insert(requeteToInsert);
            }Catch(exception ex){
                errorTxt += 'Erreur durant la création des requêtes : ' + ex.getMessage() + '\n';
                    containsErrors = true;
                system.debug('insert requete Exception Error:'+ex.getmessage());
            }
        }
        for(case req : requeteToInsert){
            for(Controle__c con : listControleWithoutCaseToInsert){
                if(con.Foyer_paneliste__c == req.Foyer_paneliste__c){
                    con.Requete__c=req.Id;
                    if(!listControleToInsert.contains(con)){
                        listControleToInsert.add(con);
                    }
                    
                }
            }
        }
        System.debug('listControleToInsert: ' + listControleToInsert);
        if(listControleToInsert!=null && listControleToInsert.size()>0){// insert the new cases
            try{ 
                database.insert(listControleToInsert);
            }Catch(exception ex){
                errorTxt += 'Erreur durant la création des ctrls : ' + ex.getMessage() + '\n';
                    containsErrors = true;
                system.debug('insert controle Exception Error:'+ex.getmessage());
            }
        }
        //FIN
    }
    global void finish(Database.BatchableContext bc){
        //Added for notifications - START
        List<String> toMailAddress = System.Label.BatchNotif_B014_ToAddress.split(';');
        String senderName = Label.BatchNotif_B014_SenderName;
        String subject = Label.BatchNotif_B014_Subject;
        
        String emailBody = 'L\'exécution du batch Batch014_CreateCaseForBattery s\'est terminée.\n';
        if(containsErrors) {
            emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
            emailBody += errorTxt;
        } else {
            emailBody += 'Aucune erreur n\'a été relevée.';
        }
        
        AP01_SendEmail.sendEmail(toMailAddress, senderName, subject, emailBody, null);
        
        //Added for notifications - END
    }
    
}