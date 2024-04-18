trigger AgentWorkAfterUpdate on AgentWork (after update) {
    system.debug('test');
	AP07_AgentWork.UpdateCaseStatus(trigger.new, trigger.oldMap);
}