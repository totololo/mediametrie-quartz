/*
* @Auteur Marliatou D.
* @date: 30/01/2023
* @Classe: BatchRDD14_RemplirEquipementAction
* @Coverage: 100%
* History
* <Date of modification>   		<Author>    		<Description of modification>
*/
@isTest
public class BatchRDD14_RemplirEquipementAction_Test { 

    @isTest
    Static void RDD_ActionEquipement() {
            
        Id recordTypeIdPosteEquipementFoyer = Schema.SObjectType.Equipements_du_foyer__c.getRecordTypeInfosByName().get(Label.EQPF_RecordType_PosteTV).getRecordTypeId();
        
        List<Account> foyerList = new List<Account>();
        Account foyer1 = Test_Utils.createFoyer();
        foyer1.Name = 'Foyer 1';
        foyer1.Numero_de_portable__c = '0723000021';
        foyerList.add(foyer1);
        insert foyerList;
        
        List<Referentiel_Panel__c> referentielPanelToInsert = new List<Referentiel_Panel__c>();
        Referentiel_Panel__c refPanMMAT = new Referentiel_Panel__c();
        refPanMMAT.Name = 'MMAT';
        refPanMMAT.Type_de_panel__c = Label.RFP_TypePanel_MMAT;
        referentielPanelToInsert.add(refPanMMAT);
        insert referentielPanelToInsert;
        
        List<Foyer_Paneliste__c> foyerPanelisteToInsert = new List<Foyer_Paneliste__c>();
        Foyer_Paneliste__c foyerPanelisteMMAT = new Foyer_Paneliste__c();
        foyerPanelisteMMAT.Name = 'FP MMAT';
        foyerPanelisteMMAT.Foyer__c = foyer1.Id;
        foyerPanelisteMMAT.Foyer_equipe__c = true;
        foyerPanelisteMMAT.Statut_Foyer_paneliste__c = Label.PAN_Statut_panel;
        foyerPanelisteMMAT.Referentiel_Panel__c = refPanMMAT.Id;
        foyerPanelisteToInsert.add(foyerPanelisteMMAT);
        insert foyerPanelisteToInsert;
               
        List<Asset> assetList = new List<Asset>();
        Asset asset1 = new Asset();
        asset1.AccountId = foyer1.Id;
        asset1.Foyer_paneliste__c = foyerPanelisteMMAT.Id;
        asset1.Poste_ExtId_SIPanel__c = '1234';
        asset1.Name='123';
        assetList.add(asset1);
        //
        insert assetList;
        
        List<Equipements_du_foyer__c> listEquiFoyer = new List<Equipements_du_foyer__c>();
        Equipements_du_foyer__c equiFoyer = new Equipements_du_foyer__c();
        equiFoyer.RecordTypeId = recordTypeIdPosteEquipementFoyer;
        equiFoyer.Foyer__c = foyer1.Id;
        equiFoyer.Name = 'equipement';
        equiFoyer.Uuid_Poste__c = '1234';
        listEquiFoyer.add(equiFoyer);
        insert equiFoyer;
        
        WorkType typeTravail = new WorkType();
        typeTravail.name = Label.TYP_Name_TypeParDefaut;
        typeTravail.EstimatedDuration = 10.00;
        insert typeTravail;
        
        List<WorkOrder> workOrderList = new List<WorkOrder>();
        WorkOrder intervention1 = new WorkOrder();
        intervention1.AccountId = foyer1.Id;
        intervention1.foyer_Paneliste__c = foyerPanelisteMMAT.Id;
        intervention1.Type_de_l_intervention__c = Label.WOR_Type_d_intervention_Installation;
        intervention1.Actions__c = Label.WOR_Actions_Nouveau_Foyer;
        intervention1.WorkTypeId = typeTravail.Id;
        workOrderList.add(intervention1);
        insert workOrderList;
        
        List< WorkOrderLineItem> listActions = new List< WorkOrderLineItem>();
        WorkOrderLineItem action = new WorkOrderLineItem();
        action.WorkOrderId = intervention1.Id;
        action.Foyer__c = foyer1.Id;
        action.foyer_paneliste__c= foyerPanelisteMMAT.Id;
        action.Equipement__c = asset1.Id;
        action.actions__c = Label.WOR_Actions_Nouveau_Foyer;
        listActions.add(action);
        insert listActions;
        
        Test.startTest();
        BatchRDD14_RemplirEquipementAction batch = new BatchRDD14_RemplirEquipementAction();
        DataBase.executeBatch(batch);
        Test.stopTest();
        

    }

}