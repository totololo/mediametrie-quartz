public with sharing class getRecordCampaign {
 //@AuraEnabled is annotation enables LWC to access below apex method
 //(cacheable=true) is for caching the data on client side storage without 
 @AuraEnabled(cacheable=true)
  public static List<Campaign> getCampaigns() {
  return [select id,name,CampagneID_Avaya__c  from campaign order by name  desc];
  }
}