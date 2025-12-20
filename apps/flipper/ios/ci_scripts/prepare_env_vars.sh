#!/bin/bash
# Helper script to prepare environment variable values for Xcode Cloud
# Run this script and copy the output to set up your Xcode Cloud environment variables

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 XCODE CLOUD ENVIRONMENT VARIABLES"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Copy each section below and paste into Xcode Cloud as environment variables."
echo "Mark ALL of these as 'Secret' in Xcode Cloud!"
echo ""

# SECRETS2 (packages/flipper_models/lib/secrets.dart)
if [ -f "packages/flipper_models/lib/secrets.dart" ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Variable Name: SECRETS2"
  echo "Mark as: ✅ Secret"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Value (copy everything below this line):"
  echo "---START---"
  cat packages/flipper_models/lib/secrets.dart
  echo "---END---"
  echo ""
else
  echo "⚠️ SECRETS2 file not found: packages/flipper_models/lib/secrets.dart"
  echo ""
fi

# SECRETS1 (apps/flipper/lib/secrets.dart)
if [ -f "apps/flipper/lib/secrets.dart" ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Variable Name: SECRETS1"
  echo "Mark as: ✅ Secret"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Value (copy everything below this line):"
  echo "---START---"
  cat apps/flipper/lib/secrets.dart
  echo "---END---"
  echo ""
else
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Variable Name: SECRETS1"
  echo "Status: ⚠️ File does not exist locally"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Action: Either:"
  echo "  1. Copy SECRETS2 content (they might be the same)"
  echo "  2. Or leave this variable empty if not needed"
  echo ""
fi

# FIREBASE1 (apps/flipper/lib/firebase_options.dart)
if [ -f "apps/flipper/lib/firebase_options.dart" ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Variable Name: FIREBASE1"
  echo "Mark as: ✅ Secret"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Value (copy everything below this line):"
  echo "---START---"
  cat apps/flipper/lib/firebase_options.dart
  echo "---END---"
  echo ""
else
  echo "⚠️ FIREBASE1 file not found: apps/flipper/lib/firebase_options.dart"
  echo ""
fi

# FIREBASE2 (packages/flipper_models/lib/firebase_options.dart)
if [ -f "packages/flipper_models/lib/firebase_options.dart" ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Variable Name: FIREBASE2"
  echo "Mark as: ✅ Secret"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Value (copy everything below this line):"
  echo "---START---"
  cat packages/flipper_models/lib/firebase_options.dart
  echo "---END---"
  echo ""
else
  echo "⚠️ FIREBASE2 file not found: packages/flipper_models/lib/firebase_options.dart"
  echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 INSTRUCTIONS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Go to App Store Connect → Your App → Xcode Cloud"
echo "2. Select your workflow → Environment tab"
echo "3. For each variable above:"
echo "   - Click 'Add Environment Variable'"
echo "   - Enter the Variable Name (e.g., SECRETS2)"
echo "   - Copy the content between ---START--- and ---END---"
echo "   - Paste into the Value field"
echo "   - ✅ Check 'Secret' checkbox"
echo "   - Click 'Add'"
echo ""
echo "4. After adding all variables, trigger a new build"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
