# Modification Implementation Plan: Robust Payment Confirmation Flow

This document outlines the detailed, phased plan to implement the robust digital payment confirmation flow as described in `MODIFICATION_DESIGN.md`.

After completing a task, if any TODOs were added to the code or if anything was not fully implemented, I will add new tasks to this plan to ensure they are completed later.

## Journal

*This section will be updated in chronological order after each phase to log actions taken, things learned, surprises, and any deviations from the plan.*

---

## Phase 1: Setup and UI State Refactoring in `bottomSheet.dart`

The goal of this phase is to refactor the `_BottomSheetContent` widget to use a state machine for its charge button, making it capable of representing all states of the payment flow.

- [ ] Run all tests to ensure the project is in a good state before starting modifications.
- [ ] In `packages/flipper_dashboard/lib/bottomSheet.dart`, define the `enum ChargeButtonState { initial, waitingForPayment, printingReceipt, failed }`.
- [ ] In the `_BottomSheetContentState` class, replace the `_isLoading` and `_isWaitingForPayment` booleans with a single state variable: `ChargeButtonState _chargeState = ChargeButtonState.initial;`.
- [ ] Update the charge `ElevatedButton` widget in the `_buildTotalSection` method to render its style, text, and child widgets based on the `_chargeState` variable.
- [ ] Modify the `_handleCharge` function to set `_chargeState = ChargeButtonState.waitingForPayment;` immediately after the initial phone number validation.
- [ ] Temporarily adjust the `widget.onCharge` call inside `_handleCharge` to account for the new callback signatures that will be added in the next phase. This may result in temporary analysis errors.
- [ ] **Verification for Phase 1:**
    - [ ] Create/modify unit or widget tests for the new button states in `bottomSheet.dart`, if feasible within the existing test structure.
    - [ ] Run the `dart_fix --apply` tool to clean up the code.
    - [ ] Run the `analyze_files` tool and fix any new issues.
    - [ ] Run all relevant tests (`flutter test`) to ensure they all pass.
    - [ ] Run `dart_format .` to correct formatting.
    - [ ] Re-read this `MODIFICATION_IMPLEMENTATION.md` file to check for any changed requirements.
    - [ ] Update the "Journal" section of this file with the actions taken, learnings, and any deviations.
    - [ ] Use `git diff` to verify the changes made in this phase, create a suitable commit message, and present it to you for approval.
    - [ ] Wait for your approval before committing the changes and moving to the next phase.
    - [ ] After committing, if an app is running, use the `hot_reload` tool to reload it.

---

## Phase 2: Connecting the Backend Logic in `previewCart.dart`

This phase focuses on updating the backend logic to communicate payment status changes back to the UI using callbacks.

- [ ] In `packages/flipper_dashboard/lib/mixins/previewCart.dart`, update the function signature of `startCompleteTransactionFlow` to accept `Function onPaymentConfirmed` and `Function onPaymentFailed`.
- [ ] Pass these callbacks down to the `_processDigitalPayment` function.
- [ ] Inside the `subscribeToRealtime` listener in `_processDigitalPayment`:
    - When a `completed` status is received, invoke the `onPaymentConfirmed()` callback.
    - In the `onError` block, invoke the `onPaymentFailed()` callback.
    - Implement a 60-second timeout on the listener. If the timeout occurs, invoke `onPaymentFailed()`.
- [ ] Search the codebase to find where `startCompleteTransactionFlow` is called. This will likely be in the parent widget that builds `BottomSheet`. Update the call site to pass the new `onPaymentConfirmed` and `onPaymentFailed` callbacks from `_BottomSheetContent`.
- [ ] **Verification for Phase 2:**
    - [ ] Create/modify unit tests for the `startCompleteTransactionFlow` function to verify the callbacks are invoked correctly.
    - [ ] Run the `dart_fix --apply` tool.
    - [ ] Run the `analyze_files` tool and fix any issues.
    - [ ] Run all tests to ensure they pass.
    - [ ] Run `dart_format .`.
    - [ ] Re-read this `MODIFICATION_IMPLEMENTATION.md` file.
    - [ ] Update the "Journal" section.
    - [ ] Use `git diff` to verify changes, create a commit message, and present it for approval.
    - [ ] Wait for approval before committing.
    - [ ] After committing, use `hot_reload` if applicable.

---

## Phase 3: Finalization and Documentation

This final phase is for cleaning up, documenting, and final verification.

- [ ] Review all the changes made in the previous phases to ensure they are correct, robust, and align with the design document.
- [ ] Remove any temporary code or `// TODO` comments added during development.
- [ ] Update the `Features/GEMINI.md` file if any of the architectural descriptions have changed as a result of this modification.
- [ ] **Final Verification:**
    - [ ] Run `dart_fix --apply` one last time.
    - [ ] Run `analyze_files` and fix any remaining issues.
    - [ ] Run all tests to ensure the entire project is stable.
    - [ ] Run `dart_format .`.
    - [ ] Re-read this `MODIFICATION_IMPLEMENTATION.md` file.
    - [ ] Update the "Journal" section with a summary of the project.
    - [ ] Use `git diff` to verify all changes, create a final commit message, and present it for approval.
    - [ ] Wait for your approval before committing.
- [ ] Ask you to inspect the package and the running application to confirm that you are satisfied with the result.
