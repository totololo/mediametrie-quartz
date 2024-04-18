/*
* @author: Ayoub GHAMMAZ
* @date: 08/03/2022
* @ Description: -Si une requête est créé , nous la rattachons a la requête principale ( methode : attacheARequetePrincipale )
-Si la requête enfant est clôturée, elle sera détachée de la requête parent ( methode : ClotureRequeteEnfant  )
-Si la requête parent est clôturée, toutes les requêtes seront attachées à la nouvelle requeté parent (la requête ouverte et la plus ancienne) ( methode :  )
* @TestClass: AP02_Requete_Test
* @Coverage: 93%
* History
* <Date of modification>   		<Author>   		 <Description of modification>
* */
public class AP02_Requete {
    
    public static void attacheARequetePrincipale(list<Case> caseList){
        List<Id> foyerPanIds = new List<Id>();
        List<Case> ListCaseToUpdate = new list<case>();
        For(Case cas :caseList ){
            foyerPanIds.add(cas.Foyer_paneliste__c);
        }
        //La >> mettre dans la query egale à nouveau, en cours au lieux de différent de close 
        Map<String,Foyer_paneliste__c> mapFoyerPan = new Map<String,Foyer_paneliste__c>([select id , name ,
                                                                                         (select id , status , type ,CreatedDate from Requetes__r where /*status!=:Label.CAS_Statut_Cloture*/status ='Nouveau' OR status='En cours' order by CreatedDate asc limit 1 )
                                                                                         from foyer_paneliste__c where id IN :foyerPanIds]);// map foyer panelist : recuperer la requete ouverte la plus ancienne avec le champs CreatedDate 
        for(Case cas :caseList){
            if(cas.Foyer_paneliste__c != null) {
                if(mapFoyerPan.get(cas.Foyer_paneliste__c).Requetes__r.size() > 0 && cas.id !=mapFoyerPan.get(cas.Foyer_paneliste__c).Requetes__r[0].id){
                System.debug('parent'+mapFoyerPan.get(cas.Foyer_paneliste__c).Requetes__r[0]);
                    Case newCase = new Case(id=cas.id);// je cree une requete car le trigger est after insert et ici on modifie la valeur
					//LA
                    if(newCase.ParentId == null){
                    newCase.ParentId = mapFoyerPan.get(cas.Foyer_paneliste__c).Requetes__r[0].id;
                        }                    
                    ListCaseToUpdate.add(newCase);  
                }
            }
            
            
        }
        System.debug('requeteToUpdate: ' + ListCaseToUpdate);
        if(ListCaseToUpdate!=null && ListCaseToUpdate.size()>0){// update cases
            try{ 
                database.update(ListCaseToUpdate);
            }Catch(exception ex){
                system.debug('AP02_Requete Update requete Exception Error:'+ex.getmessage());
            }
        }
    }
    public static void ClotureRequeteParent(List<Case> listCase , list<Id> listFoyerPanIds){
        List<Case> ListCaseToUpdate = new list<case>();
        //La >> mettre dans les 2 query egale à nouveau, en cours au lieux de différent de close
        Map<String,Foyer_paneliste__c> mapFoyerPan = new Map<String,Foyer_paneliste__c>([select id , name ,
                                                                                         (select id , status , type ,CreatedDate from Requetes__r where status ='Nouveau' OR status='En cours' /*status!=:Label.CAS_Statut_Cloture*/ order by CreatedDate asc limit 1 )
                                                                                         from foyer_paneliste__c where id IN :listFoyerPanIds]);// map foyer panelist : recuperer la requete ouverte la plus ancienne avec le champs CreatedDate
        for(Case cas :[select id, status , ParentId,Foyer_paneliste__c from case where (status ='Nouveau' OR status='En cours') /*status!=:Label.CAS_Statut_Cloture*/ and Foyer_paneliste__c IN :listFoyerPanIds]){
            if(mapFoyerPan.get(cas.Foyer_paneliste__c).Requetes__r.size() > 0 && cas.id !=mapFoyerPan.get(cas.Foyer_paneliste__c).Requetes__r[0].id ){
                System.debug('parent'+mapFoyerPan.get(cas.Foyer_paneliste__c).Requetes__r[0]);
                Case newCase = new Case(id=cas.id);// je cree une requete car le trigger est after insert et ici on modifie la valeur
                newCase.ParentId = mapFoyerPan.get(cas.Foyer_paneliste__c).Requetes__r[0].id;
                ListCaseToUpdate.add(newCase);  
            }else if(mapFoyerPan.get(cas.Foyer_paneliste__c).Requetes__r.size() > 0 && cas.id ==mapFoyerPan.get(cas.Foyer_paneliste__c).Requetes__r[0].id ){
                Case newCase = new Case(id=cas.id);
                newCase.ParentId = null;
                ListCaseToUpdate.add(newCase);
            }
        }
        System.debug('requeteToUpdate: ' + ListCaseToUpdate);
        if(ListCaseToUpdate!=null && ListCaseToUpdate.size()>0){// update cases
            try{ 
                database.update(ListCaseToUpdate);
            }Catch(exception ex){
                system.debug('AP02_Requete Update requete Exception Error:'+ex.getmessage());
            }
        }
    }
    
    public static void ClotureRequeteEnfant(List<Case> listCase){
        List<Case> ListCaseToUpdate = new list<case>();
        for(Case cas : listCase){
            Case newCase = new Case(id=cas.id);
            newCase.ParentId = null;
            ListCaseToUpdate.add(newCase);
        }
        System.debug('requeteToUpdate: ' + ListCaseToUpdate);
        if(ListCaseToUpdate!=null && ListCaseToUpdate.size()>0){// update cases
            try{ 
                database.update(ListCaseToUpdate);
            }Catch(exception ex){
                system.debug('AP02_Requete Update requete Exception Error:'+ex.getmessage());
            }
        }
    }
    
}