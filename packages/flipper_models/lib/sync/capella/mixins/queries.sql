SELECT createdAt,agentId FROM `transactions`
WHERE agentId = 'cd12ed90-76e9-4b24-bc09-5dd88eb3e10a'
AND status = 'completed'
AND subTotal > 0
AND branchId = 'f703d80c-d498-470f-a37a-28cf61da9fc9'
AND transactionType != 'Adjustment'
AND createdAt >= '2026-03-31T00:00:00.000'
AND createdAt <= '2026-03-31T23:59:59.999'



SELECT count(*) FROM `transactions`
WHERE _id IN (
  '678e42be-cc14-4402-93ec-9c03e63da41f',
  'e56d294b-cad0-4f54-b0eb-a6458a43dd67',
  '47793324-0220-40c4-b4a2-969aff799d63',
  '6e8788a6-994c-44c8-9141-4baf69636c6e',
  'e9fcf6f3-8151-4c1c-ba11-7284497e358c',
  'e9f6aed7-32d1-48cf-8903-e1dc814a6df1',
  'a5b3fd7b-78f7-4688-99b3-ff8c31081489',
  '75f8e69a-c438-47d1-95a6-c7f6d03d3f3b',
  'f3b64140-925c-44dd-8756-29543abed651',
  '33613f0c-f5f2-409f-974d-93e089757ad3',
  '760ca33c-466f-48a4-9c0b-8d6f9e3f1e33',
  '4b5cee38-0ad0-4ff7-9d2a-c7000935253e',
  'bd04e961-21d2-4aa5-a948-f85ffb443a29',
  '26ce0814-8761-47bf-bbd2-9386fa033dea',
  '59bda4d3-a879-4af4-9c4d-8005936ccdd8'
) and agentId = 'cd12ed90-76e9-4b24-bc09-5dd88eb3e10a' and transactionType != 'Adjustment' and  status = 'completed'