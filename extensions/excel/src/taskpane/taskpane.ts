/*
 * Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

/* global console, document, Excel, Office */

import { DittoService, DittoConfig } from './DittoService';
import { ENV } from './env';
import { createClient, SupabaseClient } from '@supabase/supabase-js';
import { UiManager } from './app/UiManager';
import { RecentActionsManager } from './app/RecentActionsManager';
import { ExcelOperations } from './app/ExcelOperations';
import { SalesReportManager } from './app/SalesReportManager';
import { AuthManager } from './app/AuthManager';
import { FlipperBranch, FlipperTenant, FlipperUser, RecentAction } from './app/types';

class FlipperApp {
    private readonly API_BASE_URL = 'https://apihub.yegobox.com';
    private readonly uiManager = new UiManager();
    private readonly recentActionsManager = new RecentActionsManager(this.uiManager);
    private readonly excelOperations = new ExcelOperations(this.recentActionsManager, this.uiManager);
    private readonly dittoService = new DittoService();
    private readonly supabase: SupabaseClient;
    private readonly authManager: AuthManager;
    private readonly salesReportManager: SalesReportManager;
    private selectedBranch: FlipperBranch | null = null;
    private isInitialized = false;
    private dittoConfig: DittoConfig | null = null;

    constructor() {
        const env = ENV as any;
        this.supabase = createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY);

        this.authManager = new AuthManager({
            apiBaseUrl: this.API_BASE_URL,
            supabase: this.supabase,
            uiManager: this.uiManager,
            onAuthSuccess: () => this.onAuthSuccess(),
            onUserChange: (user) => this.handleUserChange(user)
        });

        this.salesReportManager = new SalesReportManager({
            apiBaseUrl: this.API_BASE_URL,
            dittoService: this.dittoService,
            uiManager: this.uiManager,
            recentActions: this.recentActionsManager,
            getCurrentUser: () => this.authManager.getCurrentUser(),
            getAuthToken: () => this.authManager.getAuthToken(),
            getSelectedBranch: () => this.selectedBranch
        });

        this.initializeApp();
    }

    get recentActions(): RecentAction[] {
        return this.recentActionsManager.getAll();
    }

    async highlightSelection(): Promise<void> {
        await this.excelOperations.highlightSelection();
    }

    async createTable(): Promise<void> {
        await this.excelOperations.createTable();
    }

    async formatData(): Promise<void> {
        await this.excelOperations.formatData();
    }

    async analyzeData(): Promise<void> {
        await this.excelOperations.analyzeData();
    }

    async applyDataValidation(): Promise<void> {
        await this.excelOperations.applyDataValidation();
    }

    async applyDataCleanup(): Promise<void> {
        await this.excelOperations.applyDataCleanup();
    }

    async generateSalesReport(isManual: boolean): Promise<void> {
        await this.salesReportManager.generateSalesReport(isManual);
    }

    addRecentAction(action: string, description: string): void {
        this.recentActionsManager.add(action, description);
    }

    updateRecentActionsUI(): void {
        this.uiManager.renderRecentActions(this.recentActions);
    }

    formatTime(date: Date): string {
        const now = new Date();
        const diffInMinutes = Math.floor((now.getTime() - date.getTime()) / (1000 * 60));
        if (diffInMinutes < 1) return 'Just now';
        if (diffInMinutes < 60) return `${diffInMinutes}m ago`;
        if (diffInMinutes < 1440) return `${Math.floor(diffInMinutes / 60)}h ago`;
        return date.toLocaleDateString();
    }

    showNotification(message: string, type: 'success' | 'error' | 'warning' = 'success'): void {
        this.uiManager.showNotification(message, type);
    }

    private async initializeApp(): Promise<void> {
        try {
            this.showLoadingState();
            await this.waitForOfficeReady();
            await this.initializeDitto();
            await this.authManager.initializeFromStorage();

            if (!this.isInitialized) {
                this.setupEventListeners();
            }

            this.hideLoadingState();

            if (this.authManager.getCurrentUser()) {
                this.showAppContainer();
                this.updateUserInterface();
                this.salesReportManager.startPolling();
            } else {
                this.showAuthState();
            }

            this.isInitialized = true;
            console.log('Flipper app initialized successfully');
        } catch (error) {
            console.error('Failed to initialize Flipper app:', error);
            this.showErrorState('Failed to initialize the application. Please try again.');
        }
    }

    private waitForOfficeReady(): Promise<void> {
        return new Promise((resolve, reject) => {
            Office.onReady((info) => {
                if ((info.host as any) === Office.HostType.Excel) {
                    resolve();
                } else {
                    reject(new Error('This add-in only works in Excel'));
                }
            });
        });
    }

    private async initializeDitto(): Promise<void> {
        try {
            const appID = ENV.DITTO_APP_ID;
            const token = ENV.DITTO_TOKEN;
            const websocketURL = ENV.DITTO_WEBSOCKET_URL;

            this.dittoConfig = {
                appID,
                token,
                customAuthURL: undefined,
                websocketURL
            };

            await this.dittoService.initialize(this.dittoConfig);
            console.log('Ditto initialized successfully');
        } catch (error) {
            console.error('Failed to initialize Ditto:', error);
            const errorMessage = error instanceof Error ? error.message : String(error);
            this.showNotification(`Ditto Error: ${errorMessage}`, 'error');
        }
    }

    private setupEventListeners(): void {
        document.getElementById('login-form')?.addEventListener('submit', (event) => this.authManager.handleLogin(event));
        document.getElementById('logout-button')?.addEventListener('click', () => this.handleLogout());

        document.getElementById('highlight-button')?.addEventListener('click', () => {
            void this.highlightSelection();
        });
        
        document.getElementById('format-data-button')?.addEventListener('click', () => {
            void this.formatData();
        });
        document.getElementById('analyze-data-button')?.addEventListener('click', () => {
            void this.analyzeData();
        });
        document.getElementById('sales-report-button')?.addEventListener('click', () => {
            void this.generateSalesReport(true);
        });

        document.getElementById('apply-validation')?.addEventListener('click', () => {
            void this.applyDataValidation();
        });
        document.getElementById('apply-cleanup')?.addEventListener('click', () => {
            void this.applyDataCleanup();
        });

        document.getElementById('settings-button')?.addEventListener('click', () => this.openSettings());
        document.getElementById('help-button')?.addEventListener('click', () => this.openHelp());
        document.getElementById('feedback-button')?.addEventListener('click', () => this.openFeedback());
        document.getElementById('retry-button')?.addEventListener('click', () => this.retryInitialization());

        this.uiManager.bindBranchSelector((event) => this.handleBranchSelection(event));
    }

    private onAuthSuccess(): void {
        this.hideLoadingState();
        this.showAppContainer();
        this.updateUserInterface();
        this.salesReportManager.startPolling();
    }

    private handleUserChange(user: FlipperUser | null): void {
        if (user) {
            this.uiManager.updateUserName(user);
            this.updateConnectionStatus();
            return;
        }

        this.clearSelectedBranch();
    }

    private updateUserInterface(): void {
        const currentUser = this.authManager.getCurrentUser();
        if (!currentUser) {
            return;
        }

        this.uiManager.updateUserName(currentUser);
        this.updateConnectionStatus();
    }

    private updateConnectionStatus(): void {
        const currentUser = this.authManager.getCurrentUser();
        if (!currentUser || !currentUser.tenants.length) {
            return;
        }

        const defaultTenant = this.getDefaultTenant(currentUser.tenants);
        const defaultBusiness = defaultTenant.businesses.find((business) => business.default) || defaultTenant.businesses[0];

        this.uiManager.updateTenantAndBusiness(defaultTenant, defaultBusiness?.name || null);
        this.populateBranchSelector(defaultTenant.branches);
    }

    private getDefaultTenant(tenants: FlipperTenant[]): FlipperTenant {
        return tenants.find((tenant) => tenant.default) || tenants[0];
    }

    private populateBranchSelector(branches: FlipperBranch[]): void {
        if (!branches.length) {
            this.clearSelectedBranch();
            return;
        }

        const savedBranchId = localStorage.getItem('flipper_selected_branch');
        let branchToSelect = branches.find((branch) => branch.id === savedBranchId) || branches.find((branch) => branch.default);

        if (!branchToSelect) {
            branchToSelect = branches[0];
        }

        this.selectedBranch = branchToSelect || null;
        this.uiManager.setBranchOptions(branches, branchToSelect?.id);

        if (branchToSelect) {
            localStorage.setItem('flipper_selected_branch', branchToSelect.id);
            this.preSubscribeToBranch(branchToSelect);
        }
    }

    private preSubscribeToBranch(branch: FlipperBranch): void {
        if (!branch.serverId) {
            return;
        }

        const startDate = new Date();
        startDate.setHours(0, 0, 0, 0);
        const endDate = new Date();
        endDate.setHours(23, 59, 59, 999);

        this.dittoService.subscribeToTransactions(branch.serverId, startDate, endDate).catch(console.error);
    }

    private handleBranchSelection(event: Event): void {
        const select = event.target as HTMLSelectElement;
        const branchId = select.value;
        const currentUser = this.authManager.getCurrentUser();

        if (!branchId || !currentUser) {
            return;
        }

        const tenant = this.getDefaultTenant(currentUser.tenants);
        const branch = tenant.branches.find((b) => b.id === branchId);
        if (!branch) {
            return;
        }

        this.selectedBranch = branch;
        localStorage.setItem('flipper_selected_branch', branch.id);
        this.showNotification(`Selected branch: ${branch.name}`, 'success');
        this.preSubscribeToBranch(branch);
    }

    private handleLogout(): void {
        this.salesReportManager.stopPolling();
        this.authManager.clearAuthData();
        this.recentActionsManager.clear();
        this.clearSelectedBranch();
        this.showAuthState();
        this.showNotification('Successfully disconnected from Flipper', 'success');
    }

    private clearSelectedBranch(): void {
        this.selectedBranch = null;
        localStorage.removeItem('flipper_selected_branch');

        const branchSelector = document.getElementById('branch-selector') as HTMLSelectElement | null;
        if (branchSelector) {
            branchSelector.innerHTML = '<option value="">Select a branch...</option>';
        }
    }

    private showLoadingState(): void {
        this.uiManager.showLoadingState();
    }

    private hideLoadingState(): void {
        this.uiManager.hideLoadingState();
    }

    private showAppContainer(): void {
        this.uiManager.showAppContainer();
    }

    private showAuthState(): void {
        this.uiManager.showAuthState();
    }

    private showErrorState(message: string): void {
        this.uiManager.showErrorState(message);
    }

    private openSettings(): void {
        this.showNotification('Settings feature coming soon', 'warning');
    }

    private openHelp(): void {
        this.showNotification('Help feature coming soon', 'warning');
    }

    private openFeedback(): void {
        this.showNotification('Feedback feature coming soon', 'warning');
    }

    private retryInitialization(): void {
        void this.initializeApp();
    }
}

new FlipperApp();

export { FlipperApp };

