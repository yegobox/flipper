import { SupabaseClient } from '@supabase/supabase-js';
import { UiManager } from './UiManager';
import {  ENV } from '../env';
import { FlipperUser } from './types';

interface AuthManagerDeps {
    apiBaseUrl: string;
    supabase: SupabaseClient;
    uiManager: UiManager;
    onAuthSuccess: () => void;
    onUserChange: (user: FlipperUser | null) => void;
}

export class AuthManager {
    private currentUser: FlipperUser | null = null;
    private authToken: string | null = null;

    constructor(private readonly deps: AuthManagerDeps) {
        this.registerAuthMethodListener();
    }

    async initializeFromStorage(): Promise<void> {
        const savedToken = localStorage.getItem('flipper_auth_token');
        if (!savedToken) {
            return;
        }

        this.authToken = savedToken;
        await this.validateToken();
    }

    getCurrentUser(): FlipperUser | null {
        return this.currentUser;
    }

    getAuthToken(): string | null {
        return this.authToken;
    }

    async handleLogin(event: Event): Promise<void> {
        event.preventDefault();

        const form = event.target as HTMLFormElement;
        const formData = new FormData(form);
        const pin = (formData.get('pin') as string) || '';
        const otpCode = (formData.get('otpCode') as string) || '';

        if (!pin) {
            this.deps.uiManager.showError('Enter your PIN');
            return;
        }

        const otpFieldSection = document.getElementById('otp-field-section');
        const showingOtp = otpFieldSection && otpFieldSection.style.display !== 'none';

        try {
            this.deps.uiManager.setLoginButtonLoading(true);
            this.deps.uiManager.hideError();

            if (showingOtp) {
                if (!otpCode || otpCode.length !== 6) {
                    this.deps.uiManager.showError('Please enter a valid 6-digit code');
                    return;
                }

                const authMethod = this.deps.uiManager.getSelectedAuthMethod();
                if (authMethod === 'authenticator') {
                    await this.verifyTotpAndLogin(pin, otpCode);
                } else {
                    await this.verifySmsOtpAndLogin(pin, otpCode);
                }

                this.deps.onAuthSuccess();
                this.deps.uiManager.showNotification('Successfully connected to Flipper', 'success');
                return;
            }

            const authMethod = this.deps.uiManager.getSelectedAuthMethod();
            if (authMethod === 'sms') {
                const response = await this.requestSmsOtp(pin);
                if (response.requiresOtp) {
                    this.deps.uiManager.showOtpField(authMethod);
                    this.deps.uiManager.updateLoginButtonText('Verify & Sign In');
                } else {
                    this.deps.uiManager.showError('OTP is required for login');
                }
            } else {
                this.deps.uiManager.showOtpField(authMethod);
                this.deps.uiManager.updateLoginButtonText('Verify & Sign In');
            }
        } catch (error) {
            console.error('Authentication failed:', error);
            const errorMessage = error instanceof Error ? error.message : 'Authentication failed. Please try again.';
            this.deps.uiManager.showError(errorMessage);
        } finally {
            this.deps.uiManager.setLoginButtonLoading(false);
        }
    }

    clearAuthData(): void {
        this.currentUser = null;
        this.authToken = null;
        localStorage.removeItem('flipper_auth_token');
        localStorage.removeItem('flipper_user_data');
        this.deps.onUserChange(null);
    }

    private async validateToken(): Promise<void> {
        if (!this.authToken) {
            throw new Error('No auth token available');
        }

        try {
            const savedUserData = localStorage.getItem('flipper_user_data');
            if (!savedUserData) {
                throw new Error('No saved user data found');
            }

            const userData: FlipperUser = JSON.parse(savedUserData);
            this.currentUser = userData;
            this.deps.onUserChange(this.currentUser);
            console.log('User data restored successfully:', userData.name);
        } catch (error) {
            console.error('Token validation failed:', error);
            this.clearAuthData();
            throw error;
        }
    }

    private async authenticateUser(phoneNumber: string): Promise<void> {

        let formattedPhone = phoneNumber;
        if (!phoneNumber.startsWith('+') && !phoneNumber.includes('@')) {
            formattedPhone = '+' + phoneNumber;
        }

        const response = await fetch(`${this.deps.apiBaseUrl}/v2/api/user`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': ENV.BASIC_AUTH
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

        localStorage.setItem('flipper_auth_token', userData.token);
        localStorage.setItem('flipper_user_data', JSON.stringify(userData));

        console.log('User authenticated successfully:', userData.name);
        this.deps.onUserChange(this.currentUser);
    }

    private async requestSmsOtp(pin: string): Promise<{ requiresOtp: boolean }> {
        const response = await fetch(`${this.deps.apiBaseUrl}/v2/api/login/pin`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ pin })
        });

        if (!response.ok) {
            throw new Error('Failed to request OTP');
        }

        return response.json();
    }

    private async verifySmsOtpAndLogin(pin: string, otp: string): Promise<void> {
        const response = await fetch(`${this.deps.apiBaseUrl}/v2/api/login/verify-otp`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': ENV.BASIC_AUTH
            },
            body: JSON.stringify({ pin, otp })
        });

        if (!response.ok) {
            const errorData = await response.json().catch(() => ({ error: 'Invalid OTP code' }));
            throw new Error(errorData.error || 'Failed to verify OTP');
        }

        const responseData = await response.json();
        await this.authenticateUser(responseData.phoneNumber);
    }

    private async verifyTotpAndLogin(pin: string, totpCode: string): Promise<void> {
        this.deps.uiManager.showNotification('Verifying authenticator code...');

        const pinResponse = await fetch(`${this.deps.apiBaseUrl}/v2/api/pin/${pin}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': ENV.BASIC_AUTH
            }
        });

        if (!pinResponse.ok) {
            throw new Error('Invalid PIN. Please re-enter and try again.');
        }

        const pinData = await pinResponse.json();
        const numericUserId = parseInt(pin, 10);
        const phoneNumber = pinData.phoneNumber || pinData.phone_number;

        if (!phoneNumber) {
            throw new Error('Could not retrieve Phone Number from PIN.');
        }

        const { data, error } = await this.deps.supabase
            .from('user_mfa_secrets')
            .select('secret')
            .eq('user_id', numericUserId)
            .limit(1)
            .single();

        if (error || !data) {
            this.deps.uiManager.showNotification('Error fetching TOTP secret: ' + error?.message, 'error');
            throw new Error('TOTP not configured for this account.');
        }

        const isValid = this.verifyTotpCode(data.secret, totpCode);
        if (!isValid) {
            throw new Error('Invalid authenticator code. Please try again.');
        }

        await this.authenticateUser(phoneNumber);
    }

    private verifyTotpCode(secret: string, code: string): boolean {
        try {
            const cleanSecret = secret.replace(/[^A-Z2-7]/g, '');
            const cleanCode = code.replace(/[^0-9]/g, '');
            const { TOTP } = require('otpauth');

            const totp = new TOTP({
                issuer: 'Flipper',
                label: 'User',
                algorithm: 'SHA1',
                digits: 6,
                period: 30,
                secret: cleanSecret
            });

            const currentTime = Math.floor(Date.now() / 1000);
            const windows = [0, -30, 30];

            return windows.some((offset) => {
                const token = totp.generate({ timestamp: (currentTime + offset) * 1000 });
                return token === cleanCode;
            });
        } catch (error) {
            console.error('TOTP verification error:', error);
            return false;
        }
    }

    private registerAuthMethodListener(): void {
        this.deps.uiManager.setupAuthMethodChangeListener(async (method) => {
            const otpLabel = document.getElementById('otp-label');
            const otpInput = document.getElementById('otp-code') as HTMLInputElement | null;

            if (otpLabel) {
                otpLabel.textContent = method === 'sms' ? 'SMS Code' : 'Authenticator Code';
            }

            if (otpInput) {
                otpInput.value = '';
            }

            if (method === 'sms') {
                const pinInput = document.getElementById('pin-input') as HTMLInputElement | null;
                if (pinInput?.value) {
                    try {
                        await this.requestSmsOtp(pinInput.value);
                        this.deps.uiManager.showNotification('SMS code sent', 'success');
                    } catch (error) {
                        console.error('Failed to send SMS:', error);
                    }
                }
            }
        });
    }
}


