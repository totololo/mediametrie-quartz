trigger ContentDocLink_AfterInsert on ContentDocumentLink (after insert) {
	AP01_ContentDocLink.CloneFile(trigger.new);
}