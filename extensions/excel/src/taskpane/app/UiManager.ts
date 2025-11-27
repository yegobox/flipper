import { FlipperBranch, FlipperTenant, FlipperUser, NotificationType, RecentAction } from './types';

export class UiManager {
    showLoadingState(): void {
        this.toggleDisplay('loading-state', 'flex');
        this.toggleDisplay('app-container', 'none');
        this.toggleDisplay('error-state', 'none');
        this.toggleDisplay('auth-state', 'none');
    }

    hideLoadingState(): void {
        this.toggleDisplay('loading-state', 'none');
    }

    showAppContainer(): void {
        this.toggleDisplay('app-container', 'flex');
        this.toggleDisplay('auth-state', 'none');
        this.toggleDisplay('loading-state', 'none');
        this.toggleDisplay('error-state', 'none');
    }

    showAuthState(): void {
        this.toggleDisplay('auth-state', 'flex');
        this.toggleDisplay('app-container', 'none');
        this.toggleDisplay('loading-state', 'none');
        this.toggleDisplay('error-state', 'none');
    }

    showErrorState(message: string): void {
        const errorState = document.getElementById('error-state');
        const errorMessage = document.getElementById('error-message');
        if (errorMessage) errorMessage.textContent = message;
        if (errorState) errorState.style.display = 'flex';
        this.toggleDisplay('loading-state', 'none');
        this.toggleDisplay('app-container', 'none');
        this.toggleDisplay('auth-state', 'none');
    }

    showError(message: string): void {
        const errorElement = document.getElementById('error-message');
        const errorText = document.getElementById('error-text');
        if (errorElement && errorText) {
            errorText.textContent = message;
            errorElement.style.display = 'flex';
        }
    }

    hideError(): void {
        const errorElement = document.getElementById('error-message');
        if (errorElement) {
            errorElement.style.display = 'none';
        }
    }

    setLoginButtonLoading(loading: boolean): void {
        const button = document.getElementById('login-submit-btn') as HTMLButtonElement | null;
        const buttonText = document.getElementById('login-button-text');
        if (!button || !buttonText) return;

        button.disabled = loading;
        if (loading) {
            buttonText.innerHTML = '<span class="spinner"></span> Processing...';
            return;
        }

        const otpFieldSection = document.getElementById('otp-field-section');
        const showingOtp = otpFieldSection && otpFieldSection.style.display !== 'none';
        buttonText.textContent = showingOtp ? 'Verify & Sign In' : 'Connect to Flipper';
    }

    updateLoginButtonText(text: string): void {
        const buttonText = document.getElementById('login-button-text');
        if (buttonText) {
            buttonText.textContent = text;
        }
    }

    showOtpField(authMethod: 'authenticator' | 'sms'): void {
        const otpMethodSection = document.getElementById('otp-method-section');
        const otpFieldSection = document.getElementById('otp-field-section');
        const otpLabel = document.getElementById('otp-label');

        if (otpMethodSection) otpMethodSection.style.display = 'block';
        if (otpFieldSection) otpFieldSection.style.display = 'block';
        if (otpLabel) {
            otpLabel.textContent = authMethod === 'authenticator' ? 'Authenticator Code' : 'SMS Code';
        }

        this.focusOtpInput();
    }

    focusOtpInput(): void {
        const otpInput = document.getElementById('otp-code') as HTMLInputElement | null;
        if (otpInput) {
            setTimeout(() => otpInput.focus(), 100);
        }
    }

    setupAuthMethodChangeListener(onMethodChange: (method: 'authenticator' | 'sms') => void): void {
        const authMethodRadios = document.getElementsByName('authMethod') as NodeListOf<HTMLInputElement>;
        Array.from(authMethodRadios).forEach((radio) => {
            radio.addEventListener('change', () => {
                onMethodChange(radio.value as 'authenticator' | 'sms');
            });
        });
    }

    getSelectedAuthMethod(): 'authenticator' | 'sms' {
        const authMethodRadios = document.getElementsByName('authMethod') as NodeListOf<HTMLInputElement>;
        for (const radio of Array.from(authMethodRadios)) {
            if (radio.checked) {
                return radio.value as 'authenticator' | 'sms';
            }
        }
        return 'authenticator';
    }

    updateStatusBar(message: string, isLoading: boolean): void {
        const statusText = document.getElementById('status-text');
        const statusSpinner = document.getElementById('status-spinner');
        if (statusText) {
            statusText.textContent = message;
        }
        if (statusSpinner) {
            statusSpinner.style.display = isLoading ? 'inline-block' : 'none';
        }
    }

    showNotification(message: string, type: NotificationType = 'success'): void {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.textContent = message;
        document.body.appendChild(notification);
        setTimeout(() => notification.parentNode?.removeChild(notification), 15000);
    }

    updateUserName(user: FlipperUser): void {
        const userNameElement = document.getElementById('user-name');
        if (userNameElement) {
            userNameElement.textContent = user.name || user.phoneNumber;
        }
    }

    updateTenantAndBusiness(tenant: FlipperTenant | null, businessName: string | null): void {
        const tenantNameElement = document.getElementById('tenant-name');
        if (tenantNameElement && tenant) {
            tenantNameElement.textContent = tenant.name;
        }

        const businessNameElement = document.getElementById('business-name');
        if (businessNameElement) {
            businessNameElement.textContent = businessName || 'N/A';
        }
    }

    setBranchOptions(branches: FlipperBranch[], selectedBranchId?: string): void {
        const branchSelector = document.getElementById('branch-selector') as HTMLSelectElement | null;
        if (!branchSelector) return;

        branchSelector.innerHTML = '<option value="">Select a branch...</option>';
        branches.forEach((branch) => {
            const option = document.createElement('option');
            option.value = branch.id;
            option.textContent = branch.name;
            branchSelector.appendChild(option);
        });

        if (selectedBranchId) {
            branchSelector.value = selectedBranchId;
        }
    }

    bindBranchSelector(handler: (event: Event) => void): void {
        const branchSelector = document.getElementById('branch-selector');
        branchSelector?.addEventListener('change', handler);
    }

    renderRecentActions(actions: RecentAction[]): void {
        const recentActionsContainer = document.getElementById('recent-actions');
        if (!recentActionsContainer) return;

        if (!actions.length) {
            recentActionsContainer.innerHTML = `
                <div class="empty-state">
                    <span class="ms-Icon ms-Icon--Info"></span>
                    <p>No recent actions</p>
                </div>
            `;
            return;
        }

        const actionsHTML = actions
            .map(
                (action) => `
            <div class="recent-action-item">
                <div class="action-header">
                    <span class="action-name">${action.action}</span>
                    <span class="action-time">${this.formatTime(action.timestamp)}</span>
                </div>
                <div class="action-description">${action.description}</div>
            </div>
        `
            )
            .join('');

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

    private toggleDisplay(elementId: string, value: string): void {
        const el = document.getElementById(elementId);
        if (el) {
            el.style.display = value;
        }
    }
}

