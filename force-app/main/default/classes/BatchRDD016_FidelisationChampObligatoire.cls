/*
* @author: Mikael Chaaya
* @date: 31/05/2023
* @ Description Batch pour la RDD de l'objet Fidelisation pour remplire les champ Individu paneliste et Composition Foyer :
		si Composition_foyer__c = null and Individu_paneliste__c = null 
			=> Reprendre les id de la PDR
		si Composition_foyer__c = null and Individu_paneliste__c <> null 
			=> Reprendre l’id Composition_foyer__c correspondant à l’Individu_paneliste__c / Composition_foyer__c = Individu_paneliste__r.Composition_foyer__c
		si Composition_foyer__c <> null and Individu_paneliste__c = null 
			=> Reprendre l’id Individu_paneliste__c correspondant à l’id Composition_foyer__c / Individu_paneliste__c = Select id from Individu_paneliste__c where Composition_foyer__c = Composition_foyer__c
* @TestClass: BatchRDD016_FidelisationChampOblTest
* @Coverage: 96%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD016_FidelisationChampObligatoire implements Database.Batchable<sObject>{

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String refPanelAIP=Label.RFP_Nom_AIP;
            return Database.getQueryLocator([SELECT Id, Foyer__c, Foyer__r.Personne_de_reference__c,Foyer__r.Personne_de_reference__r.AccountId, Foyer_Paneliste__c,Composition_du_foyer__c,
                                                     Foyer_paneliste__r.Referentiel_Panel__r.Name,Individu_paneliste__c, Individu_paneliste__r.Date_de_chute_de_l_individu__c ,
                                                     Individu_paneliste__r.Composition_du_foyer__c,Composition_du_foyer__r.AccountId
                                             FROM Fidelisation__c 
                                             WHERE ((Composition_du_foyer__c=null
                                                     AND 
                                                    Individu_paneliste__c<>null
                                                    AND
                                                    Individu_paneliste__r.Date_de_chute_de_l_individu__c=null
                                                      )
                                                 OR(Composition_du_foyer__c<>null
                                                     AND 
                                                    Individu_paneliste__c=null
                                                    AND 
                                                    Composition_du_foyer__r.AccountId <>null
                                                  )
                                                 OR(Composition_du_foyer__c=null
                                                   AND Individu_paneliste__c=null
                                                   AND Foyer__r.Personne_de_reference__c<> null
                                                  )
                                                OR(Composition_du_foyer__c=null
                                                   AND Individu_paneliste__c=null
                                                   AND Foyer_paneliste__r.Referentiel_Panel__r.Name=:refPanelAIP
                                                  )
                                                )
                                                  AND  Foyer__r.Name<>'Foyer anonymisé'
                                                  AND Foyer__r.Date_de_chute__c =null
                                                  AND Foyer__r.Personne_de_reference__r.AccountId <>null
    
                                            ]);
     
        }
        
        public void execute(Database.BatchableContext bc, List<Fidelisation__c> scope) {
            
           //Map<Id, Account> foyerMap = new Map<Id, Account>();
            Set<Id> contactIdSet=new Set<Id>();
            Set<Id> fpIdSet=new Set<Id>();
            String refPanelAIP=Label.RFP_Nom_AIP;
            List<Fidelisation__c> fidToUpdate = new List<Fidelisation__c>();
            Map<Id,Individu_paneliste__c> contactIdToIndivPanMap=new Map<Id,Individu_paneliste__c>();
            Map<Id,Individu_paneliste__c> fpIdToIndivPanMap=new Map<Id,Individu_paneliste__c>();
            for(Fidelisation__c f: scope) {
                contactIdSet.add(f.Foyer__r.Personne_de_reference__c);
                contactIdSet.add(f.Composition_du_foyer__c);
                System.debug('MM');
                System.debug(f.Foyer_paneliste__r.Referentiel_Panel__r.Name);
                System.debug(refPanelAIP);
                if(f.Foyer_paneliste__r.Referentiel_Panel__r.Name.contains(refPanelAIP)){
                    fpIdSet.add(f.Foyer_paneliste__c); 
                }    
            }
            
            List<Individu_paneliste__c> individuList = [SELECT Id,Foyer_paneliste__c, Composition_du_foyer__c,Date_de_chute_de_l_individu__c
                                                        FROM Individu_paneliste__c
                                                        WHERE Composition_du_foyer__c IN :contactIdSet
                                                            OR Foyer_paneliste__c IN :fpIdSet
                                                       ];
            for(Individu_paneliste__c ind : individuList){
                if(fpIdSet.contains(ind.Foyer_paneliste__c))
                {
                    fpIdToIndivPanMap.put(ind.Foyer_paneliste__c, ind);
                }
                else{
                    contactIdToIndivPanMap.put(ind.Composition_du_foyer__c, ind);
                }
                
            }
            
            
            for(Fidelisation__c f: scope) {
                if (f.Composition_du_foyer__c == null && f.Individu_paneliste__c==null) { 
                    if(f.Foyer_paneliste__r.Referentiel_Panel__r.Name==refPanelAIP){
                        //f.Composition_du_foyer__c=f.Foyer__r.Personne_de_reference__c;
                        f.Individu_paneliste__c=fpIdToIndivPanMap.get(f.Foyer_paneliste__c)?.Id;
                        f.Composition_du_foyer__c=fpIdToIndivPanMap.get(f.Foyer_paneliste__c)?.Composition_du_foyer__c;
                        fidToUpdate.add(f);
                    }
                    else{
                        f.Composition_du_foyer__c=f.Foyer__r.Personne_de_reference__c;
                        f.Individu_paneliste__c=contactIdToIndivPanMap.get(f.Foyer__r.Personne_de_reference__c)?.Id;
                        fidToUpdate.add(f);
                    }
                }
                else if(f.Composition_du_foyer__c == null && f.Individu_paneliste__c!=null){
                    if( f.Individu_paneliste__r.Date_de_chute_de_l_individu__c==null)
                    {
                        f.Composition_du_foyer__c=f.Individu_paneliste__r.Composition_du_foyer__c;
                        fidToUpdate.add(f);
                    }        
                }
                 else if(f.Composition_du_foyer__c != null && f.Individu_paneliste__c==null){
                    
                    if(contactIdToIndivPanMap.get(f.Composition_du_foyer__c)?.Date_de_chute_de_l_individu__c==null){
                        f.Individu_paneliste__c=contactIdToIndivPanMap.get(f.Composition_du_foyer__c)?.Id;
                        fidToUpdate.add(f);
                    }
                     
                }
            }
            
            if(scope.size() > 0 && scope != null) {
                try{ 
                    update fidToUpdate;
                }Catch(exception ex){
                    system.debug('RDD016 Update Fidelisation Exception Error:' + ex.getmessage());
                }
            }
        }
        
        public void finish(Database.BatchableContext bc) {
            
        }    
        
    }