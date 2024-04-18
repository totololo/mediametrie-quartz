public class AP08_IndividuPaneliste {
    public static void newIndividuPaneliste(List<Individu_Paneliste__c> ListNewIndPan){
        Set<Id> foyerPanSet = new Set<Id>();
        for(Individu_Paneliste__c ind : ListNewIndPan){
            foyerPanSet.add(ind.Foyer_paneliste__c);
        }
        System.debug('$$$AP08_IndividuPaneliste newIndividuPaneliste foyerPanSet : ' + foyerPanSet);
        
        List<AggregateResult> listCountFoyerPan = new List<AggregateResult>();
        If(foyerPanSet.size() > 0 && foyerPanSet!=null){
            listCountFoyerPan = [
                SELECT MAX(ID_Google__c),  Foyer_paneliste__r.Id 
                FROM Individu_Paneliste__c 
                WHERE Foyer_paneliste__c  
                IN :foyerPanSet
                GROUP BY Foyer_paneliste__r.Id
            ];
        }
        
        Map<Id, Foyer_paneliste__c> listFoyerPan = new Map<Id, Foyer_paneliste__c>([
            SELECT id, Identifiant_foyer_pame__c
            FROM Foyer_paneliste__c 
            WHERE id 
            IN :foyerPanSet
        ]);
        
        Map<Id, Integer> mapIndPan = new Map<Id, Integer>();
        
        for(AggregateResult i : listCountFoyerPan){
            System.debug('$$$AP08_IndividuPaneliste newIndividuPaneliste i : ' + i);
            mapIndPan.put(i.id, Integer.valueOf(i.get('expr0')));
        }
        
        if(listCountFoyerPan.size() == 0){
            for(Individu_Paneliste__c ind : ListNewIndPan){
                if(ind.Foyer_paneliste__c == listFoyerPan.get(ind.Foyer_paneliste__c).Id && mapIndPan.get(ind.Foyer_paneliste__c) == null){
                    ind.ID_Google__c =  listFoyerPan.get(ind.Foyer_paneliste__c).Identifiant_foyer_pame__c + '101';
                }
            }
        } else if (listCountFoyerPan.size() > 0 && listCountFoyerPan!=null){
            
            System.debug('$$$AP08_IndividuPaneliste newIndividuPaneliste listCountFoyerPan : ' + listCountFoyerPan);
            
            
            
            System.debug('$$$AP08_IndividuPaneliste newIndividuPaneliste listFoyerPan : ' + listFoyerPan);
            
            
            System.debug('$$$AP08_IndividuPaneliste newIndividuPaneliste mapIndPan : ' + mapIndPan);
            
            for(Individu_Paneliste__c ind : ListNewIndPan){
                if(ind.Foyer_paneliste__c == listFoyerPan.get(ind.Foyer_paneliste__c).Id && mapIndPan.get(ind.Foyer_paneliste__c) != null){
                    Integer numberNewInd = mapIndPan.get(ind.Foyer_paneliste__c) + 1;
                    System.debug('$$$AP08_IndividuPaneliste newIndividuPaneliste numberNewInd : ' + numberNewInd);
                    ind.ID_Google__c = String.valueOf(numberNewInd);
                    System.debug('$$$AP08_IndividuPaneliste newIndividuPaneliste ind.ID_Google__c : ' + ind.ID_Google__c);
                }
            }
        }
        
    }
}