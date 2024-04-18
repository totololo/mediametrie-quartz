/**
* @description       : 
* @author            : Anes BOUZOUINA
* @group             : 
* @last modified on  : 10-20-2022
* @last modified by  : Anes BOUZOUINA
**/
@istest
public with sharing class GetListsViews_Test {
    @istest 
    public static void GetListsViews_Test() {
        campaign cam = test_utils.createCampaign();
        cam.File_d_attente__c='PRM-Groupe-4';
        cam.Ids_des_vues_de_liste__c='00B0Q000002i7jlUAA,00B3X00000D2rF9UAJ';
        cam.CampagneID_Avaya__c='PRM-Groupe-4';
        
        insert cam;
        GetListsViews.GetListsViews('PRM-Groupe-4','Account');
                GetListsViews.GetListsViews('PRM-Groupe-3','Account');

    }
}