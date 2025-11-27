import { DittoService } from '../DittoService';
import { RecentActionsManager } from './RecentActionsManager';
import { UiManager } from './UiManager';
import { FlipperBranch, FlipperUser } from './types';

interface SalesReportManagerDeps {
    apiBaseUrl: string;
    dittoService: DittoService;
    uiManager: UiManager;
    recentActions: RecentActionsManager;
    getCurrentUser: () => FlipperUser | null;
    getAuthToken: () => string | null;
    getSelectedBranch: () => FlipperBranch | null;
}

export class SalesReportManager {
    private salesReportInterval: number | null = null;
    private isPolling = false;

    constructor(private readonly deps: SalesReportManagerDeps) {}

    startPolling(): void {
        if (this.isPolling) {
            console.log('Sales report polling is already active.');
            return;
        }

        this.isPolling = true;
        this.salesReportInterval = window.setInterval(() => this.generateSalesReport(false), 30000);
        console.log('Started sales report polling.');
    }

    stopPolling(): void {
        if (this.salesReportInterval) {
            clearInterval(this.salesReportInterval);
            this.salesReportInterval = null;
            this.isPolling = false;
            console.log('Stopped sales report polling.');
        }
    }

    async generateSalesReport(isManual: boolean): Promise<void> {
        try {
            console.log(`Starting sales report generation (manual: ${isManual})...`);

            if (!this.deps.getCurrentUser() || !this.deps.getAuthToken()) {
                if (isManual) this.deps.uiManager.showNotification('User not authenticated. Please log in.', 'error');
                return;
            }

            const selectedBranch = this.deps.getSelectedBranch();
            if (!selectedBranch) {
                if (isManual) this.deps.uiManager.showNotification('Please select a branch from the connection status section.', 'error');
                return;
            }

            const branchId = selectedBranch.serverId;
            if (!branchId) {
                if (isManual) this.deps.uiManager.showNotification('Invalid server ID. Please select a different branch.', 'error');
                return;
            }

            this.deps.uiManager.updateStatusBar('Fetching sales data...', true);
            if (isManual) this.deps.uiManager.showNotification('Fetching sales data...', 'warning');

            let transactions: any[] = [];

            if (this.deps.dittoService.isReady()) {
                try {
                    console.log('Fetching transactions from Ditto...');
                    const dittoTransactions = await this.deps.dittoService.getTransactions(branchId, 1000);

                    transactions = dittoTransactions.map((tx) => ({
                        id: tx.id,
                        reference: tx.reference,
                        transaction_number: tx.transactionNumber,
                        status: tx.status,
                        sub_total: tx.subTotal,
                        payment_type: tx.paymentType,
                        created_at: tx.createdAt,
                        customer_name: tx.customerName,
                        receipt_number: tx.receiptNumber,
                        invoice_number: tx.invoiceNumber,
                        tax_amount: tx.taxAmount,
                        number_of_items: tx.numberOfItems,
                        customer_phone: tx.customerPhone,
                        transaction_items: tx.transactionItems || []
                    }));

                    console.log(`Fetched ${transactions.length} transactions from Ditto`);

                    const transactionIds = dittoTransactions.map((tx) => tx.id);
                    const items = await this.fetchTransactionItemsFromDitto(transactionIds, isManual);
                    console.log(`Fetched ${items.length} items from Ditto`);

                    const itemsByTransactionId = items.reduce((acc, item: any) => {
                        if (!acc[item.transactionId]) {
                            acc[item.transactionId] = [];
                        }
                        acc[item.transactionId].push(item);
                        return acc;
                    }, {} as Record<string, any[]>);

                    transactions.forEach((tx) => {
                        tx.transaction_items = itemsByTransactionId[tx.id] || [];
                    });
                } catch (dittoError) {
                    console.error('Ditto fetch failed, falling back to REST API:', dittoError);
                    if (isManual) this.deps.uiManager.showNotification('Ditto sync failed, using REST API...', 'warning');
                    transactions = await this.fetchTransactionsFromAPI(branchId);
                }
            } else {
                console.log('Ditto not ready, using REST API...');
                if (isManual) this.deps.uiManager.showNotification('Ditto not ready, using REST API...', 'warning');
                transactions = await this.fetchTransactionsFromAPI(branchId);
            }

            console.log('Fetched transactions:', transactions.length);

            if (!Array.isArray(transactions) || transactions.length === 0) {
                if (isManual) this.deps.uiManager.showNotification('No sales transactions found.', 'warning');
                return;
            }

            await this.writeTransactionsToExcel(transactions, isManual);
        } catch (error) {
            console.error('Error generating sales report:', error);
            let errorMessage = 'Failed to generate sales report. ';
            if (error instanceof Error) {
                errorMessage += error.message;
            } else {
                errorMessage += 'Please check the console for more details.';
            }
            this.deps.uiManager.updateStatusBar('Error generating report', false);
            if (isManual) this.deps.uiManager.showNotification(errorMessage, 'error');
        }
    }

    private async writeTransactionsToExcel(transactions: any[], isManual: boolean): Promise<void> {
        await Excel.run(async (context) => {
            console.log('Starting Excel operations...');
            const workbook = context.workbook;
            const worksheets = workbook.worksheets;
            worksheets.load('items');

            await context.sync();

            let salesSheet = this.ensureWorksheet(workbook, worksheets, 'sales');
            await context.sync();

            this.deps.uiManager.updateStatusBar('Writing sales data to Excel...', true);

            const txHeaders = [
                'ID',
                'Reference',
                'Transaction Number',
                'Status',
                'Sub Total',
                'Payment Type',
                'Created At',
                'Customer Name',
                'Receipt Number',
                'Invoice Number',
                'Tax Amount',
                'Number of Items',
                'Customer Phone'
            ];

            const headerRange = salesSheet.getRange('A1:M1');
            headerRange.values = [txHeaders];
            headerRange.format.font.bold = true;
            headerRange.format.fill.color = '#4472C4';
            headerRange.format.font.color = '#FFFFFF';

            await context.sync();

            const txRows = transactions.map((tx) => [
                tx.id || '',
                tx.reference || '',
                tx.transaction_number || '',
                tx.status || '',
                tx.sub_total || 0,
                tx.payment_type || '',
                tx.created_at || '',
                tx.customer_name || '',
                tx.receipt_number || '',
                tx.invoice_number || '',
                tx.tax_amount || 0,
                tx.number_of_items || 0,
                tx.customer_phone || ''
            ]);

            if (txRows.length > 0) {
                const dataRange = salesSheet.getRange(`A2:M${txRows.length + 1}`);
                dataRange.values = txRows;
                await context.sync();
                dataRange.format.autofitColumns();
                await context.sync();
            }

            const allItems: any[] = [];
            transactions.forEach((tx) => {
                (tx.transaction_items || []).forEach((item: any) => {
                    allItems.push({
                        transaction_id: tx.id,
                        transaction_reference: tx.reference,
                        ...item
                    });
                });
            });

            if (allItems.length > 0) {
                let itemsSheet = this.ensureWorksheet(workbook, worksheets, 'items');
                await context.sync();

                const itemHeaders = [
                    'Transaction ID',
                    'Transaction Reference',
                    'Item ID',
                    'Name',
                    'Quantity',
                    'Price',
                    'Discount',
                    'SKU',
                    'Unit'
                ];
                const itemHeaderRange = itemsSheet.getRange('A1:I1');
                itemHeaderRange.values = [itemHeaders];
                itemHeaderRange.format.font.bold = true;
                itemHeaderRange.format.fill.color = '#70AD47';
                itemHeaderRange.format.font.color = '#FFFFFF';

                await context.sync();

                const itemRows = allItems.map((item) => [
                    item.transaction_id || '',
                    item.transaction_reference || '',
                    item.id || '',
                    item.name || '',
                    item.qty || 0,
                    item.price || 0,
                    item.discount || 0,
                    item.sku || '',
                    item.unit || ''
                ]);

                const itemDataRange = itemsSheet.getRange(`A2:I${itemRows.length + 1}`);
                itemDataRange.values = itemRows;
                await context.sync();
                itemDataRange.format.autofitColumns();
                await context.sync();
            }

            this.deps.uiManager.updateStatusBar('Sales report complete', false);
            setTimeout(() => this.deps.uiManager.updateStatusBar('Connected to Excel', false), 3000);

            this.deps.recentActions.add(
                'Sales Report',
                `Generated sales report with ${transactions.length} transactions and ${allItems.length} items`
            );

            if (isManual) {
                this.deps.uiManager.showNotification(
                    `Sales report generated successfully! Created ${transactions.length} transaction records and ${allItems.length} items in separate sheets.`,
                    'success'
                );
            }
        });
    }

    private ensureWorksheet(workbook: Excel.Workbook, worksheets: Excel.WorksheetCollection, sheetName: string): Excel.Worksheet {
        const existingSheet = worksheets.items.find((ws) => ws.name === sheetName);
        if (existingSheet) {
            const sheet = workbook.worksheets.getItem(sheetName);
            try {
                const usedRange = sheet.getUsedRange();
                usedRange.load('address');
                workbook.context.sync().then(() => {
                    if (usedRange.address) {
                        usedRange.clear();
                    }
                });
            } catch (clearError) {
                console.log(`No existing content to clear in sheet ${sheetName}`, clearError);
            }
            return sheet;
        }

        return workbook.worksheets.add(sheetName);
    }

    private async fetchTransactionsFromAPI(branchId: number): Promise<any[]> {
        const url = `${this.deps.apiBaseUrl}/v2/api/transactions/branch/${branchId}?limit=10&excludeTransactionType=adjustment&excludeStatus=pending`;
        console.log('Fetching from REST API:', url);

        const response = await fetch(url, {
            headers: {
                Authorization: 'Basic ' + btoa('admin:admin'),
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            throw new Error(`API request failed: ${response.status} ${response.statusText}`);
        }

        return response.json();
    }

    private async fetchTransactionItemsFromDitto(transactionIds: string[], isManual: boolean): Promise<any[]> {
        if (!this.deps.dittoService.isReady() || transactionIds.length === 0) {
            return [];
        }

        try {
            const placeholders = transactionIds.map((_, i) => `:id${i}`).join(', ');
            const params: Record<string, string> = {};
            transactionIds.forEach((id, i) => {
                params[`id${i}`] = id;
            });

            const idsForSubscription = transactionIds.map((id) => `'${id}'`).join(', ');
            (this.deps.dittoService as any).ditto.sync.registerSubscription(`
                SELECT * FROM transaction_items
                WHERE transactionId IN (${idsForSubscription})
            `);

            const result = await (this.deps.dittoService as any).ditto.store.execute(
                `
                SELECT * FROM transaction_items
                WHERE transactionId IN (${placeholders})
            `,
                params
            );

            if (isManual) {
                this.deps.uiManager.showNotification(`Fetched ${result.items.length} transaction items from Ditto`, 'success');
            }

            return result.items.map((item: any) => ({
                id: item.value.id || item.value._id || '',
                name: item.value.name || item.value.itemNm || '',
                qty: item.value.qty || 0,
                price: item.value.price || item.value.prc || 0,
                discount: item.value.discount || item.value.dcAmt || 0,
                sku: item.value.sku || item.value.bcd || '',
                unit: item.value.unit || item.value.qtyUnitCd || '',
                transactionId: item.value.transactionId || ''
            }));
        } catch (error) {
            console.error('Failed to fetch transaction items from Ditto:', error);
            if (isManual) this.deps.uiManager.showNotification(`Failed to fetch transaction items from Ditto: ${error}`, 'error');
            return [];
        }
    }
}

