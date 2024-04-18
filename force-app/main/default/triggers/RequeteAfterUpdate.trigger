/*
* @date: 08/07/2021
* @ Description trigger se declenche apres la modification de la requette pou
* @version 1.00   
* @Auteur Ayoub Ghammaz EIT
History
* <Date of modification> 	<Author> 			<Description of modification>
*	08/03/2022			 	Ayoub Ghammaz		appeller la classe AP02_Requete 
*/
trigger RequeteAfterUpdate on Case (After update) {
    /* if(PAD.canTrigger('AP01_Commande')){
List<Case> requeteToUpdate= new List<Case>();
List<Id> ListFoyerPanId = new List<Id>();
for(Case cs : Trigger.new){
if(cs.Chute_confirmee__c && cs.Chute_confirmee__c != trigger.oldMap.get(cs.Id).Chute_confirmee__c
&& cs.Type==Label.Cas_Type_DemandeChute){// si le chute est definitive => creer une commande de chute et chuter le foyer paneliste
requeteToUpdate.add(cs);
ListFoyerPanId.add(cs.Foyer_paneliste__c);
}
}
if(requeteToUpdate.size()>0 && requeteToUpdate!=null){// creer commande de chute
//AP01_Commande.creerCommandeChute(requeteToUpdate);
}
if(ListFoyerPanId.size()>0 && ListFoyerPanId!=null){// chuter paneliste
system.debug('$$$ in requeteAfterUpdate FoyerPAnelisteChute');
// AP04_FoyerPaneliste.FoyerPAnelisteChute(ListFoyerPanId);  
}
}*/
    
    // modification du 08/03/2022 : ghammaz : debut
    if(PAD.canTrigger('AP02_Requete')){
        list<Case> ListRequeteEnfant = new List<Case>();
        list<Case> ListRequeteParent = new List<Case>();
        List<Id> foyerPanIds = new List<Id>();
        for(case cas : Trigger.New){
            if(cas.status != Trigger.OldMap.get(cas.id).status && /*cas.status == Label.CAS_Statut_Cloture*/(cas.status !='Nouveau' || cas.status !='En cours') ){
                
                if(cas.ParentId!= null){
                    ListRequeteEnfant.add(cas);
                }else{
                    if(cas.Foyer_paneliste__c != null){
                        foyerPanIds.add(cas.Foyer_paneliste__c);
                        ListRequeteParent.add(cas);
                    }
                }
            }
        }
        if(ListRequeteEnfant.size() > 0 && ListRequeteEnfant != null){
            AP02_Requete.ClotureRequeteEnfant(ListRequeteEnfant);
        }
        if(ListRequeteParent.size() > 0 && ListRequeteParent != null){
            AP02_Requete.ClotureRequeteParent(ListRequeteParent,foyerPanIds);
        }
    }
    // fin
    if(PAD.canTrigger('AP09_WebService_Avaya')){
        String tryId;
        for( Case caseItr : Trigger.new){
            system.debug('this.oldMap.get(caseItr.Id).qualificationCase__c '+Trigger.OldMap.get(caseItr.Id).qualificationCase__c);
            system.debug('caseItr.qualificationCase__c   ' + caseItr.qualificationCase__c  );
            
            if( Trigger.OldMap.get(caseItr.Id).qualificationCase__c   != caseItr.qualificationCase__c   ){
                if(caseItr.Avaya_UUI_tech__c !=null && caseItr.Avaya_UUI_tech__c !=''){
                    tryId = caseItr.Avaya_UUI_tech__c .substringAfter('|');}
                else{
                    List<Account> acc=[select id,Avaya_UUI_tech__c from account where id =: caseItr.accountId limit 1 ];
                    tryId =acc[0].Avaya_UUI_tech__c .substringAfter('|');
                }
                system.debug('tryId=  '+tryId) ;
                system.debug('caseItr.qualificationCase__c=  '+caseItr.qualificationCase__c);
                AP09_WebService_Avaya.QualifyTry(tryId ,caseItr.qualificationCase__c);
            }
        }
    }
    /* if(PAD.canTrigger('AP02_Commande')) {
List<Case> listCaseToSend = new List<Case>();
for(Case c : Trigger.new){
if(c.Chute_confirmee__c == true && Trigger.OldMap.get(c.id).Chute_confirmee__c == false && c.Status==label.CAS_Type_Chute){
listCaseToSend.add(c);
}
}
AP02_Commande.sendOrderChuteTriggerAfterUpdate(listCaseToSend);
}*/
}