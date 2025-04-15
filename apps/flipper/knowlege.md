# When editing code, remember to avoid regression as much as you can do this:
- Look at the old feature implementation improve it but do not ever break it
- Document change in knowlege.md

## 2025-04-15: Login Dialog & Navigation Improvement
- Improved the login flow loading dialog in `login.dart`:
  - The loading dialog now remains open until after navigation is triggered, preventing flicker or premature dismissal.
  - Used `WidgetsBinding.instance.addPostFrameCallback` to ensure the dialog closes only after navigation starts.
  - The dialog is also closed on error to prevent it from lingering.
- This change follows the regression-avoidance rule: it preserves the old working behavior and only improves reliability and UX.
- No old code was deleted; only improved for timing and robustness.