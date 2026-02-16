I am integrating with "Umusada" this is a platform that will help users on flipper to be able to get loan on their order from their resective supplier, so a user upon clicking button from @ribbon.dart#L1-380 to start ordering if he heas not joined umusada we will prompt him to join so he can enjoy the benefit of umusada, at that pond we will call curl -X 'POST' \
  'http://umusada-master.umusada.com/umusada-master-service/business/save' \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -d '{
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
}' to save a business to umusada, this means we will start sending the business sales to umusada so for the business to 
get loan limit, it is important to note that this feature will only be available in RW since flipper can be used anywhere 
maybe other country will be added in the future, also for us to be able to call umusada we do the following: 

