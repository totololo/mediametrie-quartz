@isTest
public class DeleteLVfromCampaign_Test {
    @isTest
    static void testDeleteLVfromCampaign() {
               Campaign cam = test_Utils.createCampaign();
        cam.File_d_attente__c='PRM-Groupe-1';
        cam.Ids_des_vues_de_liste__c='00B0Q000002i7jlUAA,00B3X00000D2rF9UAJ';
        cam.CampagneID_Avaya__c='PRM-Groupe-1';
        insert cam ; 
        cam.Ids_des_vues_de_liste__c+=','+cam.Id;
        update cam;
        Campaign campaign = new campaign(CampagneID_Avaya__c='PRM-Groupe-1',Name='Anes Test2');
      //  insert campaign;
        list<Campaign> camLst= new list<Campaign>();
        camLst.add(cam);
        //camLst.add(campaign);
        
        DeleteLVfromCampaign.DeleteLVfromCampaign(camLst,'PRM-Groupe-1');
    }
}