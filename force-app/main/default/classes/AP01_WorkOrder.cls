/*
* @date: 08/03/2022
* @ Description Class that create workOrderLineItems on WorkOrder creation
* @TestClass:AP01_WorkOrderTest 
* @Coverage: 100 %
*/
public class AP01_WorkOrder {
    

    
    //method called after creation of Work Order, and will create for each WO corresp WOLI equal to nb TV on WO.
    public static void NewWorkOrderLineItems(List<WorkOrder> ListInter){
        List<WorkOrderLineItem> listActionsToInsert = new List<WorkOrderLineItem>();
        List<Id> interListId = new List<Id>();
        for(WorkOrder inter:ListInter) {
            interListId.add(inter.Id);
        }
        
        List<WorkOrder> ListWorkOrder = new List<WorkOrder>();
        
        ListWorkOrder = [SELECT Id, Type_de_l_intervention__c, Actions__c, Account.Nombre_tv__c, Account.Nombre_pc__c,
                         Account.Nombre_smartphone__c, Account.Nombre_tablette__c, Remarques__c, foyer_paneliste__c, Nombre_d_equipements__c,
                         AccountId, foyer_paneliste__r.referentiel_panel__r.type_de_panel__c FROM WorkOrder WHERE Id IN:interListId];
        decimal nbDevices=0;
        for (WorkOrder wo :ListWorkOrder){
            if(wo.Account.Nombre_tv__c != null) {
                for(integer i =0; i <Integer.ValueOf(wo.Account.Nombre_tv__c); i++ ){
                    if(wo.Type_de_l_intervention__c == Label.WOR_Type_d_intervention_Installation){
                        WorkOrderLineItem WL = new WorkOrderLineItem();
                        WL.Actions__c = Label.WOR_Actions_Nouveau_Foyer;
                        WL.WorkOrderId=WO.Id;
                        WL.Foyer__c=WO.AccountId;
                        WL.foyer_paneliste__c=WO.foyer_paneliste__c;
                        WL.Remarques__c=WO.Remarques__c;
                        listActionsToInsert.add(WL);
                    }
                    
                }
            }
            
               
           	if (wo.Type_de_l_intervention__c == Label.WOR_Type_d_intervention_Desinstallation){
                for (integer i =0; i <wo.Nombre_d_equipements__c; i++ ) {
                    WorkOrderLineItem WL = new WorkOrderLineItem();
                    WL.Actions__c = Label.WOR_Actions_Desinstallation_Definitive;
                    WL.WorkOrderId=WO.Id;
                    WL.Foyer__c=WO.AccountId;
                    WL.foyer_paneliste__c=WO.foyer_paneliste__c;
                    WL.Remarques__c=WO.Remarques__c;
                    listActionsToInsert.add(WL);
                }
            }
            
            
            if(wo.Account.Nombre_pc__c != null){
                nbDevices += wo.Account.Nombre_pc__c;
            }
            if(wo.Account.Nombre_smartphone__c != null){
                nbDevices += wo.Account.Nombre_smartphone__c;
            }
            if(wo.Account.Nombre_tablette__c != null){
                nbDevices += wo.Account.Nombre_tablette__c;
            }
            
            if(wo.Type_de_l_intervention__c == Label.WOR_Type_d_intervention_Installation && wo.foyer_paneliste__r.referentiel_panel__r.type_de_panel__c == Label.RFP_TypePanel_PaME && nbDevices >1){
                WorkOrderLineItem WL = new WorkOrderLineItem();
                WL.WorkOrderId=WO.Id;
                WL.Foyer__c=WO.AccountId;
                WL.foyer_paneliste__c=WO.foyer_paneliste__c;
                if(nbDevices >=2 && nbDevices<=4){
                    WL.Actions__c = Label.WOR_Actions_Parametrage_Meters_2_a_4;
                    listActionsToInsert.add(WL);
                }
                else if(nbDevices>=5 && nbDevices<=8){
                    WL.Actions__c =Label.WOR_Actions_Parametrage_Meters_5_a_8;
                    listActionsToInsert.add(WL);
                }
            }
            
        
        }
        if (listActionsToInsert != null && listActionsToInsert.size()>0 ){
            try{ 
                insert( listActionsToInsert);
            }Catch(exception ex){
                system.debug(ex.getmessage());
            }
            
        }
    }
    
    //method called before inserting work order line items, will determine the duration based on custom setting 
    public static void UpdateDurationWorkOrderLineItems(List<WorkOrderLineItem> ListWorkOrderLineItem){
        Map<String,Duree_de_lintervention__c> mapStringToDuree = new Map<String,Duree_de_lintervention__c>();
        List<Duree_de_lintervention__c> ListDuree= Duree_de_lintervention__c.getall().values();
        
        List<Id> WOIds = new List<Id>();
        Map<String,Map<String, List<WorkOrderLineItem>>> mapWOtoListWOLI = new Map<String,Map<String, List<WorkOrderLineItem>>>();
        
        for (WorkOrderLineItem woli :ListWorkOrderLineItem){
            WOIds.add(woli.WorkOrderId);
            
        }
        List<WorkOrderLineItem> AllWOLI = [SELECT Id, Duration, WorkOrderId, Actions__c, WorkOrder.Type_de_l_intervention__c, WorkOrder.foyer_paneliste__r.referentiel_panel__r.type_de_panel__c FROM WorkOrderLineITem WHERE WorkOrderID IN:WOIds];
        AllWOLI.addAll(ListWorkOrderLineItem);
        for(Duree_de_lintervention__c duree :ListDuree){
            mapStringToDuree.put(duree.Type_d_intervention__c+'-'+duree.Sous_type_d_intervention__c+'-'+duree.Evol__c, duree);
        }
        Map<Id,WorkOrder> MapWorkOrder = new Map<Id,WorkOrder>([SELECT Id,Type_de_l_intervention__c, foyer_paneliste__r.referentiel_panel__r.type_de_panel__c , Nombre_d_equipements__c FROM WorkOrder WHERE Id IN :WOIds ]);
        for(WorkOrderLineItem woli :AllWOLI){
            if(mapWOtoListWOLI.get(woli.WorkOrderId) != null){
                if(mapWOtoListWOLI.get(woli.WorkOrderId).get(MapWorkOrder.get(woli.WorkOrderId).Type_de_l_intervention__c+'-'+woli.Actions__c+'-'+MapWorkOrder.get(woli.WorkOrderId).foyer_paneliste__r.referentiel_panel__r.type_de_panel__c) !=null){
                    mapWOtoListWOLI.get(woli.WorkOrderId).get(MapWorkOrder.get(woli.WorkOrderId).Type_de_l_intervention__c+'-'+woli.Actions__c+'-'+MapWorkOrder.get(woli.WorkOrderId).foyer_paneliste__r.referentiel_panel__r.type_de_panel__c).add(woli);
                }
                else{
                    List<WorkOrderLineItem> listWOLINew = new List<WorkOrderLineItem>();
                    listWOLINew.add(woli);
                    mapWOtoListWOLI.get(woli.WorkOrderId).put(MapWorkOrder.get(woli.WorkOrderId).Type_de_l_intervention__c+'-'+woli.Actions__c+'-'+MapWorkOrder.get(woli.WorkOrderId).foyer_paneliste__r.referentiel_panel__r.type_de_panel__c,listWOLINew );	
                
                }
            }
            else{
                Map<String, List<WorkOrderLineItem>> mapTypeSousType = new Map<String, List<WorkOrderLineItem>>(); 
                List<WorkOrderLineItem> ListWOLI = new List<WorkOrderLineItem>();
                ListWOLI.add(woli);
                mapTypeSousType.put(MapWorkOrder.get(woli.WorkOrderId).Type_de_l_intervention__c+'-'+woli.Actions__c+'-'+MapWorkOrder.get(woli.WorkOrderId).foyer_paneliste__r.referentiel_panel__r.type_de_panel__c, ListWOLI);
                mapWOtoListWOLI.put(woli.WorkOrderId,mapTypeSousType );
            }
            
        }

        for(Map<String, List<WorkOrderLineItem>> MapConcatToListWoli :mapWOtoListWOLI.values()){
            for(String key :MapConcatToListWoli.keySet()){
                if (MapConcatToListWoli.get(key).size()>0){
                    if(MapConcatToListWoli.get(key)[0] != null){   
                        if(mapStringToDuree.get(key) != null && MapConcatToListWoli.get(key)[0].Duration == null && MapConcatToListWoli.get(key)[0].Actions__c == Label.WOR_Actions_Desinstallation_Definitive && MapWorkOrder.get(MapConcatToListWoli.get(key)[0].WorkOrderId).Nombre_d_equipements__c >2 ){
                             MapConcatToListWoli.get(key)[0].Duration = mapStringToDuree.get(key).Duree_3_postes__c;
                    }      
                   	 else if(mapStringToDuree.get(key) != null && MapConcatToListWoli.get(key)[0].Duration == null && MapConcatToListWoli.get(key)[0].Actions__c == Label.WOR_Actions_Desinstallation_Definitive && MapWorkOrder.get(MapConcatToListWoli.get(key)[0].WorkOrderId).Nombre_d_equipements__c <=2 ){
                            
                         MapConcatToListWoli.get(key)[0].Duration = mapStringToDuree.get(key).Duree_initiale__c; 
                    }                           
                        if(mapStringToDuree.get(key) != null && MapConcatToListWoli.get(key)[0].Duration == null && MapConcatToListWoli.get(key)[0].Actions__c != Label.WOR_Actions_Desinstallation_Definitive) { 
                         MapConcatToListWoli.get(key)[0].Duration = mapStringToDuree.get(key).Duree_initiale__c; 
                       }  
                }
                }
                    else{
                        continue;
                    }
                    if(MapConcatToListWoli.get(key).size()>1 && MapConcatToListWoli.get(key)[1] != null && MapConcatToListWoli.get(key)[1].Duration == null){
                        MapConcatToListWoli.get(key)[1].Duration = mapStringToDuree.get(key).Duree_2_postes__c;
                    }
              
                    if(MapConcatToListWoli.get(key).size()>2 && MapConcatToListWoli.get(key)[2] != null && MapConcatToListWoli.get(key)[2].Duration == null){
                        MapConcatToListWoli.get(key)[2].Duration = mapStringToDuree.get(key).Duree_3_postes__c;
                    }
                     
                    if(MapConcatToListWoli.get(key).size()>3 && MapConcatToListWoli.get(key)[3] != null && MapConcatToListWoli.get(key)[3].Duration == null){
                        MapConcatToListWoli.get(key)[3].Duration = mapStringToDuree.get(key).Duree_4_postes__c;
                    }
                    
                }
            }
        }
    }