## Payroll Feature Design for Flipper

**Goal:** To provide comprehensive employee management, time tracking, payroll processing, and reporting functionalities, integrated seamlessly with Flipper's existing POS and accounting modules.

**Inspiration (Toast POS):** Focus on intuitive time tracking, automated wage calculation, deduction management, and clear reporting.

---

### Phase 1: Core Data Models (packages/accounting_models or new packages/payroll_models)

Following the `brick_offline_first_with_supabase` pattern.

*   **Employee:**
    *   `id` (String, PK)
    *   `businessId` (int)
    *   `name` (String)
    *   `employeeId` (String, unique, for external systems)
    *   `role` (String, e.g., 'Cashier', 'Manager')
    *   `payRateType` (Enum: Hourly, Salary)
    *   `hourlyRate` (double, nullable)
    *   `salary` (double, nullable)
    *   `taxInformation` (JSON/Map, e.g., TIN, social security)
    *   `contactInfo` (JSON/Map, e.g., phone, email, address)
    *   `isActive` (bool)
    *   `hireDate` (DateTime)
    *   `terminationDate` (DateTime, nullable)
*   **TimeEntry:**
    *   `id` (String, PK)
    *   `employeeId` (String, FK to Employee)
    *   `businessId` (int)
    *   `clockInTime` (DateTime)
    *   `clockOutTime` (DateTime, nullable)
    *   `breakStartTime` (DateTime, nullable)
    *   `breakEndTime` (DateTime, nullable)
    *   `durationMinutes` (double, calculated)
    *   `isApproved` (bool)
    *   `notes` (String, nullable)
*   **PayPeriod:**
    *   `id` (String, PK)
    *   `businessId` (int)
    *   `startDate` (DateTime)
    *   `endDate` (DateTime)
    *   `status` (Enum: Open, Closed, Processed)
*   **Deduction/BenefitType:**
    *   `id` (String, PK)
    *   `businessId` (int)
    *   `name` (String, e.g., 'Income Tax', 'Health Insurance')
    *   `type` (Enum: Deduction, Benefit)
    *   `calculationMethod` (Enum: FixedAmount, PercentageOfGross, PerHour)
    *   `amountOrRate` (double)
    *   `isTaxable` (bool)
*   **EmployeeDeduction/Benefit:**
    *   `id` (String, PK)
    *   `employeeId` (String, FK to Employee)
    *   `deductionBenefitTypeId` (String, FK to Deduction/BenefitType)
    *   `amount` (double, actual amount applied for a period)
    *   `payPeriodId` (String, FK to PayPeriod)
*   **PayrollRun:**
    *   `id` (String, PK)
    *   `businessId` (int)
    *   `payPeriodId` (String, FK to PayPeriod)
    *   `runDate` (DateTime)
    *   `status` (Enum: Draft, Completed, Reversed)
    *   `totalGrossPay` (double)
    *   `totalNetPay` (double)
    *   `totalDeductions` (double)
*   **Paystub:**
    *   `id` (String, PK)
    *   `payrollRunId` (String, FK to PayrollRun)
    *   `employeeId` (String, FK to Employee)
    *   `payPeriodId` (String, FK to PayPeriod)
    *   `grossPay` (double)
    *   `netPay` (double)
    *   `hoursWorked` (double)
    *   `overtimeHours` (double)
    *   `deductionsSummary` (JSON/Map of deduction details)
    *   `tipsReceived` (double, from POS integration)

### Phase 2: Backend Services (packages/flipper_services)

Following Flipper's established pattern, each service will be defined by an **interface** and implemented by a **mixin**. The `ProxyService.strategy` will then expose these functionalities.

*   **EmployeeInterface (in packages/flipper_models/sync/interfaces)**
    *   `abstract class EmployeeInterface { ... }`
*   **EmployeeMixin (in packages/flipper_models/sync/mixins)**
    *   `mixin EmployeeMixin implements EmployeeInterface { Repository get repository; ... }`
*   **EmployeeService (exposed via ProxyService.strategy)**
    *   `ProxyService.strategy.employees(...)`
    *   CRUD operations for `Employee` profiles.
    *   Assign roles and pay rates.

*   **TimeTrackingInterface (in packages/flipper_models/sync/interfaces)**
    *   `abstract class TimeTrackingInterface { ... }`
*   **TimeTrackingMixin (in packages/flipper_models/sync/mixins)**
    *   `mixin TimeTrackingMixin implements TimeTrackingInterface { Repository get repository; ... }`
*   **TimeTrackingService (exposed via ProxyService.strategy)**
    *   `ProxyService.strategy.timeTracking.clockIn(employeeId)`: Records clock-in.
    *   `ProxyService.strategy.timeTracking.clockOut(employeeId)`: Records clock-out, calculates duration.
    *   `ProxyService.strategy.timeTracking.startBreak(employeeId)`, `endBreak(employeeId)`: Manage breaks.
    *   `ProxyService.strategy.timeTracking.adjustTimeEntry(timeEntryId, newTimes)`: For manager adjustments.
    *   `ProxyService.strategy.timeTracking.getTimeEntries(employeeId, payPeriodId)`: Retrieve time entries.

*   **PayPeriodInterface (in packages/flipper_models/sync/interfaces)**
    *   `abstract class PayPeriodInterface { ... }`
*   **PayPeriodMixin (in packages/flipper_models/sync/mixins)**
    *   `mixin PayPeriodMixin implements PayPeriodInterface { Repository get repository; ... }`
*   **PayPeriodService (exposed via ProxyService.strategy)**
    *   `ProxyService.strategy.payPeriods.createPayPeriod(startDate, endDate)`: Sets up new pay period.
    *   `ProxyService.strategy.payPeriods.closePayPeriod(payPeriodId)`: Locks a pay period for processing.
    *   `ProxyService.strategy.payPeriods.getOpenPayPeriod(businessId)`: Retrieves current open period.

*   **PayrollCalculationInterface (in packages/flipper_models/sync/interfaces)**
    *   `abstract class PayrollCalculationInterface { ... }`
*   **PayrollCalculationMixin (in packages/flipper_models/sync/mixins)**
    *   `mixin PayrollCalculationMixin implements PayrollCalculationInterface { Repository get repository; ... }`
*   **PayrollCalculationService (exposed via ProxyService.strategy)**
    *   `ProxyService.strategy.payrollCalculation.calculateGrossPay(employeeId, payPeriodId)`: Calculates regular and overtime wages.
    *   `ProxyService.strategy.payrollCalculation.calculateDeductions(employeeId, payPeriodId)`: Applies all relevant deductions/benefits.
    *   `ProxyService.strategy.payrollCalculation.calculateNetPay(grossPay, deductions)`: Calculates net pay.
    *   `ProxyService.strategy.payrollCalculation.processPayrollRun(payPeriodId)`: Orchestrates the full payroll calculation for all employees in a period, creates `PayrollRun` and `Paystub` records.

*   **PayrollReportingInterface (in packages/flipper_models/sync/interfaces)**
    *   `abstract class PayrollReportingInterface { ... }`
*   **PayrollReportingMixin (in packages/flipper_models/sync/mixins)**
    *   `mixin PayrollReportingMixin implements PayrollReportingInterface { Repository get repository; ... }`
*   **PayrollReportingService (exposed via ProxyService.strategy)**
    *   `ProxyService.strategy.payrollReporting.generatePayrollSummary(payPeriodId)`: Summary of gross/net pay, deductions for all employees.
    *   `ProxyService.strategy.payrollReporting.generateTimecardReport(employeeId, payPeriodId)`: Detailed time entries.
    *   `ProxyService.strategy.payrollReporting.generateTaxReport(payPeriodId)`: Summaries for tax filings.

### Phase 3: User Interface (packages/flipper_dashboard or new packages/flipper_payroll)

*   **Employee Management Screen:**
    *   List of employees with search/filter.
    *   Add/Edit employee profiles (name, role, pay rate, contact, tax info).
    *   Activate/Deactivate employees.
*   **Time Clock Interface:**
    *   Simple clock-in/out buttons for employees (could be on POS screen or dedicated app).
    *   Break start/end.
*   **Timecard Review Screen (Manager View):**
    *   List of time entries for a selected pay period/employee.
    *   Ability to approve, edit, or add missing time entries.
*   **Payroll Processing Workflow:**
    *   Select pay period to process.
    *   Review calculated payroll (gross, net, deductions).
    *   Initiate payroll run.
    *   View `PayrollRun` history.
*   **Paystub View (Employee Portal/App):**
    *   Employees can securely view their historical paystubs.

#### 3.1. App Integration & Navigation

To integrate the Payroll feature seamlessly into Flipper's multi-app environment:

*   **App Registration:** The Payroll application will be registered as a distinct application within Flipper's app management system. This will allow it to appear in the "Choose Your Default App" dialog (`DialogType.appChoice`).
*   **Main Menu Access (EnhancedSideMenu):** A new menu item will be added to the `EnhancedSideMenu` (in `packages/flipper_dashboard/lib/EnhancedSideMenu.dart`) to provide direct access to the Payroll dashboard. This menu item will likely be permission-gated (e.g., only visible to managers or administrators).
    *   **Menu Item:** "Payroll"
    *   **Icon:** (To be determined, e.g., `Icons.people_alt`, `FluentIcons.money_24_regular`)
    *   **Navigation:** Tapping this item will navigate to the main Payroll dashboard screen (e.g., `PayrollDashboardRoute`).
*   **Routing:** Define new routes for all major Payroll screens (Employee Management, Timecard Review, Payroll Processing, Paystub View) within `packages/flipper_routing/app.router.dart`.

#### 3.2. Dialog Integration

Specific payroll-related dialogs will be registered in `packages/flipper_routing/lib/app.dialogs.dart` to allow for consistent and centralized management of dialogs across the application.

*   **`DialogType.payroll`:** A generic dialog type for launching various payroll-related modals (e.g., "Add Employee", "Edit Time Entry", "Confirm Payroll Run"). This will act as a dispatcher to specific payroll dialog widgets.
    *   **Example Usage:** `_dialogService.showCustomDialog(variant: DialogType.payroll, data: { 'type': 'addEmployee' });`
*   **Specific Payroll Dialogs:**
    *   **Clock-in/Clock-out Dialog:** For employees to record their time.
    *   **Shift Review/Approval Dialog:** For managers to review and approve time entries.
    *   **Payroll Run Confirmation Dialog:** To confirm final payroll processing.

#### 3.3. Mobile vs. Desktop Layout Considerations

The Payroll feature will be designed with a responsive UI to provide an optimal experience across various screen sizes and device types (mobile phones, tablets, and desktop).

*   **App Icon Integration (packages/flipper_dashboard/lib/apps.dart):**
    *   A dedicated icon for the Payroll application will be added to the `AppIconsGrid` widget in `packages/flipper_dashboard/lib/apps.dart`. This will serve as the primary entry point for users to launch the Payroll module from the main Flipper dashboard.
    *   The icon will be visually distinct and clearly represent the payroll functionality.

*   **Responsive Layout Strategy:**
    *   **Mobile (Simplified View):** On smaller screens (phones), the interface will prioritize essential and frequently used functionalities.
        *   **Time Clock:** A prominent, easy-to-use clock-in/out interface will be a primary focus.
        *   **Basic Employee Overview:** Quick access to employee lists with minimal details.
        *   **Paystub Access:** Employees can easily view their own paystubs.
        *   **Navigation:** Tab-based or bottom navigation for quick switching between core sections.
    *   **Desktop (Comprehensive View):** On larger screens (tablts, desktops), the interface will offer a more detailed and comprehensive view of all payroll functionalities.
        *   **Dashboard:** A rich dashboard summarizing payroll status, upcoming runs, and key metrics.
        *   **Detailed Tables:** Full tables for employee management, timecard review, and payroll runs with extensive filtering, sorting, and editing capabilities.
        *   **Sidebars/Panels:** Utilize multi-panel layouts for simultaneous viewing of related information (e.g., employee list on one side, detailed profile on the other).
        *   **Reporting:** Full access to all detailed payroll reports with export options.
    *   **Adaptive Components:** UI components (e.g., forms, tables) will adapt their presentation based on available screen real estate, collapsing or expanding details as needed.

*   **User Roles and Permissions:** The visibility and functionality of certain UI elements will be dynamically controlled based on the user's role (e.g., employees might only see their time clock and paystubs, while managers have full access).

### Phase 4: Reporting (packages/flipper_accounting or new packages/flipper_payroll)

*   **Payroll Summary Report:** Overview of payroll costs per period.
*   **Detailed Timecard Report:** Breakdown of hours worked, overtime, breaks.
*   **Deductions Report:** Summary of all deductions applied.
*   **Tax Liability Report:** Aggregated tax amounts for filing.

### Phase 5: Integrations

*   **POS Integration:**
    *   Automatically pull tips data from POS transactions into `TimeEntry` or `Paystub`.
    *   (Future) Commission calculations based on sales.
*   **Accounting Integration:**
    *   Automatically generate `JournalEntry` records in the accounting module for payroll expenses (e.g., Debit: Wages Expense, Credit: Cash/Payroll Payable, Taxes Payable).
*   **User Management:** Leverage existing Flipper user authentication for employee access.

---

### Gaps and Future Enhancements

#### Data Models

*   **Employee:**
    *   Add `employeeType` (e.g., full-time, part-time, contractor) for compliance and benefits.
    *   Include `paymentMethod` (e.g., bank transfer, check) and `bankAccountDetails` for direct deposit.
    *   Add `emergencyContact` information.
    *   Consider a dedicated `EmployeeTaxInfo` model for structured tax data and validation.
*   **TimeEntry:**
    *   Add `timeEntryType` (e.g., regular hours, overtime, sick leave, vacation) for accurate calculation.
    *   Consider `location` (GPS coordinates or branch ID) for clock-in/out validation.
    *   Add `shiftId` if shifts are managed separately.
*   **PayPeriod:**
    *   Link `PayPeriod` to a `payFrequency` (e.g., weekly, bi-weekly, monthly) defined at the Business level.
*   **Deduction/BenefitType:**
    *   Include `effectiveDate` and `endDate` for deductions/benefits.
    *   Differentiate between `isPreTax` and `postTax` deductions.
    *   Add `limits` (e.g., maximum contribution for a benefit).
*   **EmployeeDeduction/Benefit:**
    *   Add `status` for the application of a deduction (e.g., applied, pending, failed).
*   **PayrollRun:**
    *   Add `payrollProcessor` (who initiated the run).
    *   Make `status` more granular (e.g., 'Calculated', 'Approved', 'Paid', 'Filed').
*   **Paystub:**
    *   Include detailed breakdown of `grossPay` components (e.g., regular hours pay, overtime pay, bonus).
    *   Add `employerContributions` (e.g., employer portion of taxes, benefits).
    *   Add `payDate` (when the employee is actually paid).

#### Backend Services

*   **General:**
    *   Explicitly define **validation logic** within services (e.g., ensuring clock-out is after clock-in, preventing negative pay).
    *   Develop a clear strategy for **transaction management** for complex operations (e.g., ensuring all `Paystub` records are created or none are).
    *   Implement **asynchronous processing** for heavy payroll calculations.
*   **TimeTrackingService:**
    *   Implement `autoClockOut` mechanism for forgotten clock-outs.
    *   Consider geofencing capabilities for clock-in/out.
*   **PayrollCalculationService:**
    *   Develop a detailed strategy for **tax calculation** (highly jurisdiction-dependent and complex), potentially with a dedicated sub-service or integration.
    *   Handle **bonuses, commissions, and other irregular payments**.
    *   Handle **reimbursements**.
    *   Support **multiple pay frequencies** within a single business.
*   **PayrollReportingService:**
    *   Specify **export formats** (PDF, CSV) for reports.

#### User Interface

*   **General:**
    *   Implement **notifications** (e.g., "Payroll run complete", "Timecard needs approval").
    *   Implement **audit trails** for changes (e.g., who approved a time entry, who ran payroll).
*   **Time Clock Interface:**
    *   Implement PIN-based clock-in/out for security.
    *   Consider biometric authentication (fingerprint/face ID) for clock-in/out.
*   **Timecard Review Screen:**
    *   Implement bulk approval/rejection of time entries.
*   **Payroll Processing Workflow:**
    *   Add preview of paystubs before finalization.
    *   Implement rollback/reversal of a payroll run.
*   **Mobile vs. Desktop Layout Considerations:**
    *   Explicitly mention **offline capabilities** for time tracking on mobile.

#### Reporting

*   **General:**
    *   Allow for **customizable reports**.
    *   Include **data visualization** (charts, graphs) for trends.
    *   Add ability to filter reports by date range, employee, department.

#### Integrations

*   **General:**
    *   Plan for integration with **tax authorities** for direct filing (e.g., e-filing).
    *   Plan for integration with **banks** for direct deposit.
    *   Consider integration with **HR systems** for employee data sync.
    *   Consider integration with **third-party benefits providers**.

#### Overarching Considerations

*   **Compliance:** Explicitly address compliance with local labor laws and tax regulations.
*   **Security:** Detail plan for data encryption at rest and in transit for sensitive payroll data. Implement granular access control.
*   **Scalability:** Design considerations for handling a large number of employees or businesses.
*   **Error Handling & Logging:** Robust error handling and detailed logging for all payroll processes.
*   **Testing Strategy:** Include specific mention of payroll calculation accuracy tests and regression testing for compliance changes.
*   **Internationalization/Localization:** Address how payroll rules vary significantly by country.
*   **User Roles & Permissions (Granularity):** Provide a more detailed breakdown of permissions.
