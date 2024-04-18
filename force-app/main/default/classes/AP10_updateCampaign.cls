/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 10-27-2022
 * @last modified by  : Anes BOUZOUINA
**/
public without sharing class AP10_updateCampaign {
    
    @AuraEnabled
    public static void  updateListView(list<sobject> objectlst,string Queue){
        system.debug('objectlst '+objectlst);
         system.debug('Queue '+Queue);
         //Relation 1 to N between campaign and listView_field_ 
         String queryCampaign= 'SELECT id,Ids_des_vues_de_liste__c from campaign where CampagneID_Avaya__c =:Queue limit 1';
         list<Campaign> campaignLst =  Database.query(queryCampaign);
         system.debug('campaignLst '+campaignLst);
         if(campaignLst.size()>0 ){
            System.debug('inside the if');
           // String idListView='';
            // for(sobject sobjectItr : objectlst){
            //     idListView += ','+sobjectItr.Id;
            // }

            System.debug('campaignLst[0].Ids_des_vues_de_liste__c'+campaignLst[0].Ids_des_vues_de_liste__c );
            //if the field is empty so fill with the new list ( avoid a null value with string...)

          
                for(sobject sobjectItr : objectlst){
                    if(campaignLst[0].Ids_des_vues_de_liste__c == null || campaignLst[0].Ids_des_vues_de_liste__c == ''){
                        campaignLst[0].Ids_des_vues_de_liste__c = sobjectItr.Id;
                    }
                    else if(!campaignLst[0].Ids_des_vues_de_liste__c.contains(sobjectItr.Id) ) {
                        campaignLst[0].Ids_des_vues_de_liste__c = campaignLst[0].Ids_des_vues_de_liste__c + ','+sobjectItr.Id ;
                    }

                }
            
           // campaignLst[0].Ids_des_vues_de_liste__c == null ?  : campaignLst[0].Ids_des_vues_de_liste__c += idListView;          
            System.debug('campaignLst[0].Ids_des_vues_de_liste__c'+campaignLst[0].Ids_des_vues_de_liste__c );
            update campaignLst;
         }

    }
}