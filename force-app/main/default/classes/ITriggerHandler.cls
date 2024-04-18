/*
@Author : Joseph Msallem
@CreatedDate : 17-02-2021
@Description : Trigger handler interface for all the DML operations
*/
public interface ITriggerHandler{
     
    void beforeInsert();
    void afterInsert();
    void beforeUpdate();
    void afterUpdate();
    void beforeDelete();   
    void afterDelete();   
    void afterUnDelete();
    Boolean isDisabled();
}