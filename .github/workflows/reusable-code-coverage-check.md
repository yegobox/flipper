name: Reusable Code Coverage Check
# This reusable is not working.
# https://github.com/orgs/community/discussions/14306
on:
  workflow_call:
    inputs:
      flutter-channel:
        required: false
        type: string
        default: 'stable'
      minimum-coverage:
        required: false
        type: number
        default: 45
    secrets:
      GITHUB_TOKEN:
        required: true
        
jobs:
  code-coverage:
    name: Check Code Coverage
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
      
      - name: Install Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: ${{ inputs.flutter-channel }}
      
      - name: Install Dependencies
        run: flutter pub get
      
      - name: Run Flutter Tests
        run: flutter test --coverage
      
      - name: Setup LCOV
        uses: hrishikesh-kadam/setup-lcov@v1
      
      - name: Report Code Coverage
        uses: zgosalvez/github-actions-report-lcov@v3
        with:
          coverage-files: coverage/lcov.info
          minimum-coverage: ${{ inputs.minimum-coverage }}
          artifact-name: code-coverage-report
          github-token: ${{ secrets.ACCESS_TOKEN }}