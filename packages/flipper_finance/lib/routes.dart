// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

const String loginRoute = '/rally/login';
const String homeRoute = '/rally';

String char = DateTime.now()
    .toString()
    .replaceAll(":", "")
    .replaceAll("-", "")
    .replaceAll(" ", "")
    .substring(0, 14);

// limit to 14 characters

// I am having this issue while integrating EBM receipt i.e saving a sale record
//  - what is the difference of taxblAmtB and totTaxblAmt
//  - what is the difference of taxAmtB and totTaxAmt
//  - How to calculate taxAmtB, taxblAmtB and totTaxblAmt
