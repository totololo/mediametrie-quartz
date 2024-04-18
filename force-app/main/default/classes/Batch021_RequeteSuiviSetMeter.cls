/*
* @author: Ayoub GHAMMAZ
* @date: 25/02/2022
* @ Description: - on cree une requete de type controle AIp apres 1 jours de la création d'un contrele de type non repondant et sous type absence collecte
				 - on cloture automatiquement apres 12 jours de la creation du controle ( 11 jours apres la creation de ma requete)
* @TestClass: Batch021_RequeteSuiviSetMeter_Test
* @Coverage: 93%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* 13-01-2023                    Mikael			Date_de_controle__c = Today or yesterday ---> CreatedDate = Today
*                                               modification effectuee afin de se conformer au fonctionnement en place sur les case non repondant pager
* 20-04-2023                   Mikael           On souhaite créer un case de type Non répondant SetMeter lorsque un ctr sur un type de matériel setmeter 
                                                est créé et qu’il n’existe pas de case de type non répondant setmeter.

                                                Si il existe un case de type Non répondant setmeter et que l’on a un nouveau ctrl sur un type de matériel 
                                                setmeter on souhaite associé ce ctrl au case déjà ouvert.
*/
global class Batch021_RequeteSuiviSetMeter implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    //Added for email notification - START
  global String errorTxt = '';
  global Boolean containsErrors = false;
  //Added for email notification - END
  //
  
  global List<Controle__c> start(Database.BatchableContext bc) {
      Id recordTypeIdControleControleAIP = Schema.SObjectType.Controle__c.getRecordTypeInfosByName().get(Label.CTRL_RecordType_ControleAIP).getRecordTypeId();
      
      //label de precodage a prendre
       List<String> libelleList = new List<String>{Label.CTRL_LibellePrecodage_Dimanche ,Label.CTRL_LibellePrecodage_JourFerie ,Label.CTRL_LibellePrecodage_Appel_Hier};
           
   
          
      List<Controle__c> controlList = [SELECT id ,Libelle_de_pre_codage__c,CreatedDate,Type_de_controle__c ,Sous_type_de_controle__c,Date_de_controle__c, Foyer_paneliste__c,Foyer__c ,
                                              Requete__c, Requete__r.type,Requete__r.Sous_type__c, Requete__r.Status, Audimetre__r.Type_de_materiel__c
                                       FROM Controle__c 
                                       WHERE Foyer_paneliste__r.Suspendu__c= False 
                                       	AND Foyer_paneliste__r.Statut_Foyer_paneliste__c != :Label.PAN_Statut_Panel_Chute_temporaire
                                        AND Type_de_controle__c=:Label.CTRL_Type_NonRepondant
                                       	AND (
                                             (
                                               (Requete__r.Status != :Label.CAS_Statut_Cloture OR Requete__c = null)
                                               //AND Sous_type_de_controle__c=:Label.CTRL_SousType_AbsenceCollecte
                                               AND Libelle_de_pre_codage__c = null
                                               AND RecordtypeId = :recordTypeIdControleControleAIP
                                               AND Audimetre__r.Type_de_materiel__c=:Label.ASS_TypeMateriel_Setmeter
                                               AND CreatedDate = TODAY
                                             )
                                       		//Mikael TMASF-144
                                           OR (
                                               RecordTypeId =:recordTypeIdControleControleAIP
                                               AND Statut__c = :Label.CTRL_Statut_Precode
                                               AND Requete__c = null and Foyer__r.Single_source__c=false 
                                               AND Libelle_de_pre_codage__c IN :libelleList
                                               AND CreatedDate = today
                                               AND Audimetre__r.Type_de_materiel__c =:Label.ASS_TypeMateriel_Setmeter
                                          	 )
                                       	)];
      return controlList;
  }

  global void execute(Database.BatchableContext bc, List<Controle__c> scope){
      System.debug('***scope: ' + scope);
      
      Id recordTypeIdRequeteControleAIP = Schema.SObjectType.Case.getRecordTypeInfosByName().get(Label.CAS_Recordtype_ControleAIP).getRecordTypeId();
      List<Case> casesToInsert = new List<Case>();
      //List<Case> casesToUpdate = new List<Case>();
      Map<id,Case> casesToUpdateMap=new Map<id,Case>();
      List<Controle__c> listControleToUpdate=new List<Controle__c>();
      Set<Id> foyerPanelisteIdList = new Set<Id>();
      Set<Id> foyerIdList = new Set<Id>();
      map<Controle__c,Case> mapControlRequeteToUpdate=new map<Controle__c,Case>();
      List<Controle__c> controleToUpdateRequeteList = new List<Controle__c>();
      Map<Id, List<Controle__c>> foyerPanelisteControleMap = new Map<Id, List<Controle__c>>();


      for(Controle__c controle:scope) {
          foyerPanelisteIdList.add(controle.Foyer_paneliste__c);
			foyerIdList.add(controle.Foyer__c);
          if(foyerPanelisteControleMap.containsKey(controle.Foyer_paneliste__c)) {
              foyerPanelisteControleMap.get(controle.Foyer_paneliste__c).add(controle);
          }
          else {
              foyerPanelisteControleMap.put(controle.Foyer_paneliste__c, new List<Controle__c>{controle});
          }
      }
	

      Map<Id, List<Case>> foyerPanCaseMap = new Map<Id, List<Case>>();
       List<Case> foyerPanCaseList = [SELECT id,Foyer_paneliste__c,Status  FROM Case
                                 WHERE (Status = :Label.CAS_Statut_Nouveau OR Status = :Label.CAS_Statut_En_cours OR Status= : Label.CAS_Status_Traite) AND  Type=:Label.CAS_Type_NonRepondantSetMeter 
                                 AND Foyer_paneliste__c IN :foyerPanelisteIdList];
      system.debug('foyerpancaselist '+foyerPanCaseList);
      //TMASF-144 to be inserted here //mikael////////////////
      for(Case c:foyerPanCaseList) {
          if(foyerPanCaseMap.containsKey(c.Foyer_paneliste__c)) {
              foyerPanCaseMap.get(c.Foyer_paneliste__c).add(c);
          }
          else {
              foyerPanCaseMap.put(c.Foyer_paneliste__c, new List<Case>{c});
          }
      }

      for(Controle__c controle:scope) {            
          	//check to see if a case already exist 
              if(foyerPanCaseMap.get(controle.Foyer_Paneliste__c)?.isEmpty() == false){
                Case oldCase=foyerPanCaseMap.get(controle.Foyer_Paneliste__c)[0];
                  controle.Requete__c=oldCase.id;
                  if(oldCase.Status== Label.CAS_Status_Traite){
                        oldCase.Status=Label.CAS_Statut_Nouveau;
                    }
                  //casesToUpdate.add(oldCase);
                  casesToUpdateMap.put(oldCase.id, oldCase);
                  listControleToUpdate.add(controle);
                  mapControlRequeteToUpdate.put(controle,oldCase);
            	}
                else if (controle.Libelle_de_pre_codage__c==null){
                   Case newCase = new Case();
                  newCase.RecordTypeId = recordTypeIdRequeteControleAIP;
                  newCase.Foyer_paneliste__c = controle.Foyer_paneliste__c;
                  newCase.AccountId = controle.Foyer__c;
                  newCase.Origin = Label.CAS_Origine_Controle;
                  newCase.type = Label.CAS_Type_NonRepondantSetMeter;
                  newCase.Sous_type__c = Label.CAS_Sous_type_Absence_Collecte;
                  newCase.Type_de_controle__c = controle.Type_de_controle__c;
                  newCase.Sous_type_de_controle__c = controle.Sous_type_de_controle__c;
                  casesToInsert.add(newCase);
                    //add the new created case to the map to take to concideration new controle case 
                  if(foyerPanCaseMap.containsKey(newCase.Foyer_paneliste__c)) {
              				foyerPanCaseMap.get(newCase.Foyer_paneliste__c).add(newCase);
                      }
                      else {
                          foyerPanCaseMap.put(newCase.Foyer_paneliste__c, new List<Case>{newCase});
                      } 
                  //mikael
                  mapControlRequeteToUpdate.put(controle,newCase); 
                }
          //}
      }
      system.debug('foyerPanCaseMap '+foyerPanCaseMap);
      system.debug('mapControlRequeteToUpdate '+mapControlRequeteToUpdate);
      System.debug('requeteToInsert: ' + casesToInsert);
      if(casesToInsert != null && casesToInsert.size() > 0){
          try{ 
              database.insert(casesToInsert);
          }Catch(exception ex){    
               errorTxt += 'Erreur durant la Création des requêtes : ' + ex.getMessage() + '\n';
              containsErrors = true;
          }
      }
      
      System.debug('casesToUpdateMap: ' + casesToUpdateMap);
      if(!casesToUpdateMap.isEmpty()){
          try{ 
              database.update(casesToUpdateMap.values(), false);
          }Catch(exception ex){    
               errorTxt += 'Erreur durant l\'Update des requêtes : ' + ex.getMessage() + '\n';
              containsErrors = true;
          }
      }


      //Mikael
      
      if(!mapControlRequeteToUpdate.isEmpty()){
          for(Controle__c c:mapControlRequeteToUpdate.keySet()){
              if(c.Requete__c==null){
                  
                  c.Requete__c=mapControlRequeteToUpdate.get(c).Id;
              	  listControleToUpdate.add(c);
              }
              /* c.Requete__c=mapControlRequeteToUpdate.get(c).Id;
              listControleToUpdate.add(c);*/
          }
      }

      Set<Controle__c> myset = new Set<Controle__c>();
	  List<Controle__c> listControleToUpdateNoDuplicates = new List<Controle__c>();
	   myset.addAll(listControleToUpdate);
	   listControleToUpdateNoDuplicates.addAll(myset);
      if(listControleToUpdateNoDuplicates != null && listControleToUpdateNoDuplicates.size() > 0) {
          try{ 
              database.update(listControleToUpdateNoDuplicates);
          }Catch(exception ex){
               errorTxt += 'Erreur durant la mise à jour des Ctrls : ' + ex.getMessage() + '\n';
              containsErrors = true;
          }
      }
      
      
  }
   global void finish(Database.BatchableContext bc){
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      List<String> toMailAddress = System.Label.BatchNotif_B021_ToAddress.split(';');
      
      mail.setToAddresses(toMailAddress);
      mail.setSenderDisplayName(System.Label.BatchNotif_B021_SenderName);
      mail.setSubject(System.Label.BatchNotif_B021_Subject+'-'+date.today().format());
      
      String emailBody = 'L\'exécution du batch Batch021_RequeteSuiviSetMeter s\'est terminée.\n';
      if(containsErrors) {
          emailBody += 'Les erreurs suivantes ont été rencontrées :\n\n';
          emailBody += errorTxt;
      } else {
          emailBody += 'Aucune erreur n\'a été relevée.';
      }
      mail.setPlainTextBody(emailBody);
      
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  }

}