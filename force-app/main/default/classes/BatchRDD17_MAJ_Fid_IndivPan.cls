/*
* @author: Mikael Chaaya
* @date: 17/07/2023
* @ Description Batch pour la RDD de l'objet Fidelisation pour Update pts credit et pts debit sur l'object individu panelsite
* @Coverage: %
* History
* <Date of modification>   		<Author>   		 <Description of modification>
*/
public class BatchRDD17_MAJ_Fid_IndivPan implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([select id ,Nombre_de_points_cr_dit_s__c, Nombre_de_points_d_bit_s__c 
                                                /* ,(Select id, Individu_Paneliste__c  ,Points_debites__c,Points_credites__c 
                                                  from Fid_lisations__r )*/
                                        from Individu_Paneliste__c 
                                        where id in (Select Individu_Paneliste__c  From Fidelisation__c 
                                                    Where Individu_Paneliste__c <>null 
                                                        and Statut_de_commande__c!= :Label.FID_Statut_de_commande_Annulee )]);       
    }
    
    public void execute(Database.BatchableContext bc, List<Individu_Paneliste__c> scope){
    
        Map<Id,Individu_Paneliste__c> IndivToUpdateMap = new Map<Id,Individu_Paneliste__c>();

        Map<String,List<Fidelisation__c>> indivFidelisationMap= new Map<String,List<Fidelisation__c>>();

        Map<Id,Individu_Paneliste__c> indivPanIdMap= new Map<Id,Individu_Paneliste__c>();
        for(Individu_Paneliste__c ind: scope) {
            indivPanIdMap.put(ind.Id, ind);
        }
        
        List<Fidelisation__c> fidList=[SELECT id, Individu_Paneliste__c  ,Points_debites__c,Points_credites__c 
        								FROM Fidelisation__c WHERE Individu_Paneliste__c IN :indivPanIdMap.keySet() AND Statut_de_commande__c!= :Label.FID_Statut_de_commande_Annulee];
 		System.debug('fidList');
        System.debug(fidList);
        for(Fidelisation__c fid:fidList ){
            if(indivFidelisationMap.containsKey(fid.Individu_Paneliste__c)) {
                indivFidelisationMap.get(fid.Individu_Paneliste__c).add(fid);
            }
            else {
                indivFidelisationMap.put(fid.Individu_Paneliste__c, new List<Fidelisation__c>{fid});
            }
        }

        System.debug('indivFidelisationMap');
        System.debug(indivFidelisationMap);
        for(Individu_Paneliste__c ind: scope) {
            ind.Nombre_de_points_d_bit_s__c=0;
            ind.Nombre_de_points_cr_dit_s__c=0;
            if(indivFidelisationMap.get(ind.Id)?.isEmpty() == false){
                for(Fidelisation__c fid: indivFidelisationMap.get(ind.Id)){
                    if(fid.Points_debites__c<>null || fid.Points_credites__c<>null){
                        if(fid.Points_debites__c<>null){
                            ind.Nombre_de_points_d_bit_s__c=(ind.Nombre_de_points_d_bit_s__c==null?0:ind.Nombre_de_points_d_bit_s__c)+fid.Points_debites__c;
                        }
                        if(fid.Points_credites__c<>null){
                            ind.Nombre_de_points_cr_dit_s__c=(ind.Nombre_de_points_cr_dit_s__c==null?0:ind.Nombre_de_points_cr_dit_s__c)+fid.Points_credites__c;
                        }
                        IndivToUpdateMap.put(ind.Id, ind);
                    }
                } 
            }
        }







/*
        SELECT Id,Points_debites__c,Points_credites__c,Individu_paneliste__c,
                                         Individu_Paneliste__r.Nombre_de_points_cr_dit_s__c,
                                         Individu_Paneliste__r.Nombre_de_points_d_bit_s__c
                                         from Fidelisation__c 
                                         where Individu_Paneliste__c <> null
                                         and Statut_de_commande__c!= :Label.FID_Statut_de_commande_Annulee

*/
 /*       for(Fidelisation__c f: scope) {
            Individu_Paneliste__c i=new individu_Paneliste__c();
            if(IndivToUpdateMap.containsKey(f.Individu_paneliste__c)){
                i=IndivToUpdateMap.get(f.Individu_paneliste__c);
            }
            else{
                i.Id=f.Individu_paneliste__c;
            }
            
            if(f.Points_debites__c<>null || f.Points_credites__c<>null){
                if(f.Points_debites__c<>null){
                    i.Nombre_de_points_d_bit_s__c=(i.Nombre_de_points_d_bit_s__c==null?0:i.Nombre_de_points_d_bit_s__c)+f.Points_debites__c;
                }
                if(f.Points_credites__c<>null){
                    i.Nombre_de_points_cr_dit_s__c=(i.Nombre_de_points_cr_dit_s__c==null?0:i.Nombre_de_points_cr_dit_s__c)+f.Points_credites__c;
                }
                IndivToUpdateMap.put(i.Id, i);
            }
            
        }
*/

        if(!IndivToUpdateMap.isEmpty()) {
            try{ 
                database.update(IndivToUpdateMap.values(), false);
            }Catch(exception ex){
                system.debug('RDD17 Update IndivPan Exception Error:' + ex.getmessage());
            }
        }

    }
    
        
    public void finish(Database.BatchableContext bc) {
        
    }    
}