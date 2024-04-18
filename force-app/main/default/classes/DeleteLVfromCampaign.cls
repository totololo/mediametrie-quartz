/**
 * @description       : 
 * @author            : Anes BOUZOUINA
 * @group             : 
 * @last modified on  : 10-20-2022
 * @last modified by  : Anes BOUZOUINA
**/
public with sharing class DeleteLVfromCampaign {
    @auraEnabled
    public static void DeleteLVfromCampaign(list<sobject> objectlst,string Queue) {
        system.debug('objectlst in DeleteLVfromCampaign'+objectlst);
        system.debug('Queue '+Queue);
        //Relation 1 to N between campaign and listView_field_ 
        String queryCampaign= 'SELECT id,Ids_des_vues_de_liste__c,File_d_attente__c from campaign where CampagneID_Avaya__c =:Queue limit 1';
        list<Campaign> campaignLst =  Database.query(queryCampaign);
        system.debug('campaignLst '+campaignLst);
        if(campaignLst.size()>0 ){

            System.debug('campaignLst[0].Ids_des_vues_de_liste__c'+campaignLst[0].Ids_des_vues_de_liste__c );
           //if the field is empty so fill with the new list ( avoid a null value with string...)

         
               for(sobject sobjectItr : objectlst){
                if((campaignLst[0].Ids_des_vues_de_liste__c).contains(sobjectItr.Id)) 
                {
                    // system.Debug('inside the if');
                    // System.debug('campaignLst[0].Ids_des_vues_de_liste__c) '+campaignLst[0].Ids_des_vues_de_liste__c);
                    String str = (campaignLst[0].Ids_des_vues_de_liste__c.remove(string.valueof(sobjectItr.Id))).replace(',,',',');
                    campaignLst[0].Ids_des_vues_de_liste__c= str.removeStart(',');
                    System.debug('str '+str);
                }

               }
           
          // campaignLst[0].Ids_des_vues_de_liste__c == null ?  : campaignLst[0].Ids_des_vues_de_liste__c += idListView;          
           System.debug('campaignLst[0].Ids_des_vues_de_liste__c'+campaignLst[0].Ids_des_vues_de_liste__c );
           update campaignLst[0];
    }
}
}