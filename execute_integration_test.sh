GREEN='\033[0;32m'
NC='\033[0m'
LINE_BREAK="${GREEN} --- ${NC}"

echo "$LINE_BREAK"
echo "${GREEN}App test begin ${NC}"
echo "$LINE_BREAK"

# App
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart
