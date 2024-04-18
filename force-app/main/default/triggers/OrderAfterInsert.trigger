/*
* 
* @version 1.00   
* @Auteur Bastien Pinard
* <Date of modification>   			<Author>   		 <Description of modification>
*/
trigger OrderAfterInsert on Order (after insert) {
    if(PAD.canTrigger('AP02_Commande')) {
        System.debug('OrderAfterInsert');
        List<Order> listOrderToSend = new List<Order>();
        for(Order order: Trigger.New) {
            if(order.Status == label.Ord_Status_VersionPreliminaire && 
               (order.Type==label.Ord_Type_PackInitialPager 
                || order.Type==label.Ord_Type_PackInitialPagerSetmeter 
                || order.Type==Label.ORD_Type_PackInitial_ROAv3_Setmeter
                || order.Type==Label.ORD_Type_PackInitial_ROAv3
                || order.Type==label.Ord_Type_PackChute)){      
                listOrderToSend.add(order);
            }
        }
        
        
        if(listOrderToSend.size()>0 && listOrderToSend !=null){ 
            AP02_Commande.sendOrderTrigger(listOrderToSend);      
        }
    }
}