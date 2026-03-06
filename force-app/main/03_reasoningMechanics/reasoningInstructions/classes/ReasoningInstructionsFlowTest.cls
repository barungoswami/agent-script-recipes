/**
 * @description Test class for Reasoning Instructions Flows
 * Tests all flows used in the reasoning instructions recipe
 */
@IsTest
private class ReasoningInstructionsFlowTest {
    @TestSetup
    static void setup() {
        // Create test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create test order (OrderNumber is auto-generated)
        Order testOrder = new Order(
            AccountId = testAccount.Id,
            Status = 'Draft',
            EffectiveDate = Date.today()
        );
        insert testOrder;
    }

    @IsTest
    static void testGetOrderStatusSuccess() {
        // Get the order number from the created order
        Order testOrder = [SELECT OrderNumber FROM Order LIMIT 1];

        // Set input variables for the flow
        Map<String, Object> inputs = new Map<String, Object>();
        inputs.put('order_id', testOrder.OrderNumber);

        // Run the flow
        Test.startTest();
        Flow.Interview.GetOrderStatus flowInterview = new Flow.Interview.GetOrderStatus(
            inputs
        );
        flowInterview.start();
        Test.stopTest();

        // Verify the expected outcome
        String status = (String) flowInterview.getVariableValue('status');
        SObject details = (SObject) flowInterview.getVariableValue('details');

        Assert.isNotNull(status, 'Status should be returned');
        Assert.isNotNull(details, 'Order details should be returned');
    }
}