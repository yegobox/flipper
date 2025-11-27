import { UiManager } from './UiManager';
import { RecentAction } from './types';

export class RecentActionsManager {
    private recentActions: RecentAction[] = [];

    constructor(private readonly uiManager: UiManager, private readonly maxActions = 10) {}

    add(action: string, description: string): void {
        const newAction: RecentAction = {
            id: Date.now().toString(),
            action,
            timestamp: new Date(),
            description
        };

        this.recentActions.unshift(newAction);
        if (this.recentActions.length > this.maxActions) {
            this.recentActions = this.recentActions.slice(0, this.maxActions);
        }

        this.uiManager.renderRecentActions(this.recentActions);
    }

    clear(): void {
        this.recentActions = [];
        this.uiManager.renderRecentActions(this.recentActions);
    }

    getAll(): RecentAction[] {
        return this.recentActions;
    }
}

