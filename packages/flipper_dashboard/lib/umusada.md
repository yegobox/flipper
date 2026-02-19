# Umusada Integration Specifications

## Overview
Umusada is a platform enabling Flipper users to obtain loans on their orders from respective suppliers. This integration allows users to authenticate with Umusada, register their business, and synchronize business data to establish loan limits.

## Scope
-   **Region**: restricted to Rwanda (RW).
-   **Entry Points**:
    -   A button in the `ribbon.dart` (location to be defined/confirmed).
    -   An option in `EnhancedSideMenu.dart` for businesses to join Umusada.
    -   Joining is **OPTIONAL**. Users can proceed with ordering without joining.

## Authentication Flow

The authentication process involves a two-step mechanism: requesting an OTP and then exchanging it for an access token.

### 1. Request OTP (Login)
User credentials are used to request an OTP.

-   **Endpoint**: `POST https://dev-master-apis.umusada.com/umusada-master-service/auth/login`
-   **Auth**: Basic Auth
    -   Username: `beastar457@gmail.com`
    -   Password: `arsPkt6B`
-   **Response**:
    ```json
    {
        "success": true,
        "message": "OTP Sent Successfully",
        "otpToken": "006JkbykZP5DvHv3a5fz2tFuff3ScU9VoHa4J86hRNveRN2QuTTP9k1zyNss7RwA",
        "expiresAt": "2026-02-18T17:45:33.511+00:00",
        "otp": "443765"
    }
    ```

### 2. Validate OTP & Get Token
Exchange the received OTP and `otpToken` for a Bearer token.

-   **Endpoint**: `POST https://dev-master-apis.umusada.com/umusada-master-service/auth/login-auth2`
-   **Headers**:
    -   `Authorization`: Bearer `<otpToken>` (from Step 1)
-   **Payload**:
    ```json
    {
        "code": "443765" // strict string format
    }
    ```
-   **Response**:
    ```json
    {
        "success": true,
        "message": "Successfully validated",
        "token": "3xbBV2NKdh3eoogeRJUkHZk6Lb0gtJ1JkGJGYfbOhcTK7vVtJ406dgLkftOBnqMM",
        "refreshToken": "2UqqsybRBTPX1aYjRyqO9TMWX6RMrU56LFwzCaG6TmkxtFeRL5AZSLcRay100139",
        "expiresAt": "2026-02-19T17:37:44.153+00:00"
    }
    ```

### 3. Token Management
-   **Storage**: Store `token` and `refreshToken` in Supabase.
-   **Renewal**: Use `refreshToken` to renew the session when the `token` expires.
-   **Check**: Verify token existence before initiating Umusada-related actions. If missing, initiate the login flow.

## Business Registration Flow

Before "Start Ordering", check if the business is registered with Umusada.

1.  **Check**: Has the user joined Umusada?
2.  **Prompt**: If not joined, prompt the user to join to enjoy benefits. **This step is OPTIONAL.** The user can dismiss the prompt and proceed with ordering without joining.
3.  **Registration**:
    -   **Endpoint**: `POST http://umusada-master.umusada.com/umusada-master-service/business/save`
    -   **Headers**:
        -   `Content-Type`: `application/json`
        -   `Authorization`: Bearer `<token>` (from Auth Step 2)
    -   **Payload**:
        ```json
        {
          "id": 0,
          "name": "string",
          "businessTin": "string",
          "category": "MANUFACTURER",
          "status": true,
          "email": "string",
          "phoneNumber": "string",
          "location": "string",
          "registrationCode": "string",
          "valueChain": "string",
          "aggregatorId": 0,
          "classificationId": 0,
          "canSale": true,
          "canPurchase": true,
          "notifications": [
            {
              "key": "string",
              "value": "string"
            }
          ]
        }
        ```
    -   **Purpose**: Registers the business to start sending sales data to Umusada, which allows for loan limit calculation.

## Sales Data Synchronization

Once the business is registered, sales data must be synchronized to Umusada to establish loan limits.

### 1. Send Sales Data (Save)
Send sales data (likely aggregated) to Umusada.

-   **Endpoint**: `POST http://umusada-master.umusada.com/umusada-master-service/sales/save`
-   **Headers**:
    -   `Content-Type`: `application/json`
    -   `Authorization`: Bearer `<token>` (implied/required)
-   **Payload**:
    ```json
    {
      "id": 0,
      "cash": 0,
      "credit": 0,
      "invoiceCount": 0,
      "month": 0,
      "salesValue": 0,
      "totalVal": 0,
      "cost": 0,
      "year": 0,
      "businessId": 0,
      "itemCount": 0,
      "branchId": 0,
      "branchName": "string",
      "supplierId": 0,
      "consumerId": "string"
    }
    ```

### 2. Retrieve Sales Data (List)
Retrieve the list of sales data sent to Umusada (for verification or history).

-   **Endpoint**: `POST http://umusada-master.umusada.com/umusada-master-service/sales/list`
-   **Headers**:
    -   `Content-Type`: `application/json`
    -   `Authorization`: Bearer `<token>` (implied/required)
-   **Payload** (Query Parameters):
    ```json
    {
      "filters": [
        {
          "value": {},
          "operator": "string",
          "field": "branchId"
        }
      ],
      "search": "string",
      "currentPage": 0,
      "pageSize": 0
    }
    ```

### 3. Synchronization Strategy
-   **Interval**: Automatic background synchronization every **30 minutes**.
-   **Manager**: Handled by `CronService`.
-   **Execution**:
    -   Must use `IsolateHandler` (`isolateHandelr.dart`) for heavy HTTP calls to prevent UI blocking.
    -   The `CronService` will trigger the task, but the actual data processing and network request should run in the background isolate.
-   **Trigger**:
    -   Periodic timer.
    -   (Optional) Manual trigger via Settings/Debug menu.

## User Interface Requirements

1.  **Ribbon Integration**:
    -   Add a trigger button in `ribbon.dart`.
2.  **Enhanced Menu**:
    -   Add a menu item for "Join Umusada" in `EnhancedSideMenu.dart`.