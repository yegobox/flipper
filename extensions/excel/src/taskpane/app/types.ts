export interface RecentAction {
    id: string;
    action: string;
    timestamp: Date;
    description: string;
}

export interface FlipperUser {
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

export interface FlipperTenant {
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

export interface FlipperBranch {
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
    branch_id?: string;
    branchId?: string;
}

export interface FlipperBusiness {
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

export type NotificationType = 'success' | 'error' | 'warning';

