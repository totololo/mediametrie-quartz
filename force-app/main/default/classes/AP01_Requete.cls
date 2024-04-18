/*
* @author: Joyce Saidy
* @date: 02/09/2020
* @ Description Class that create workOrder on case creation with description "Installation nouveau foyer"
* @TestClass: AP01_Requete_Test
* @Coverage: 95 %
* History
* <Date of modification>   <Author>    <Description of modification>
*       27/09/2021               ER         Corrections faites pour renseigner les champs ajoutés avec les valeurs de ces champs sur le foyer (retour ticket MEDIAMETRIE-261)
* 		28/09/2021   		Claire VEHRLE  		  Clôture des requêtes de type Remplacement de matériel dès la collecte d'audience du nouvel équipement (de remplacement)
*/
public class AP01_Requete {
    
     public static void NouvelleIntervention(List<Case> ListNewCases) {
        List<workOrder> listWOToInsert = new List<workOrder>();
         //Added by ER for MEDIAMETRIE-261 - Start
        List<Case> listCaseDetails = [SELECT Id, AccountId,Foyer_paneliste__c,account.Nombre_TV__c,account.Nombre_pc__c,Account.Territoire_de_service__c, account.Nombre_smartphone__c , account.Nombre_tablette__c 
                                        FROM Case
                                        Where Id in : ListNewCases]; 
        //Added by ER for MEDIAMETRIE-261 - End
        for(Case cs:listCaseDetails ) //Changed by ER for MEDIAMETRIE-261
        {
            workOrder WO = new workOrder();
            WO.AccountId=cs.AccountId;
            WO.CaseId=cs.id;
            WO.ServiceTerritoryId=cs.Account.Territoire_de_service__c;
            WO.Foyer_paneliste__c=cs.Foyer_paneliste__c;
            WO.Type_de_l_intervention__c=Label.WOR_Type_d_intervention_Installation;
            WO.Actions__c=Label.WOR_Sous_type_d_intervention_Nouveau_foyer;  
            WO.Tech_RV03__c=true;
            
            //Added by ER for MEDIAMETRIE-261 - Start
            WO.Nombre_TV__c = Integer.ValueOf(cs.Account.Nombre_TV__c); 
            WO.Nombre_d_ordinateur__c = cs.Account.Nombre_pc__c;
            WO.Nombre_de_smartphone__c = cs.Account.Nombre_smartphone__c;
            WO.Nombre_de_tablette__c = cs .Account.Nombre_tablette__c;
            //Added by ER for MEDIAMETRIE-261 - End
            
            listWOToInsert.add(WO);
        }
        if(listWOToInsert!=null && listWOToInsert.size()>0)
        {
            try{ 
                database.insert(listWOToInsert);
            }Catch(exception ex){
                system.debug('Insert WO Nouveau Foyer Exception Error: '+ex.getmessage());
            }
        }
    }
    
    public static void associerCaseContact(List<Case> ListNewCases){
       
        list<case> listetoupdate = new list<case>();
        list<contact> listeCont = new list<contact>();
        list<account> listeFoy = new list<account>();
        list<String> Casemail= new list<string>();
        /*List<Case> listCaseDetails = [SELECT Id, AccountId, contactid,SuppliedEmail
                                        FROM Case
                                        Where Id in : ListNewCases];*/
        for (case cs:ListNewCases){
            if(!String.isBlank(cs.SuppliedEmail))
            Casemail.add(cs.SuppliedEmail);
        }
        if (Casemail.size()>0){
            listeCont = [select id, email,Lien_parente__c from contact where email in:CaseMail];
        }
            
        System.debug('size'+listeCont.size());
        listeFoy   	= [select id, Adresse_e_mail_principale__c from account where Adresse_e_mail_principale__c in:CaseMail];
        
        for (case cs:ListNewCases){
            list<contact> listeConCase = new list<contact>();
            list<account> listeFoyCase = new list<account>();
            for (contact con:listeCont ){
                if (cs.SuppliedEmail==con.Email){
                    listeConCase.add(con);
                }
            }
            for (account acc:listeFoy){
                if (cs.SuppliedEmail==acc.Adresse_e_mail_principale__c){
                    listeFoyCase.add(acc);
                }
            }
          
          //mapcontact.putall(listeConCase);
          //mapFoyer.putall(listeFoyCase);
            if ( listeConCase.size()>1){
                for (contact c:listeConCase){
                    if(c.Lien_parente__c=='1'){
                        cs.ContactId=c.id;
                        system.debug('test youssef');
                        listetoupdate.add(cs);
                       break;
                    }
                }
            }
            else if (listeFoyCase.size()==0){
                if (listeFoyCase.size()>0){
                    for (account foy:listeFoyCase){
                        	cs.AccountId=foy.id;
                        	system.debug('test2');
                        	listetoupdate.add(cs);
                      		break;
                	}	
                }
            }
            
        }
         system.debug('siz'+listetoupdate.size());
        update(listetoupdate);
    }
    
    public static void clotureRequete() {
        
        List<Id> requeteIdToUpdate = new List<Id>();
        List <Case> requeteToUpdate = new List<Case>();
        Boolean pasEquipement = true;
        
        Map<Id, Boolean> orderProductMap = new Map<Id, Boolean>();
        
        Map<String, OrderItem> produitCommandeList = new Map<String, OrderItem>([SELECT Id, Order.Requete__c, OrderId, 
                                                                                 (SELECT Id, Date_de_premiere_collecte_d_audience__c FROM Equipements__r)
                                                                                 FROM OrderItem WHERE Order.Requete__r.Type = :Label.CAS_Type_Anomalie 
                                                                                 AND Order.Requete__r.Status != :Label.CAS_Statut_Cloture]);
     
        System.debug('produitCommandeList.size(): ' + produitCommandeList.size());
        
        
        for (OrderItem produitCommande :produitCommandeList.values()) {     
            if (!produitCommande.Equipements__r.isEmpty() && produitCommande.Equipements__r.size() != 0) {      
            	requeteIdToUpdate.add(produitCommande.Order.Requete__c);     
                if(orderProductMap.containsKey(produitCommande.OrderId)) {
                    if (produitCommande.Equipements__r[0].Date_de_premiere_collecte_d_audience__c == null) {
                        orderProductMap.put(produitCommande.OrderId, false);
                    }
                }
                else {
                    if (produitCommande.Equipements__r[0].Date_de_premiere_collecte_d_audience__c == null) {
                        orderProductMap.put(produitCommande.OrderId, false);
                    }
                    else {
                        orderProductMap.put(produitCommande.OrderId, true);
                    }
                }
                pasEquipement = false;
            }
        }
        
        if (!pasEquipement) {
            requeteToUpdate = [SELECT Id, Subject, Status,(SELECT Id FROM Commandes__r) FROM Case WHERE Id IN :requeteIdToUpdate];
            
            for (Case requete:requeteToUpdate) {
                Boolean allOrderOk = true;    
                for (Order commande: requete.Commandes__r) {
                    try {
                        if(!orderProductMap.get(commande.Id)) {
                            allOrderOk = false;
                        }
                        if(allOrderOk) {
                            requete.Status = Label.CAS_Statut_Cloture;
                        }
                    } catch (exception ex) {
                        system.debug('Error: ' + ex.getmessage() + '\n Originine possible: Les produits commandés ne sont ratachés à aucun équipement de mesure');
                    }
                } 
                
                
            }
            
            update requeteToUpdate;
        }
       
    }
   
}