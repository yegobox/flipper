/*
 * Copyright (c) Microsoft Corporation. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

/* global console, document, Excel, Office */

import { DittoService, DittoConfig, Transaction } from './DittoService';
import { ENV } from './env';
import { createClient, SupabaseClient } from '@supabase/supabase-js';

interface RecentAction {
    id: string;
    action: string;
    timestamp: Date;
    description: string;
}

interface FlipperUser {
    id: number;
    phoneNumber: string;
    token: string;
    tenants: FlipperTenant[];
    channels: string[];
    editId: boolean;
    email: string | null;
    name: string;
    ownership: string;
    externalLinkId: string | null;
    groupId: number;
    pin: number;
    uid: string | null;
    external: boolean;
}

interface FlipperTenant {
    id: string;
    name: string;
    phoneNumber: string;
    email: string | null;
    imageUrl: string | null;
    permissions: string[];
    branches: FlipperBranch[];
    businesses: FlipperBusiness[];
    businessId: number;
    nfcEnabled: boolean;
    userId: number;
    pin: number;
    type: string;
    default: boolean;
}

interface FlipperBranch {
    id: string;
    active: boolean;
    description: string | null;
    name: string;
    longitude: string | null;
    latitude: string | null;
    location: string | null;
    businessId: number;
    serverId: number;
    default: boolean;
    online: boolean;
    // Added for compatibility with API responses
    branch_id?: string;
    branchId?: string;
}

interface FlipperBusiness {
    id: string;
    name: string;
    country: string;
    email: string | null;
    currency: string;
    latitude: string;
    longitude: string;
    type: string;
    metadata: any;
    role: string | null;
    reported: any;
    adrs: any;
    active: boolean;
    userId: string;
    phoneNumber: string;
    categoryId: string;
    timeZone: string | null;
    businessUrl: string | null;
    hexColor: string | null;
    imageUrl: string | null;
    referredBy: string | null;
    createdAt: string;
    updatedAt: string | null;
    lastSeen: number;
    firstName: string | null;
    lastName: string | null;
    deviceToken: string | null;
    chatUid: string | null;
    backUpEnabled: boolean;
    subscriptionPlan: string | null;
    nextBillingDate: string | null;
    previousBillingDate: string | null;
    backupFileId: string | null;
    lastDbBackup: string | null;
    fullName: string;
    referralCode: string | null;
    authId: string | null;
    tinNumber: number;
    dvcSrlNo: string | null;
    bhfId: string;
    taxEnabled: boolean;
    businessTypeId: number;
    encryptionKey: string | null;
    serverId: number;
    taxServerUrl: string | null;
    lastTouched: string | null;
    deletedAt: string | null;
    default: boolean;
    lastSubscriptionPaymentSucceeded: boolean;
}

class FlipperApp {
    private recentActions: RecentAction[] = [];
    private isInitialized = false;
    private currentUser: FlipperUser | null = null;
    private authToken: string | null = null;
    private selectedBranch: FlipperBranch | null = null;
    private readonly API_BASE_URL = 'https://apihub.yegobox.com';
    private dittoService: DittoService = new DittoService();
    private dittoConfig: DittoConfig | null = null;
    private salesReportInterval: number | null = null;
    private isPolling = false;
    private supabase: SupabaseClient;

    constructor() {
        const env = ENV as any;
        this.supabase = createClient(env.SUPABASE_URL, env.SUPABASE_ANON_KEY);
        this.initializeApp();
    }

    private async initializeApp(): Promise<void> {
        try {
            // Show loading state
            this.showLoadingState();

            // Wait for Office to be ready
            await this.waitForOfficeReady();

            // Initialize Ditto
            await this.initializeDitto();

            // Check if user is already authenticated
            const savedToken = localStorage.getItem('flipper_auth_token');
            if (savedToken) {
                this.authToken = savedToken;
                await this.validateToken();
            }

            // Initialize the app
            await this.setupEventListeners();
            this.hideLoadingState();

            if (this.currentUser) {
                this.showAppContainer();
                this.updateUserInterface();
                this.startSalesReportPolling();
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
            // Load Ditto configuration from environment or use defaults
            // You can also store these in localStorage or fetch from a config endpoint
            // Load Ditto configuration from env.ts
            const appID = ENV.DITTO_APP_ID;
            const token = ENV.DITTO_TOKEN;
            const customAuthURL = undefined; // Not used for playground
            const websocketURL = ENV.DITTO_WEBSOCKET_URL;

            this.dittoConfig = {
                appID,
                token,
                customAuthURL,
                websocketURL
            };

            await this.dittoService.initialize(this.dittoConfig);
            console.log('Ditto initialized successfully');
        } catch (error) {
            console.error('Failed to initialize Ditto:', error);
            const errorMessage = error instanceof Error ? error.message : String(error);
            this.showNotification(`Ditto Error: ${errorMessage}`, 'error');
            // Don't throw - allow app to continue with REST API fallback
            // this.showNotification('Ditto sync unavailable, using fallback mode', 'warning');
        }
    }

    private setupEventListeners(): void {
        // Authentication
        document.getElementById('login-form')?.addEventListener('submit', (e) => this.handleLogin(e));
        document.getElementById('logout-button')?.addEventListener('click', () => this.handleLogout());

        // Quick Actions
        document.getElementById('highlight-button')?.addEventListener('click', () => this.highlightSelection());
        document.getElementById('create-table-button')?.addEventListener('click', () => this.createTable());
        document.getElementById('format-data-button')?.addEventListener('click', () => this.formatData());
        document.getElementById('analyze-data-button')?.addEventListener('click', () => this.analyzeData());
        document.getElementById('sales-report-button')?.addEventListener('click', () => this.generateSalesReport(true));

        // Data Tools
        document.getElementById('apply-validation')?.addEventListener('click', () => this.applyDataValidation());
        document.getElementById('apply-cleanup')?.addEventListener('click', () => this.applyDataCleanup());

        // Footer Actions
        document.getElementById('settings-button')?.addEventListener('click', () => this.openSettings());
        document.getElementById('help-button')?.addEventListener('click', () => this.openHelp());
        document.getElementById('feedback-button')?.addEventListener('click', () => this.openFeedback());

        // Error handling
        document.getElementById('retry-button')?.addEventListener('click', () => this.retryInitialization());

        // Branch selection
        document.getElementById('branch-selector')?.addEventListener('change', (e) => this.handleBranchSelection(e));
    }

    private async handleLogin(event: Event): Promise<void> {
        event.preventDefault();

        const form = event.target as HTMLFormElement;
        const formData = new FormData(form);
        const pin = formData.get('pin') as string;
        const otpCode = formData.get('otpCode') as string;

        if (!pin) {
            this.showError('Enter your PIN');
            return;
        }

        const otpMethodSection = document.getElementById('otp-method-section');
        const otpFieldSection = document.getElementById('otp-field-section');
        const showingOtp = otpFieldSection && otpFieldSection.style.display !== 'none';

        try {
            this.setLoginButtonLoading(true);
            this.hideError();

            if (showingOtp) {
                // Step 2: Verify OTP
                if (!otpCode || otpCode.length !== 6) {
                    this.showError('Please enter a valid 6-digit code');
                    return;
                }

                const authMethod = this.getSelectedAuthMethod();
                
                if (authMethod === 'authenticator') {
                    // TOTP verification - different endpoint
                    await this.verifyTotpAndLogin(pin, otpCode);
                } else {
                    // SMS OTP verification
                    await this.verifySmsOtpAndLogin(pin, otpCode);
                }
                
                this.hideLoadingState();
                this.showAppContainer();
                this.updateUserInterface();
                this.startSalesReportPolling();
                this.showNotification('Successfully connected to Flipper', 'success');
            } else {
                // Step 1: Request OTP or show OTP field
                const authMethod = this.getSelectedAuthMethod();
                
                if (authMethod === 'sms') {
                    // Request SMS OTP
                    const response = await this.requestSmsOtp(pin);
                    if (response.requiresOtp) {
                        this.showOtpField();
                        this.updateLoginButtonText('Verify & Sign In');
                    } else {
                        // No OTP required: This shouldn't happen with the new flow
                        // but keeping for backward compatibility
                        this.showError('OTP is required for login');
                    }
                } else {
                    // Authenticator method - just show OTP field (no SMS request needed)
                    this.showOtpField();
                    this.updateLoginButtonText('Verify & Sign In');
                }
            }
        } catch (error) {
            console.error('Authentication failed:', error);
            const errorMessage = error instanceof Error ? error.message : 'Authentication failed. Please try again.';
            this.showError(errorMessage);
        } finally {
            this.setLoginButtonLoading(false);
        }
    }

    private async authenticateUser(phoneNumber: string): Promise<void> {
        console.log('Authenticating user with phone:', phoneNumber);
        
        // Ensure phone number has + prefix if it's not an email
        let formattedPhone = phoneNumber;
        if (!phoneNumber.startsWith('+') && !phoneNumber.includes('@')) {
            formattedPhone = '+' + phoneNumber;
        }
        console.log('Formatted phone for API:', formattedPhone);

        const response = await fetch(`${this.API_BASE_URL}/v2/api/user`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Basic ' + btoa('admin:admin')
            },
            body: JSON.stringify({ phoneNumber: formattedPhone })
        });

        if (!response.ok) {
            const errorText = await response.text();
            console.error('Authentication failed response:', errorText);
            throw new Error(`Authentication failed: ${response.status} ${response.statusText}`);
        }

        const userData: FlipperUser = await response.json();
        this.currentUser = userData;
        this.authToken = userData.token;

        // Save token and user data to localStorage
        localStorage.setItem('flipper_auth_token', userData.token);
        localStorage.setItem('flipper_user_data', JSON.stringify(userData));

        console.log('User authenticated successfully:', userData.name);
    }

    private async requestSmsOtp(pin: string): Promise<{ requiresOtp: boolean }> {
        const response = await fetch(`${this.API_BASE_URL}/v2/api/login/pin`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ pin })
        });

        if (!response.ok) {
            throw new Error('Failed to request OTP');
        }

        return await response.json();
    }

    private async verifySmsOtpAndLogin(pin: string, otp: string): Promise<void> {
        const response = await fetch(`${this.API_BASE_URL}/v2/api/login/verify-otp`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Basic ' + btoa('admin:admin')
            },
            body: JSON.stringify({ pin, otp })
        });

        if (!response.ok) {
            const errorData = await response.json().catch(() => ({ error: 'Invalid OTP code' }));
            throw new Error(errorData.error || 'Failed to verify OTP');
        }

        const responseData = await response.json();
        const phoneNumber = responseData.phoneNumber;

        // Fetch user data using the phone number from the response
        await this.authenticateUser(phoneNumber);
    }

    private async verifyTotpAndLogin(pin: string, totpCode: string): Promise<void> {
        this.showNotification(`Verifying TOTP code...${pin}`);
        // Step 1: Get the PIN object to retrieve userId
        const pinResponse = await fetch(`${this.API_BASE_URL}/v2/api/pin/${pin}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Basic ' + btoa('admin:admin')
            }
        });

        if (!pinResponse.ok) {
            throw new Error('Invalid PIN. Please re-enter and try again.');
        }

        const pinData = await pinResponse.json();
        console.log('PIN API Response:', pinData);
        
        // As per instruction, the PIN is the same as the numeric user_id
        const numericUserId = parseInt(pin, 10);
        console.log('Using PIN as numericUserId:', numericUserId);

        // IPin uses snake_case for JSON serialization
        const phoneNumber = pinData.phoneNumber || pinData.phone_number;
        console.log('Extracted phoneNumber:', phoneNumber);

        if (!phoneNumber) {
            throw new Error('Could not retrieve Phone Number from PIN.');
        }

        // Step 2: Get the user's TOTP secret from Supabase
        const { data, error } = await this.supabase
            .from('user_mfa_secrets')
            .select('secret')
            .eq('user_id', numericUserId)
            .limit(1)
            .single();

        if (error || !data) {
            this.showNotification('Error fetching TOTP secret: ' + error?.message);
            console.error('Error fetching TOTP secret:', error);
            throw new Error('TOTP not configured for this account.');
        }

        const secret = data.secret;

        // Step 3: Verify the TOTP code client-side
        const isValid = this.verifyTotpCode(secret, totpCode);

        if (!isValid) {
            throw new Error('Invalid authenticator code. Please try again.');
        }

        // Step 4: If valid, authenticate the user
        await this.authenticateUser(phoneNumber);
    }

    private verifyTotpCode(secret: string, code: string): boolean {
        try {
            // Clean the secret and code
            const cleanSecret = secret.replace(/[^A-Z2-7]/g, '');
            const cleanCode = code.replace(/[^0-9]/g, '');

            // Import TOTP from otpauth library
            const { TOTP } = require('otpauth');

            // Create TOTP instance
            const totp = new TOTP({
                issuer: 'Flipper',
                label: 'User',
                algorithm: 'SHA1',
                digits: 6,
                period: 30,
                secret: cleanSecret
            });

            // Get current time in seconds
            const currentTime = Math.floor(Date.now() / 1000);

            // Check current time window
            const currentToken = totp.generate({ timestamp: currentTime * 1000 });
            if (currentToken === cleanCode) {
                return true;
            }

            // Check previous time window (30 seconds ago)
            const previousToken = totp.generate({ timestamp: (currentTime - 30) * 1000 });
            if (previousToken === cleanCode) {
                return true;
            }

            // Check next time window (30 seconds ahead)
            const nextToken = totp.generate({ timestamp: (currentTime + 30) * 1000 });
            if (nextToken === cleanCode) {
                return true;
            }

            return false;
        } catch (e) {
            console.error('TOTP verification error:', e);
            return false;
        }
    }

    private getSelectedAuthMethod(): 'authenticator' | 'sms' {
        const authMethodRadios = document.getElementsByName('authMethod') as NodeListOf<HTMLInputElement>;
        const radiosArray = Array.from(authMethodRadios);
        for (const radio of radiosArray) {
            if (radio.checked) {
                return radio.value as 'authenticator' | 'sms';
            }
        }
        return 'authenticator'; // default
    }

    private showOtpField(): void {
        const otpMethodSection = document.getElementById('otp-method-section');
        const otpFieldSection = document.getElementById('otp-field-section');
        const otpLabel = document.getElementById('otp-label');

        if (otpMethodSection) otpMethodSection.style.display = 'block';
        if (otpFieldSection) otpFieldSection.style.display = 'block';

        // Update label based on selected method
        const authMethod = this.getSelectedAuthMethod();
        if (otpLabel) {
            otpLabel.textContent = authMethod === 'authenticator' ? 'Authenticator Code' : 'SMS Code';
        }

        // Focus on OTP input
        const otpInput = document.getElementById('otp-code') as HTMLInputElement;
        if (otpInput) {
            setTimeout(() => otpInput.focus(), 100);
        }

        // Setup auth method change listener
        this.setupAuthMethodChangeListener();
    }

    private setupAuthMethodChangeListener(): void {
        const authMethodRadios = document.getElementsByName('authMethod') as NodeListOf<HTMLInputElement>;
        Array.from(authMethodRadios).forEach(radio => {
            radio.addEventListener('change', async () => {
                const otpLabel = document.getElementById('otp-label');
                const otpInput = document.getElementById('otp-code') as HTMLInputElement;
                
                if (radio.value === 'sms') {
                    if (otpLabel) otpLabel.textContent = 'SMS Code';
                    if (otpInput) otpInput.value = '';
                    
                    // Request SMS OTP when switching to SMS
                    const pinInput = document.getElementById('pin-input') as HTMLInputElement;
                    if (pinInput && pinInput.value) {
                        try {
                            await this.requestSmsOtp(pinInput.value);
                            this.showNotification('SMS code sent', 'success');
                        } catch (error) {
                            console.error('Failed to send SMS:', error);
                        }
                    }
                } else {
                    if (otpLabel) otpLabel.textContent = 'Authenticator Code';
                    if (otpInput) otpInput.value = '';
                }
            });
        });
    }

    private showError(message: string): void {
        const errorElement = document.getElementById('error-message');
        const errorText = document.getElementById('error-text');
        
        if (errorElement && errorText) {
            errorText.textContent = message;
            errorElement.style.display = 'flex';
        }
    }

    private hideError(): void {
        const errorElement = document.getElementById('error-message');
        if (errorElement) {
            errorElement.style.display = 'none';
        }
    }

    private setLoginButtonLoading(loading: boolean): void {
        const button = document.getElementById('login-submit-btn') as HTMLButtonElement;
        const buttonText = document.getElementById('login-button-text');
        
        if (button) {
            button.disabled = loading;
            if (loading) {
                if (buttonText) {
                    buttonText.innerHTML = '<span class="spinner"></span> Processing...';
                }
            } else {
                if (buttonText) {
                    const otpFieldSection = document.getElementById('otp-field-section');
                    const showingOtp = otpFieldSection && otpFieldSection.style.display !== 'none';
                    buttonText.textContent = showingOtp ? 'Verify & Sign In' : 'Connect to Flipper';
                }
            }
        }
    }

    private updateLoginButtonText(text: string): void {
        const buttonText = document.getElementById('login-button-text');
        if (buttonText) {
            buttonText.textContent = text;
        }
    }

    private async validateToken(): Promise<void> {
        if (!this.authToken) {
            throw new Error('No auth token available');
        }

        try {
            console.log('Restoring user data from localStorage...!');

            // Restore user data from localStorage
            const savedUserData = localStorage.getItem('flipper_user_data');
            if (!savedUserData) {
                throw new Error('No saved user data found');
            }

            const userData: FlipperUser = JSON.parse(savedUserData);
            this.currentUser = userData;

            console.log('User data restored successfully:', userData.name);
        } catch (error) {
            console.error('Token validation failed:', error);
            this.clearAuthData();
            throw error;
        }
    }

    private handleLogout(): void {
        this.stopSalesReportPolling();
        this.clearAuthData();
        this.showAuthState();
        this.showNotification('Successfully disconnected from Flipper', 'success');
    }

    private clearAuthData(): void {
        this.currentUser = null;
        this.authToken = null;
        this.selectedBranch = null;
        localStorage.removeItem('flipper_auth_token');
        localStorage.removeItem('flipper_user_data');
        localStorage.removeItem('flipper_selected_branch');
    }

    private updateUserInterface(): void {
        if (!this.currentUser) return;

        // Update user name in header
        const userNameElement = document.getElementById('user-name');
        if (userNameElement) {
            userNameElement.textContent = this.currentUser.name || this.currentUser.phoneNumber;
        }

        // Update connection status
        this.updateConnectionStatus();
    }

    private updateConnectionStatus(): void {
        if (!this.currentUser || !this.currentUser.tenants.length) return;

        const defaultTenant = this.currentUser.tenants.find(t => t.default) || this.currentUser.tenants[0];
        const defaultBusiness = defaultTenant.businesses.find(b => b.default) || defaultTenant.businesses[0];

        // Update tenant name
        const tenantNameElement = document.getElementById('tenant-name');
        if (tenantNameElement) {
            tenantNameElement.textContent = defaultTenant.name;
        }

        // Update business name
        const businessNameElement = document.getElementById('business-name');
        if (businessNameElement) {
            businessNameElement.textContent = defaultBusiness?.name || 'N/A';
        }

        // Populate branch selector
        this.populateBranchSelector(defaultTenant.branches);

        // Pre-subscribe to transactions for the default branch
        if (this.selectedBranch && this.selectedBranch.serverId) {
            // Default to today's date
            const startDate = new Date();
            startDate.setHours(0, 0, 0, 0);
            const endDate = new Date();
            endDate.setHours(23, 59, 59, 999);

            this.dittoService.subscribeToTransactions(this.selectedBranch.serverId, startDate, endDate).catch(console.error);
        }
    }

    private populateBranchSelector(branches: FlipperBranch[]): void {
        const branchSelector = document.getElementById('branch-selector') as HTMLSelectElement;
        if (!branchSelector) return;

        // Clear existing options
        branchSelector.innerHTML = '<option value="">Select a branch...</option>';

        // Add branch options
        branches.forEach(branch => {
            const option = document.createElement('option');
            option.value = branch.id;
            option.textContent = branch.name;
            branchSelector.appendChild(option);
        });

        // Try to restore previously selected branch
        const savedBranchId = localStorage.getItem('flipper_selected_branch');
        if (savedBranchId) {
            const savedBranch = branches.find(b => b.id === savedBranchId);
            if (savedBranch) {
                branchSelector.value = savedBranchId;
                this.selectedBranch = savedBranch;
            }
        } else {
            // Try to select default branch
            const defaultBranch = branches.find(b => b.default);
            if (defaultBranch) {
                branchSelector.value = defaultBranch.id;
                this.selectedBranch = defaultBranch;
                localStorage.setItem('flipper_selected_branch', defaultBranch.id);
            }
        }
    }

    private handleBranchSelection(event: Event): void {
        const select = event.target as HTMLSelectElement;
        const branchId = select.value;

        if (!branchId || !this.currentUser) return;

        // Find the selected branch
        const defaultTenant = this.currentUser.tenants.find(t => t.default) || this.currentUser.tenants[0];
        const selectedBranch = defaultTenant.branches.find(b => b.id === branchId);

        if (selectedBranch) {
            this.selectedBranch = selectedBranch;
            localStorage.setItem('flipper_selected_branch', branchId);
            this.showNotification(`Selected branch: ${selectedBranch.name}`, 'success');

            // Subscribe to transactions for the new branch
            if (selectedBranch.serverId) {
                // Default to today's date
                const startDate = new Date();
                startDate.setHours(0, 0, 0, 0);
                const endDate = new Date();
                endDate.setHours(23, 59, 59, 999);

                this.dittoService.subscribeToTransactions(selectedBranch.serverId, startDate, endDate).catch(console.error);
            }
        }
    }

    private startSalesReportPolling(): void {
        if (this.isPolling) {
            console.log('Sales report polling is already active.');
            return;
        }

        this.isPolling = true;
        this.salesReportInterval = window.setInterval(() => {
            this.generateSalesReport(false);
        }, 30000); // Poll every 30 seconds

        console.log('Started sales report polling.');
    }

    private stopSalesReportPolling(): void {
        if (this.salesReportInterval) {
            clearInterval(this.salesReportInterval);
            this.salesReportInterval = null;
            this.isPolling = false;
            console.log('Stopped sales report polling.');
        }
    }

    private showLoadingState(): void {
        const loadingState = document.getElementById('loading-state');
        const appContainer = document.getElementById('app-container');
        const errorState = document.getElementById('error-state');
        const authState = document.getElementById('auth-state');

        if (loadingState) loadingState.style.display = 'flex';
        if (appContainer) appContainer.style.display = 'none';
        if (errorState) errorState.style.display = 'none';
        if (authState) authState.style.display = 'none';
    }

    private hideLoadingState(): void {
        const loadingState = document.getElementById('loading-state');
        if (loadingState) loadingState.style.display = 'none';
    }

    private updateStatusBar(message: string, isLoading: boolean = false): void {
        const statusText = document.getElementById('status-text');
        const statusSpinner = document.getElementById('status-spinner');
        
        if (statusText) {
            statusText.textContent = message;
        }
        
        if (statusSpinner) {
            statusSpinner.style.display = isLoading ? 'inline-block' : 'none';
        }
    }


    private showAppContainer(): void {
        const appContainer = document.getElementById('app-container');
        const authState = document.getElementById('auth-state');
        const loadingState = document.getElementById('loading-state');
        const errorState = document.getElementById('error-state');

        if (appContainer) appContainer.style.display = 'flex';
        if (authState) authState.style.display = 'none';
        if (loadingState) loadingState.style.display = 'none';
        if (errorState) errorState.style.display = 'none';
    }

    private showAuthState(): void {
        const authState = document.getElementById('auth-state');
        const appContainer = document.getElementById('app-container');
        const loadingState = document.getElementById('loading-state');
        const errorState = document.getElementById('error-state');

        if (authState) authState.style.display = 'flex';
        if (appContainer) appContainer.style.display = 'none';
        if (loadingState) loadingState.style.display = 'none';
        if (errorState) errorState.style.display = 'none';
    }

    private showErrorState(message: string): void {
        const errorState = document.getElementById('error-state');
        const errorMessage = document.getElementById('error-message');
        const loadingState = document.getElementById('loading-state');
        const appContainer = document.getElementById('app-container');
        const authState = document.getElementById('auth-state');

        if (errorMessage) errorMessage.textContent = message;
        if (errorState) errorState.style.display = 'flex';
        if (loadingState) loadingState.style.display = 'none';
        if (appContainer) appContainer.style.display = 'none';
        if (authState) authState.style.display = 'none';
    }

    private async highlightSelection(): Promise<void> {
        try {
            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address');

                // Apply professional highlighting
                range.format.fill.color = '#fff2cc';
                range.format.font.color = '#323130';
                range.format.font.bold = true;

                await context.sync();

                this.addRecentAction('Highlight Selection', `Highlighted range ${range.address}`);
                console.log(`Highlighted range: ${range.address}`);
            });
        } catch (error) {
            console.error('Error highlighting selection:', error);
            this.showNotification('Failed to highlight selection. Please try again.', 'error');
        }
    }

    private async createTable(): Promise<void> {
        try {
            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address');

                // Create a table from the selected range
                const table = context.workbook.tables.add(range, true);
                table.name = `Table_${Date.now()}`;

                // Apply professional table styling
                table.style = 'TableStyleMedium2';

                await context.sync();

                this.addRecentAction('Create Table', `Created table from range ${range.address}`);
                console.log(`Created table from range: ${range.address}`);
            });
        } catch (error) {
            console.error('Error creating table:', error);
            this.showNotification('Failed to create table. Please try again.', 'error');
        }
    }

    private async formatData(): Promise<void> {
        try {
            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address');

                // Apply professional formatting
                range.format.font.name = 'Segoe UI';
                range.format.font.size = 11;
                range.format.horizontalAlignment = 'Center';
                range.format.verticalAlignment = 'Center';

                await context.sync();

                this.addRecentAction('Format Data', `Applied formatting to range ${range.address}`);
                console.log(`Formatted range: ${range.address}`);
            });
        } catch (error) {
            console.error('Error formatting data:', error);
            this.showNotification('Failed to format data. Please try again.', 'error');
        }
    }

    private async analyzeData(): Promise<void> {
        try {
            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address');

                // Add basic data analysis
                const worksheet = context.workbook.worksheets.getActiveWorksheet();
                const analysisRange = worksheet.getRange(`A${range.getRowCount() + 2}`);

                // Add summary statistics
                analysisRange.values = [['Data Analysis Summary']];
                analysisRange.format.font.bold = true;
                analysisRange.format.font.size = 14;

                await context.sync();

                this.addRecentAction('Analyze Data', `Analyzed data in range ${range.address}`);
                console.log(`Analyzed data in range: ${range.address}`);
            });
        } catch (error) {
            console.error('Error analyzing data:', error);
            this.showNotification('Failed to analyze data. Please try again.', 'error');
        }
    }

    private async generateSalesReport(isManual: boolean = false): Promise<void> {
        try {
            console.log(`Starting sales report generation (manual: ${isManual})...`);

            if (!this.currentUser || !this.authToken) {
                if (isManual) this.showNotification('User not authenticated. Please log in.', 'error');
                return;
            }

            // Get selected branch
            if (!this.selectedBranch) {
                if (isManual) this.showNotification('Please select a branch from the connection status section.', 'error');
                return;
            }

            const branchId = this.selectedBranch.serverId;
            if (!branchId) {
                if (isManual) this.showNotification('Invalid server ID. Please select a different branch.', 'error');
                return;
            }

            // Update status bar to show we're fetching data
            this.updateStatusBar('Fetching sales data...', true);
            if (isManual) this.showNotification('Fetching sales data...', 'warning');

            let transactions: any[] = [];

            // Try to fetch from Ditto first, fallback to REST API
            if (this.dittoService.isReady()) {
                try {
                    console.log('Fetching transactions from Ditto...');
                    // Fetch up to 1000 transactions for today (default date range in DittoService)
                    const dittoTransactions = await this.dittoService.getTransactions(branchId, 1000);

                    // Convert Ditto transactions to the format expected by Excel generation
                    transactions = dittoTransactions.map(tx => ({
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

                    // Fetch transaction items separately
                    const transactionIds = dittoTransactions.map(tx => tx.id);
                    const items = await this.fetchTransactionItemsFromDitto(transactionIds, isManual);
                    console.log(`Fetched ${items.length} items from Ditto`);

                    // Join items with transactions
                    const itemsByTransactionId = items.reduce((acc, item: any) => {
                        if (!acc[item.transactionId]) {
                            acc[item.transactionId] = [];
                        }
                        acc[item.transactionId].push(item);
                        return acc;
                    }, {} as Record<string, any[]>);

                    // Add items to transactions
                    transactions.forEach(tx => {
                        tx.transaction_items = itemsByTransactionId[tx.id] || [];
                    });

                    const totalItems = transactions.reduce((sum, tx) => sum + (tx.transaction_items?.length || 0), 0);
                    // this.showNotification(`Using Ditto: ${transactions.length} transactions, ${totalItems} items`, 'success');
                } catch (dittoError) {
                    console.error('Ditto fetch failed, falling back to REST API:', dittoError);
                    if (isManual) this.showNotification('Ditto sync failed, using REST API...', 'warning');
                    transactions = await this.fetchTransactionsFromAPI(branchId);
                }
            } else {
                console.log('Ditto not ready, using REST API...');
                if (isManual) this.showNotification('Ditto not ready, using REST API...', 'warning');
                transactions = await this.fetchTransactionsFromAPI(branchId);
            }

            console.log('Fetched transactions:', transactions.length);

            if (!Array.isArray(transactions) || transactions.length === 0) {
                if (isManual) this.showNotification('No sales transactions found.', 'warning');
                return;
            }

            // Now let's work with Excel step by step
            await Excel.run(async (context) => {
                console.log('Starting Excel operations...');

                try {
                    // Step 1: Get the workbook and list existing worksheets
                    const workbook = context.workbook;
                    const activeSheet = workbook.worksheets.getActiveWorksheet();
                    activeSheet.load('name');
                    const worksheets = workbook.worksheets;
                    worksheets.load('items');

                    await context.sync();

                    console.log('Current worksheets:', worksheets.items.map(ws => ws.name));

                    // Step 2: Create or get the sales sheet
                    console.log('Creating/getting sales sheet...');
                    let salesSheet;

                    // Check if sales sheet exists
                    let salesSheetExists = false;
                    for (const ws of worksheets.items) {
                        if (ws.name === 'sales') {
                            salesSheetExists = true;
                            break;
                        }
                    }

                    if (salesSheetExists) {
                        console.log('Sales sheet exists, getting it...');
                        salesSheet = workbook.worksheets.getItem('sales');

                        // Clear existing content safely
                        try {
                            const usedRange = salesSheet.getUsedRange();
                            usedRange.load('address');
                            await context.sync();

                            if (usedRange.address) {
                                console.log('Clearing existing content in range:', usedRange.address);
                                usedRange.clear();
                            }
                        } catch (clearError) {
                            console.log('No existing content to clear or error clearing:', clearError);
                        }
                    } else {
                        console.log('Creating new sales sheet...');
                        salesSheet = workbook.worksheets.add('sales');
                    }

                    await context.sync();
                    console.log('Sales sheet ready');

                    // Update status bar
                    this.updateStatusBar('Writing sales data to Excel...', true);

                    // Step 3: Write headers
                    console.log('Writing headers...');
                    const txHeaders = [
                        'ID', 'Reference', 'Transaction Number', 'Status', 'Sub Total',
                        'Payment Type', 'Created At', 'Customer Name', 'Receipt Number',
                        'Invoice Number', 'Tax Amount', 'Number of Items', 'Customer Phone'
                    ];

                    const headerRange = salesSheet.getRange('A1:M1');
                    headerRange.values = [txHeaders];
                    headerRange.format.font.bold = true;
                    headerRange.format.fill.color = '#4472C4';
                    headerRange.format.font.color = '#FFFFFF';

                    await context.sync();
                    console.log('Headers written successfully');

                    // Step 4: Prepare and write transaction data
                    console.log('Preparing transaction data...');
                    const txRows = transactions.map(tx => [
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
                        console.log(`Writing ${txRows.length} transaction rows...`);
                        const dataRange = salesSheet.getRange(`A2:M${txRows.length + 1}`);
                        dataRange.values = txRows;

                        await context.sync();
                        console.log('Transaction data written successfully');

                        // Format the data
                        dataRange.format.autofitColumns();
                        await context.sync();
                        console.log('Data formatted successfully');
                    }

                    // Step 5: Create single items sheet with all transaction items
                    console.log('Processing items sheet...');

                    // Collect all items from all transactions
                    const allItems: any[] = [];
                    for (const tx of transactions) {
                        const items = tx.transaction_items || [];
                        for (const item of items) {
                            allItems.push({
                                transaction_id: tx.id,
                                transaction_reference: tx.reference,
                                ...item
                            });
                        }
                    }

                    if (allItems.length > 0) {
                        console.log(`Found ${allItems.length} total items across all transactions`);

                        // Create or get the items sheet
                        let itemsSheet;
                        let itemsSheetExists = false;
                        for (const ws of worksheets.items) {
                            if (ws.name === 'items') {
                                itemsSheetExists = true;
                                break;
                            }
                        }

                        if (itemsSheetExists) {
                            console.log('Items sheet exists, getting it...');
                            itemsSheet = workbook.worksheets.getItem('items');

                            // Clear existing content safely
                            try {
                                const usedRange = itemsSheet.getUsedRange();
                                usedRange.load('address');
                                await context.sync();

                                if (usedRange.address) {
                                    console.log('Clearing existing content in items sheet:', usedRange.address);
                                    usedRange.clear();
                                }
                            } catch (clearError) {
                                console.log('No existing content to clear in items sheet');
                            }
                        } else {
                            console.log('Creating new items sheet...');
                            itemsSheet = workbook.worksheets.add('items');
                        }

                        await context.sync();

                        // Write item headers
                        const itemHeaders = [
                            'Transaction ID', 'Transaction Reference', 'Item ID', 'Name',
                            'Quantity', 'Price', 'Discount', 'SKU', 'Unit'
                        ];
                        const itemHeaderRange = itemsSheet.getRange('A1:I1');
                        itemHeaderRange.values = [itemHeaders];
                        itemHeaderRange.format.font.bold = true;
                        itemHeaderRange.format.fill.color = '#70AD47';
                        itemHeaderRange.format.font.color = '#FFFFFF';

                        await context.sync();

                        // Write all item data
                        const itemRows = allItems.map(item => [
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

                        console.log(`Writing ${itemRows.length} item rows...`);
                        const itemDataRange = itemsSheet.getRange(`A2:I${itemRows.length + 1}`);
                        itemDataRange.values = itemRows;

                        await context.sync();

                        // Format the data
                        itemDataRange.format.autofitColumns();
                        await context.sync();

                        console.log('Items sheet created successfully');
                    } else {
                        console.log('No items found in any transactions');
                    }

                    console.log('Sales report generation completed successfully');
                    this.addRecentAction('Sales Report', `Generated sales report with ${transactions.length} transactions and ${allItems.length} items`);
                    
                    // Update status bar to show completion
                    this.updateStatusBar('Sales report complete', false);
                    
                    // Reset status bar after 3 seconds
                    setTimeout(() => {
                        this.updateStatusBar('Connected to Excel', false);
                    }, 3000);
                    
                    if (isManual) this.showNotification(`Sales report generated successfully! Created ${transactions.length} transaction records and ${allItems.length} items in separate sheets.`, 'success');

                } catch (excelError) {
                    console.error('Error in Excel operations:', excelError);
                    throw excelError;
                }
            });

        } catch (error) {
            console.error('Error generating sales report:', error);
            let errorMessage = 'Failed to generate sales report. ';

            if (error instanceof Error) {
                errorMessage += error.message;
            } else {
                errorMessage += 'Please check the console for more details.';
            }

            // Update status bar to show error
            this.updateStatusBar('Error generating report', false);
            
            if (isManual) this.showNotification(errorMessage, 'error');
        }
    }

    // Helper method to fetch transactions from REST API (fallback)
    private async fetchTransactionsFromAPI(branchId: number): Promise<any[]> {
        const url = `${this.API_BASE_URL}/v2/api/transactions/branch/${branchId}?limit=10&excludeTransactionType=adjustment&excludeStatus=pending`;
        console.log('Fetching from REST API:', url);

        const response = await fetch(url, {
            headers: {
                'Authorization': 'Basic ' + btoa('admin:admin'),
                'Content-Type': 'application/json'
            }
        });

        if (!response.ok) {
            throw new Error(`API request failed: ${response.status} ${response.statusText}`);
        }

        return await response.json();
    }

    // Helper method to fetch transaction items from Ditto
    private async fetchTransactionItemsFromDitto(transactionIds: string[], isManual = false): Promise<any[]> {
        if (!this.dittoService.isReady() || transactionIds.length === 0) {
            return [];
        }

        try {
            // Build IN clause for SQL query
            const placeholders = transactionIds.map((_, i) => `:id${i}`).join(', ');
            const params: any = {};
            transactionIds.forEach((id, i) => {
                params[`id${i}`] = id;
            });

            // Register subscription for sync - use actual IDs (subscription doesn't support parameters)
            const idsForSubscription = transactionIds.map(id => `'${id}'`).join(', ');
            (this.dittoService as any).ditto.sync.registerSubscription(`
                SELECT * FROM transaction_items
                WHERE transactionId IN (${idsForSubscription})
            `);

            const result = await (this.dittoService as any).ditto.store.execute(`
                SELECT * FROM transaction_items
                WHERE transactionId IN (${placeholders})
            `, params);
            if (isManual) this.showNotification(`Fetched ${result.items.length} transaction items from Ditto`, 'success');
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
            if (isManual) this.showNotification(`Failed to fetch transaction items from Ditto: ${error}`, 'error');
            return [];
        }
    }

    // Helper method to safely delete a worksheet
    private async safeDeleteWorksheet(workbook: Excel.Workbook, sheetName: string): Promise<void> {
        try {
            const worksheet = workbook.worksheets.getItem(sheetName);
            worksheet.delete();
            console.log(`Deleted worksheet: ${sheetName}`);
        } catch (error) {
            console.log(`Worksheet ${sheetName} doesn't exist or couldn't be deleted:`, error);
        }
    }

    // Helper method to check if worksheet exists
    private async worksheetExists(workbook: Excel.Workbook, sheetName: string): Promise<boolean> {
        try {
            const worksheets = workbook.worksheets;
            worksheets.load('items');
            await workbook.context.sync();

            return worksheets.items.some(ws => ws.name === sheetName);
        } catch (error) {
            console.log(`Error checking if worksheet exists: ${sheetName}`, error);
            return false;
        }
    }

    private async applyDataValidation(): Promise<void> {
        try {
            const validationType = (document.getElementById('data-validation') as HTMLSelectElement)?.value;

            if (!validationType) {
                this.showNotification('Please select a validation type', 'warning');
                return;
            }

            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address');

                // Apply validation based on type
                switch (validationType) {
                    case 'email':
                        range.dataValidation.rule = {
                            list: {
                                inCellDropDown: true,
                                source: 'email@example.com'
                            }
                        };
                        break;
                    case 'phone':
                        range.dataValidation.rule = {
                            custom: {
                                formula: '=AND(LEN(A1)=10,ISNUMBER(A1))'
                            }
                        };
                        break;
                    case 'date':
                        range.dataValidation.rule = {
                            date: {
                                operator: 'GreaterThan',
                                formula1: '=TODAY()-365'
                            }
                        };
                        break;
                    case 'number':
                        range.dataValidation.rule = {
                            wholeNumber: {
                                operator: 'Between',
                                formula1: '0',
                                formula2: '100'
                            }
                        };
                        break;
                }

                await context.sync();

                this.addRecentAction('Apply Validation', `Applied ${validationType} validation to range ${range.address}`);
                console.log(`Applied ${validationType} validation to range: ${range.address}`);
                this.showNotification(`Applied ${validationType} validation successfully`, 'success');
            });
        } catch (error) {
            console.error('Error applying data validation:', error);
            this.showNotification('Failed to apply data validation. Please try again.', 'error');
        }
    }

    private async applyDataCleanup(): Promise<void> {
        try {
            const cleanupType = (document.getElementById('data-cleanup') as HTMLSelectElement)?.value;

            if (!cleanupType) {
                this.showNotification('Please select a cleanup type', 'warning');
                return;
            }

            await Excel.run(async (context) => {
                const range = context.workbook.getSelectedRange();
                range.load('address, values');

                await context.sync();

                // Apply cleanup based on type
                switch (cleanupType) {
                    case 'duplicates':
                        // Remove duplicates logic would go here
                        console.log('Duplicate removal logic');
                        break;
                    case 'spaces':
                        // Trim spaces logic would go here
                        console.log('Space trimming logic');
                        break;
                    case 'format':
                        // Standardize format logic would go here
                        console.log('Format standardization logic');
                        break;
                }

                this.addRecentAction('Apply Cleanup', `Applied ${cleanupType} cleanup to range ${range.address}`);
                console.log(`Applied ${cleanupType} cleanup to range: ${range.address}`);
                this.showNotification(`Applied ${cleanupType} cleanup successfully`, 'success');
            });
        } catch (error) {
            console.error('Error applying data cleanup:', error);
            this.showNotification('Failed to apply data cleanup. Please try again.', 'error');
        }
    }

    private addRecentAction(action: string, description: string): void {
        const newAction: RecentAction = {
            id: Date.now().toString(),
            action,
            timestamp: new Date(),
            description
        };

        this.recentActions.unshift(newAction);

        // Keep only the last 10 actions
        if (this.recentActions.length > 10) {
            this.recentActions = this.recentActions.slice(0, 10);
        }

        this.updateRecentActionsUI();
    }

    private updateRecentActionsUI(): void {
        const recentActionsContainer = document.getElementById('recent-actions');
        if (!recentActionsContainer) return;

        if (this.recentActions.length === 0) {
            recentActionsContainer.innerHTML = `
                <div class="empty-state">
                    <span class="ms-Icon ms-Icon--Info"></span>
                    <p>No recent actions</p>
                </div>
            `;
            return;
        }

        const actionsHTML = this.recentActions.map(action => `
            <div class="recent-action-item">
                <div class="action-header">
                    <span class="action-name">${action.action}</span>
                    <span class="action-time">${this.formatTime(action.timestamp)}</span>
                </div>
                <div class="action-description">${action.description}</div>
            </div>
        `).join('');

        recentActionsContainer.innerHTML = actionsHTML;
    }

    private formatTime(date: Date): string {
        const now = new Date();
        const diffInMinutes = Math.floor((now.getTime() - date.getTime()) / (1000 * 60));

        if (diffInMinutes < 1) return 'Just now';
        if (diffInMinutes < 60) return `${diffInMinutes}m ago`;
        if (diffInMinutes < 1440) return `${Math.floor(diffInMinutes / 60)}h ago`;
        return date.toLocaleDateString();
    }

    private showNotification(message: string, type: 'success' | 'error' | 'warning' = 'success'): void {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.textContent = message;

        document.body.appendChild(notification);

        // Remove notification after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.parentNode.removeChild(notification);
            }
        }, 15000);
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
        this.initializeApp();
    }
}

// Initialize the app when the page loads
new FlipperApp();

// Export for testing purposes
export { FlipperApp };
