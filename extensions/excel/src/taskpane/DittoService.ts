/*
 * DittoService - Handles all Ditto SDK operations
 * Provides methods for querying transactions and setting up real-time observers
 */

import { Ditto, init } from '@dittolive/ditto';

export interface DittoConfig {
    appID: string;
    token: string;
    customAuthURL?: string;
    websocketURL: string;
}
export interface IdentityConfig {
  type: 'onlinePlayground';
  appID: string;
  token: string;
  customAuthURL?: string;
  enableDittoCloudSync?: boolean;
}

export interface Transaction {
    id: string;
    reference: string;
    transactionNumber: string;
    status: string;
    subTotal: number;
    paymentType: string;
    createdAt: string;
    customerName: string;
    receiptNumber: string;
    invoiceNumber: string;
    taxAmount: number;
    numberOfItems: number;
    customerPhone: string;
    transactionItems?: TransactionItem[];
    branchId?: number;
}

export interface TransactionItem {
    id: string;
    name: string;
    qty: number;
    price: number;
    discount: number;
    sku: string;
    unit: string;
}

export class DittoService {
    private ditto: Ditto | null = null;
    private isInitialized = false;
    private observers: Map<string, () => void> = new Map();

    /**
     * Initialize Ditto with the provided configuration
     */
    async initialize(config: DittoConfig): Promise<void> {
        try {
            console.log('Initializing Ditto...');

            // Initialize Ditto WebAssembly
            await init();

            // Create Ditto instance
            const identity: IdentityConfig = {
                type: 'onlinePlayground',
                appID: config.appID,
                token: config.token,
            };

            if (config.customAuthURL) {
                identity.customAuthURL = config.customAuthURL;
                identity.enableDittoCloudSync = false; // Required for custom URLs
            }

            this.ditto = new Ditto(identity);

            // Configure WebSocket transport
            this.ditto.updateTransportConfig((transportConfig) => {
                transportConfig.connect.websocketURLs.push(config.websocketURL);
            });

            // Disable DQL strict mode for flexible queries
            await this.ditto.store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = false');

            // Start sync
            this.ditto.sync.start();

            this.isInitialized = true;
            console.log('Ditto initialized successfully');
        } catch (error) {
            console.error('Failed to initialize Ditto:', error);
            throw new Error(`Ditto initialization failed: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }

    /**
     * Check if Ditto is initialized and ready
     */
    isReady(): boolean {
        return this.isInitialized && this.ditto !== null;
    }

    /**
     * Subscribe to transactions for a specific branch to start syncing data
     */
    async subscribeToTransactions(branchId: number, startDate?: Date, endDate?: Date): Promise<void> {
        if (!this.isReady()) {
            console.warn('Ditto is not initialized, skipping subscription');
            return;
        }

        // Default to today if no dates provided
        const start = startDate || new Date(new Date().setHours(0, 0, 0, 0));
        const end = endDate || new Date(new Date().setHours(23, 59, 59, 999));

        const startIso = start.toISOString();
        const endIso = end.toISOString();

        try {
            console.log(`Subscribing to transactions for branch ${branchId} between ${startIso} and ${endIso}...`);

            // Register a sync subscription for this query
            // We use a large limit or no limit for subscription to ensure we get the data
            this.ditto!.sync.registerSubscription(`
                SELECT * FROM transactions 
                WHERE branchId = :branchId 
                AND status != 'pending'
                AND lastTouched >= :startIso
                AND lastTouched <= :endIso
            `, { branchId, startIso, endIso });

            this.ditto!.sync.registerSubscription(`
                SELECT * FROM transaction_items 
                WHERE branchId = :branchId 
                AND lastTouched >= :startIso
                AND lastTouched <= :endIso
            `, { branchId, startIso, endIso });

            console.log('Subscription registered successfully');
        } catch (error) {
            console.error('Failed to register subscription:', error);
            throw error;
        }
    }

    /**
     * Fetch transactions for a specific branch
     */
    async getTransactions(branchId: number, limit: number = 50, startDate?: Date, endDate?: Date): Promise<Transaction[]> {
        if (!this.isReady()) {
            throw new Error('Ditto is not initialized. Call initialize() first.');
        }

        // Default to today if no dates provided
        const start = startDate || new Date(new Date().setHours(0, 0, 0, 0));
        const end = endDate || new Date(new Date().setHours(23, 59, 59, 999));

        const startIso = start.toISOString();
        const endIso = end.toISOString();

        try {
            console.log(`Fetching transactions for branch ${branchId} between ${startIso} and ${endIso}...`);

            // Ensure subscription is registered (idempotent)
            await this.subscribeToTransactions(branchId, startDate, endDate);

            // Execute query to get current data
            const result = await this.ditto!.store.execute(`
                SELECT * FROM transactions 
                WHERE branchId = :branchId 
                AND status != 'pending'
                AND lastTouched >= :startIso
                AND lastTouched <= :endIso
                ORDER BY lastTouched DESC
                LIMIT :limit
            `, {
                branchId,
                limit,
                startIso,
                endIso
            });

            console.log(`Fetched ${result.items.length} transactions from Ditto`);

            return result.items.map(item => this.mapToTransaction(item.value));
        } catch (error) {
            console.error('Failed to fetch transactions:', error);
            throw new Error(`Failed to fetch transactions: ${error instanceof Error ? error.message : 'Unknown error'}`);
        }
    }

    /**
     * Register a real-time observer for transactions
     * Returns an unsubscribe function
     */
    registerTransactionObserver(
        branchId: number,
        callback: (transactions: Transaction[]) => void
    ): () => void {
        if (!this.isReady()) {
            throw new Error('Ditto is not initialized. Call initialize() first.');
        }

        const observerId = `transactions_${branchId}_${Date.now()}`;

        console.log(`Registering observer for branch ${branchId}...`);

        // Register observer
        const observer = this.ditto!.store.registerObserver(`
            SELECT * FROM transactions 
            WHERE branchId = :branchId 
            AND status != 'pending'
            ORDER BY createdAt DESC
        `, (result) => {
            console.log(`Observer triggered: ${result.items.length} transactions`);
            const transactions = result.items.map(item => this.mapToTransaction(item.value));
            callback(transactions);
        }, {
            branchId
        });

        // Store the unsubscribe function
        this.observers.set(observerId, () => (observer as any).stop());

        // Return unsubscribe function
        return () => {
            console.log(`Unsubscribing observer ${observerId}`);
            (observer as any).stop();
            this.observers.delete(observerId);
        };
    }

    /**
     * Map Ditto document to Transaction interface
     */
    private mapToTransaction(doc: any): Transaction {
        return {
            id: doc.id || '',
            reference: doc.reference || '',
            transactionNumber: doc.transactionNumber || '',
            status: doc.status || '',
            subTotal: doc.subTotal || 0,
            paymentType: doc.paymentType || '',
            createdAt: doc.createdAt || '',
            customerName: doc.customerName || '',
            receiptNumber: doc.receiptNumber || '',
            invoiceNumber: doc.invoiceNumber || '',
            taxAmount: doc.taxAmount || 0,
            numberOfItems: doc.numberOfItems || 0,
            customerPhone: doc.customerPhone || '',
            transactionItems: doc.transactionItems || [],
            branchId: doc.branchId
        };
    }

    /**
     * Clean up all observers and stop sync
     */
    async cleanup(): Promise<void> {
        console.log('Cleaning up Ditto service...');

        // Unsubscribe all observers
        this.observers.forEach((unsubscribe, id) => {
            console.log(`Unsubscribing observer ${id}`);
            unsubscribe();
        });
        this.observers.clear();

        // Note: Ditto SDK doesn't have a stopSync method in the current version
        // The sync will stop when the instance is garbage collected

        this.isInitialized = false;
        this.ditto = null;

        console.log('Ditto service cleaned up');
    }
}
