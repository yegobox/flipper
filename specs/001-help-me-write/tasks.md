# Tasks: PIN Login

**Input**: Design documents from `/specs/001-help-me-write/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Format: `[ID] [P?] Description`
- **[P]**: Can run in parallel (different files, no dependencies)

## Path Conventions
- **API**: `api/`
- **App**: `app/`

## Phase 3.1: Setup
- [ ] T001 Create `api` and `app` directories for the project structure.
- [ ] T002 In the `app` directory, initialize a new Flutter project.
- [ ] T003 Add `riverpod`, `http`, `flutter_riverpod` and other necessary dependencies to `app/pubspec.yaml`.
- [ ] T004 [P] Configure linting and formatting tools for the Flutter project.
- [ ] T005 In the `api` directory, initialize a new Dart project (e.g., using Frog).
- [ ] T006 [P] Configure linting and formatting tools for the API project.

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
- [ ] T007 [P] Write a failing contract test for `POST /login/pin` in `api/tests/contract/test_pin_login.dart`.
- [ ] T008 [P] Write a failing contract test for `POST /login/otp` in `api/tests/contract/test_otp.dart`.
- [ ] T009 [P] Write a failing contract test for `POST /login/otp/verify` in `api/tests/contract/test_otp_verify.dart`.
- [ ] T010 [P] Write a failing contract test for `POST /login/totp/verify` in `api/tests/contract/test_totp_verify.dart`.
- [ ] T011 [P] Write a failing integration test for the SMS OTP login flow in `app/integration_test/sms_login_test.dart`.
- [ ] T012 [P] Write a failing integration test for the Authenticator login flow in `app/integration_test/authenticator_login_test.dart`.

## Phase 3.3: Core Implementation (ONLY after tests are failing)
- [ ] T013 [P] Create the `User` and `AuthToken` models in `api/lib/src/models/`.
- [ ] T014 Implement the `POST /login/pin` endpoint in `api/routes/login/pin.dart`.
- [ ] T015 Implement the `POST /login/otp` endpoint in `api/routes/login/otp.dart`.
- [ ] T016 Implement the `POST /login/otp/verify` endpoint in `api/routes/login/otp/verify.dart`.
- [ ] T017 Implement the `POST /login/totp/verify` endpoint in `api/routes/login/totp/verify.dart`.
- [ ] T018 [P] Create the `User` and `AuthToken` models in `app/lib/models/`.
- [ ] T019 [P] Create the `AuthRepository` in `app/lib/repositories/auth_repository.dart` to handle API calls.
- [ ] T020 [P] Create the `PIN` screen UI in `app/lib/features/login/pin_screen.dart`.
- [ ] T021 [P] Create the `Second Factor` selection screen UI in `app/lib/features/login/second_factor_screen.dart`.
- [ ] T022 [P] Create the `OTP` screen UI in `app/lib/features/login/otp_screen.dart`.
- [ ] T023 [P] Create the `TOTP` screen UI in `app/lib/features/login/totp_screen.dart`.
- [ ] T024 [P] Create the `Dashboard` screen UI in `app/lib/features/dashboard/dashboard_screen.dart`.
- [ ] T025 Implement the state management for the login flow using Riverpod in `app/lib/features/login/auth_providers.dart`.

## Phase 3.4: Integration
- [ ] T026 Connect the `AuthRepository` to the API endpoints.
- [ ] T027 Integrate the UI screens with the Riverpod providers.

## Phase 3.5: Polish
- [ ] T028 [P] Write unit tests for the `AuthRepository`.
- [ ] T029 [P] Write unit tests for the Riverpod providers.
- [ ] T030 [P] Write widget tests for all the screens.
- [ ] T031 Run the manual tests in `quickstart.md`.

## Dependencies
- Tests (T007-T012) before implementation (T013-T025)
- Models (T013, T018) before repositories and endpoints.
- Implementation before polish (T028-T031)

## Parallel Example
```
# Launch T007-T012 together:
Task: "Write a failing contract test for POST /login/pin in api/tests/contract/test_pin_login.dart"
Task: "Write a failing contract test for POST /login/otp in api/tests/contract/test_otp.dart"
Task: "Write a failing contract test for POST /login/otp/verify in api/tests/contract/test_otp_verify.dart"
Task: "Write a failing contract test for POST /login/totp/verify in api/tests/contract/test_totp_verify.dart"
Task: "Write a failing integration test for the SMS OTP login flow in app/integration_test/sms_login_test.dart"
Task: "Write a failing integration test for the Authenticator login flow in app/integration_test/authenticator_login_test.dart"
```
