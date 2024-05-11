# flipper

# Process of adding a custom product and variant
- 1. User type on keyboard
- 2. if a custom product exist it is returned
- 3. if not then it is created in RealmApi createProduct then within            createRegularVariant is called
- 4. _createRegularVariant should create an new object of variant to be used.

# Managing transactiona and hanle finance aspect of it
- 1. in nutshell we save all transaction in one table with transaction type
- 2. Because we need to distinguish expense from e.g income
- 3. we rely on transaction property isIncome or iExpense
- 4. and because the user might need to add more... this is not accepted at the moment
- 5. but we keep adding accepted or predefined categories see
- 5. CoreViewModel at saveCashBookTransaction method see how that is done for example
- 6. When adding new type remember to update queries in place RealmAPI transactionsStream to support new
- 7. In place such as payments.dart and RealmAPI@collectPayment we set transaction as income 

# Setting up edge server
- curl https://services.cloud.mongodb.com/edge/install.sh | bash -s - --app-id=devicesync-ifwtd --platform=compose
```dart
    >>> Update your path with:

    export PATH="$PATH:/Users/richard/.mongodb-edge/bin"
    
    >>> To initialize your edge server, run:
    
    edgectl init --app-id=devicesync-ifwtd --platform=compose
```
# Configure receipt to print 
- Doubele tap on home Icon on desltop or tablet
- A model will open to enable configuration.