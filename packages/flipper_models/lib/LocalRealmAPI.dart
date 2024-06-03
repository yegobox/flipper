import 'dart:convert';
import 'dart:developer';

import 'package:flipper_models/LocalRealm.dart';
import 'package:flipper_models/exceptions.dart';
import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/permission.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/RealmApi.dart';
import 'package:flipper_models/realmInterface.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/proxy.dart';
import 'package:realm/realm.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart' as foundation;

class LocalRealmApi extends RealmAPI implements LocalRealmInterface {
  final talker = TalkerFlutter.init();
  @override
  Realm? localRealm;

  void dataCb(Realm realm) {
    List<Map<String, dynamic>> itemClsList = [
      {
        "itemClsCd": "5020230601",
        "itemClsNm": "Fanta",
        "itemClsLvl": 5,
        "taxTyCd": "B",
        "mjrTgYn": "Y",
        "useYn": "Y"
      },
      {
        "itemClsCd": "5020230602",
        "itemClsNm": "water",
        "itemClsLvl": 5,
        "taxTyCd": "B",
        "mjrTgYn": "Y",
        "useYn": "Y"
      },
      {
        "itemClsCd": "5020230102",
        "itemClsNm": "Inyange",
        "itemClsLvl": 5,
        "taxTyCd": "B",
        "mjrTgYn": "Y",
        "useYn": "Y"
      },
      {
        "itemClsCd": "1112200101",
        "itemClsNm": "Gypsum boad",
        "itemClsLvl": 5,
        "taxTyCd": "B",
        "mjrTgYn": "Y",
        "useYn": "Y"
      },
      {
        "itemClsCd": "3011170102",
        "itemClsNm": "Gypsum board 1",
        "itemClsLvl": 5,
        "taxTyCd": "B",
        "mjrTgYn": "Y",
        "useYn": "Y"
      },
      {
        "itemClsCd": "10122101",
        "itemClsNm": "Miscellaneous animal food",
        "itemClsLvl": 4,
        "taxTyCd": null,
        "mjrTgYn": null,
        "useYn": "Y"
      },
      {
        "itemClsCd": "50202203",
        "itemClsNm": "Wine",
        "itemClsLvl": 4,
        "taxTyCd": null,
        "mjrTgYn": null,
        "useYn": "Y"
      },
      // {
      //   "itemClsCd": "26111612",
      //   "itemClsNm": "Solar equipment systems",
      //   "itemClsLvl": 4,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "31211905",
      //   "itemClsNm": "Paint mixers",
      //   "itemClsLvl": 4,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "10171702",
      //   "itemClsNm": "Fungicides",
      //   "itemClsLvl": 4,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "22101539",
      //   "itemClsNm": "Earthmoving machinery parts and accessories",
      //   "itemClsLvl": 4,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "25132100",
      //   "itemClsNm": "Unmanned aerial vehicle",
      //   "itemClsLvl": 3,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "25132101",
      //   "itemClsNm": "Agricultural drone",
      //   "itemClsLvl": 4,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "25132102",
      //   "itemClsNm": "Military drone",
      //   "itemClsLvl": 4,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "25132103",
      //   "itemClsNm": "Recreational drone",
      //   "itemClsLvl": 4,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "25132104",
      //   "itemClsNm": "Law enforcement drone",
      //   "itemClsLvl": 4,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "25132105",
      //   "itemClsNm": "Delivery drone",
      //   "itemClsLvl": 4,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "14111620",
      //   "itemClsNm": "Test",
      //   "itemClsLvl": 4,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "14124000",
      //   "itemClsNm": "Test",
      //   "itemClsLvl": 3,
      //   "taxTyCd": null,
      //   "mjrTgYn": null,
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112180600",
      //   "itemClsNm": "Laboratory vials",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112180800",
      //   "itemClsNm": "Laboratory burets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112181200",
      //   "itemClsNm": "Laboratory dishes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112200100",
      //   "itemClsNm": "Chromatography syringes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112210200",
      //   "itemClsNm": "Multiwell plates",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112241100",
      //   "itemClsNm": "Laboratory timers or watches",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112241300",
      //   "itemClsNm": "Laboratory clamps",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112280400",
      //   "itemClsNm": "Test tube racks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112280500",
      //   "itemClsNm": "Drying racks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112300100",
      //   "itemClsNm": "Jar desiccators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4213170700",
      //   "itemClsNm":
      //       "Surgical isolation suits or helmets or facemasks or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214160700",
      //   "itemClsNm": "Patient urinals for general use",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214170200",
      //   "itemClsNm": "Blanket frames or lifters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214210500",
      //   "itemClsNm": "Therapeutic heating or cooling units or systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214252100",
      //   "itemClsNm": "Blood collection needle",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214271600",
      //   "itemClsNm": "Pessary device",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214290100",
      //   "itemClsNm": "Eyeglasses",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214290200",
      //   "itemClsNm": "Eyeglass lenses",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214310300",
      //   "itemClsNm": "Contraceptive devices or accessories for female users",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214310800",
      //   "itemClsNm": "Abdominal decompression chamber",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214370300",
      //   "itemClsNm": "Phototherapy bulbs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215161400",
      //   "itemClsNm": "Dental burs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215161700",
      //   "itemClsNm": "Dental drills or drill bits",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215163800",
      //   "itemClsNm": "Dental scissors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215180500",
      //   "itemClsNm": "Dental finishing or polishing discs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215180600",
      //   "itemClsNm": "Dental finishing or polishing strips",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215221500",
      //   "itemClsNm": "Dental laboratory sandblasters or supplies",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215222000",
      //   "itemClsNm": "Dental stones",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215240100",
      //   "itemClsNm": "Alloys for dental amalgam",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110180700",
      //   "itemClsNm": "Electron diffraction apparatus",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110240400",
      //   "itemClsNm": "Laboratory heaters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110240600",
      //   "itemClsNm": "Laboratory hotplates",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110242300",
      //   "itemClsNm": "Stirring hotplates",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110290200",
      //   "itemClsNm": "Embedding molds",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110381600",
      //   "itemClsNm": "Mixer or shaker accessories or attachments",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229551700",
      //   "itemClsNm": "Cardiovascular extenders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229600600",
      //   "itemClsNm": "Vascular graft",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4230150200",
      //   "itemClsNm":
      //       "Anatomical human mannequins for medical education or training",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4231190200",
      //   "itemClsNm": "Medical incision drainage bags or reservoirs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4231200700",
      //   "itemClsNm": "Medical clips for internal use",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4231240200",
      //   "itemClsNm": "Nasal splints or stents",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4232180800",
      //   "itemClsNm": "Total knee replacement kits or systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4232200400",
      //   "itemClsNm": "Finger joint implant",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4319150800",
      //   "itemClsNm": "Digital telephones",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4319151200",
      //   "itemClsNm":
      //       "Digital enhanced cordless telecommunications DECT cordless phones",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4319160600",
      //   "itemClsNm": "Phone handsets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4320153700",
      //   "itemClsNm": "Print servers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4320155400",
      //   "itemClsNm": "Personal computer television PC TV tuners",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4320180300",
      //   "itemClsNm": "Hard disk drives",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4320181100",
      //   "itemClsNm": "Read write digital versatile disc DVD",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4320200500",
      //   "itemClsNm": "Flash memory storage card",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4320201000",
      //   "itemClsNm": "Pen or flash drive",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321151500",
      //   "itemClsNm": "Computer workstation",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321151800",
      //   "itemClsNm": "Multi screen computer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321161400",
      //   "itemClsNm": "Bluetooth universal serial bus USB adapter",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321171300",
      //   "itemClsNm": "Touch pads",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321172600",
      //   "itemClsNm": "Digital pen",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321172800",
      //   "itemClsNm": "Smart card dummy terminal",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321190100",
      //   "itemClsNm": "Cathode ray tube CRT monitors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321210400",
      //   "itemClsNm": "Inkjet printers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322152700",
      //   "itemClsNm": "Wire tapping protector",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322172900",
      //   "itemClsNm": "Portable antenna",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322173200",
      //   "itemClsNm": "Speaker control unit",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322261900",
      //   "itemClsNm": "Video networking equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322311300",
      //   "itemClsNm": "GSM UMT LAN antenna",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322333200",
      //   "itemClsNm": "Fiber optic tool kit",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4323151300",
      //   "itemClsNm": "Office suite software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4323210200",
      //   "itemClsNm": "Graphics or photo imaging software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4323240600",
      //   "itemClsNm": "Program testing software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4323300100",
      //   "itemClsNm": "Filesystem software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4323350600",
      //   "itemClsNm": "Map creation software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410150100",
      //   "itemClsNm": "Photocopiers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410171600",
      //   "itemClsNm": "Hole punching units",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410180400",
      //   "itemClsNm": "Cash registers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410240800",
      //   "itemClsNm": "Automatic labeling systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410310700",
      //   "itemClsNm": "Printer or facsimile or photocopier cleaning supplies",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410310900",
      //   "itemClsNm": "Printer or facsimile or photocopier drums",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4411151800",
      //   "itemClsNm": "Business card holders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4411160900",
      //   "itemClsNm": "Counterfeit bill detectors or supplies",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4411180500",
      //   "itemClsNm": "Curves",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4411190200",
      //   "itemClsNm": "Electronic copyboards or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4412151300",
      //   "itemClsNm": "Postage stamp",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4412162200",
      //   "itemClsNm": "Moisteners",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220270100",
      //   "itemClsNm": "Radiotherapy teletherapy cobalt 60 equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220330100",
      //   "itemClsNm": "Frameless stereotactic therapy systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220340700",
      //   "itemClsNm": "Angiography contrast medium delivery set",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220350200",
      //   "itemClsNm": "Cardiac pacing leads or electrodes or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220370400",
      //   "itemClsNm": "Medical toners or developers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220400800",
      //   "itemClsNm":
      //       "Medical radiological shielding chambers or rooms or safes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4221160300",
      //   "itemClsNm": "Bath lifts or accessories for the physically challenged",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4221160600",
      //   "itemClsNm": "Commodes or accessories for the physically challenged",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4221161100",
      //   "itemClsNm": "Sitz baths for the physically challenged",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4221170200",
      //   "itemClsNm": "Braille devices for the physically challenged",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4221171000",
      //   "itemClsNm": "Writing aids for the physically challenged",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4222151200",
      //   "itemClsNm": "Intravenous or arterial cannulas or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4222160900",
      //   "itemClsNm": "Intravenous or arterial tubing administration set",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4222230800",
      //   "itemClsNm": "Blood administration or transfusion bags or containers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4224150200",
      //   "itemClsNm": "Cast or splint padding materials",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4224150500",
      //   "itemClsNm": "Orthopedic casting rolls or tapes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4224170800",
      //   "itemClsNm": "Femoral fracture pillows",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4224210800",
      //   "itemClsNm": "Orthopedic traction hardware or weights",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4225160500",
      //   "itemClsNm": "Pedal exercisers for rehabilitation or therapy",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4225160700",
      //   "itemClsNm": "Pulleys or accessories for rehabilitation or therapy",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4226151500",
      //   "itemClsNm": "Cases for postmortem surgical instruments or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4226180200",
      //   "itemClsNm": "Cadaver carriers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4226180800",
      //   "itemClsNm": "Cadaver trays",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227160400",
      //   "itemClsNm": "Peak flowmeters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227161100",
      //   "itemClsNm": "Pulmonary ventilation monitors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227170300",
      //   "itemClsNm": "Oxygen air blenders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227180100",
      //   "itemClsNm": "Respiratory humidifiers or vaporizers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227190700",
      //   "itemClsNm": "Respiratory aspirator products or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4228190200",
      //   "itemClsNm": "Sterilization wrap or overwrap",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229160700",
      //   "itemClsNm": "Surgical curettes or loops",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220360500",
      //   "itemClsNm": "Medical x ray film archiving system software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220371000",
      //   "itemClsNm": "Medical x ray film markers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220400500",
      //   "itemClsNm": "Medical radiological shielding gloves",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4221160800",
      //   "itemClsNm":
      //       "Grab bars or tub safety rails for the physically challenged",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4222200800",
      //   "itemClsNm": "Infusion pump kits or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4222230700",
      //   "itemClsNm": "Blood warming or transfusion systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4223170100",
      //   "itemClsNm": "Nasogastric tubes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4224160200",
      //   "itemClsNm": "Cast cutters or saws",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4225161200",
      //   "itemClsNm":
      //       "Weights or sets or accessories for rehabilitation or therapy",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4225162100",
      //   "itemClsNm": "Boot exercisers for rehabilitation or therapy",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4225162300",
      //   "itemClsNm": "Ultrasonic therapy apparatus or supplies",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4226150900",
      //   "itemClsNm": "Autopsy dissection kits",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4226180600",
      //   "itemClsNm": "Morgue freezers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227160500",
      //   "itemClsNm": "Pulmonary function calculators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227171500",
      //   "itemClsNm": "Medical oxygen tubing or connectors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227172200",
      //   "itemClsNm": "Oxygen uptake computer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227190400",
      //   "itemClsNm": "Tracheostomy tubes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227191400",
      //   "itemClsNm": "Airway pressure gages",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227200400",
      //   "itemClsNm": "Intubation stylets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4227250200",
      //   "itemClsNm": "Absorber units for gas anesthesia apparatus",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229170200",
      //   "itemClsNm": "Surgical hand reamers or awls",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229180100",
      //   "itemClsNm":
      //       "Surgical band ligator appliers or bands or related products",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229200100",
      //   "itemClsNm": "Surgical otolaryngological mirrors or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229310200",
      //   "itemClsNm": "Surgical retraction hooks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229311400",
      //   "itemClsNm": "Oral retractors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229311900",
      //   "itemClsNm": "Abdominal retractors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229312500",
      //   "itemClsNm": "Sternum retractors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229400100",
      //   "itemClsNm": "Surgical scoops",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229451100",
      //   "itemClsNm":
      //       "Ophthalmic surgical knives or blades or scissors or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229460300",
      //   "itemClsNm": "Autotransfusion units",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229490300",
      //   "itemClsNm": "Endoscopic aspiration or biopsy needles",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229490500",
      //   "itemClsNm": "Endoscopic cleaning brushes or related products",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229490800",
      //   "itemClsNm": "Endoscopic clamp or dissector or grasper or forceps",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229500200",
      //   "itemClsNm": "Endoscope storage cabinets or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229500700",
      //   "itemClsNm": "Endoscopic imaging systems or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229510100",
      //   "itemClsNm": "Basin stands for surgical use",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229510200",
      //   "itemClsNm": "Cryosurgery equipment or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229511900",
      //   "itemClsNm": "Surgical lasers or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229512100",
      //   "itemClsNm":
      //       "Surgical microscopes or loops or magnifiers or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229530300",
      //   "itemClsNm":
      //       "Surgical perfusion catheters or connectors or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229540500",
      //   "itemClsNm":
      //       "Introducer or guide pin or guidewire or glidewire for non endoscopic surgical or open heart procedures",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229542000",
      //   "itemClsNm":
      //       "Surgical or endoscopic catheters or catheterization kits or drainage bags",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229542100",
      //   "itemClsNm": "Surgical prep scrub or paint solutions",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4229544600",
      //   "itemClsNm": "Internal organ retainers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4615150600",
      //   "itemClsNm": "Riot batons",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4615171100",
      //   "itemClsNm": "Footprint lifters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4616150500",
      //   "itemClsNm": "Parking meters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4617161000",
      //   "itemClsNm": "Security cameras",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4617162100",
      //   "itemClsNm": "Surveillance video or audio recorders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4617163600",
      //   "itemClsNm": "Security facsimile transmission equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4618151800",
      //   "itemClsNm": "Heat resistant clothing",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4618152800",
      //   "itemClsNm": "Protective frock",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4618170300",
      //   "itemClsNm": "Welding masks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4618190100",
      //   "itemClsNm": "Ear plugs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4618230600",
      //   "itemClsNm": "Safety harnesses or belts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4618250500",
      //   "itemClsNm": "Earth leakage detector and fire alarm",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4619150100",
      //   "itemClsNm": "Smoke detectors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4619150300",
      //   "itemClsNm": "Fire resistant coatings or putties or sealants",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4619160500",
      //   "itemClsNm": "Fire suppression hand tools",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4619160600",
      //   "itemClsNm": "Fire suppression foam or similar compounds",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4710150600",
      //   "itemClsNm": "Corrosion control equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4710150900",
      //   "itemClsNm": "Fluoridation equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4710151000",
      //   "itemClsNm": "Iron removal equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4710152200",
      //   "itemClsNm": "Packaged water treatment systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4710153100",
      //   "itemClsNm": "Septic tanks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4710154900",
      //   "itemClsNm": "Gravity filter",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4710156500",
      //   "itemClsNm": "Waste gas burner",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4710160600",
      //   "itemClsNm": "Corrosion control chemicals",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4710160800",
      //   "itemClsNm": "Flocculents",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4711160300",
      //   "itemClsNm": "Steam pressing machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4712161000",
      //   "itemClsNm": "Floor washing machine",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4712180600",
      //   "itemClsNm": "Mop wringer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4713180700",
      //   "itemClsNm": "Bleaches",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4713181200",
      //   "itemClsNm": "Air freshener",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4713190900",
      //   "itemClsNm": "Sorbent pads or rolls",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4810181500",
      //   "itemClsNm": "Commercial use ladles",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4810210300",
      //   "itemClsNm": "Refrigerated display cases",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4811100200",
      //   "itemClsNm": "Machines dispensing bulk quantities",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4811110100",
      //   "itemClsNm": "Bottle or can vending machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110620400",
      //   "itemClsNm": "Bottled agar media or stabs for bacteria",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110640100",
      //   "itemClsNm": "Adaptors or linkers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110650100",
      //   "itemClsNm": "Bacterial expression kits",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111150300",
      //   "itemClsNm": "Mechanical balances",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111150500",
      //   "itemClsNm": "Calibration weights or weight sets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111151000",
      //   "itemClsNm": "Postal scales",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111151100",
      //   "itemClsNm": "Truck or rail scales",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111160200",
      //   "itemClsNm": "Pedometers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111160400",
      //   "itemClsNm": "Rulers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111161800",
      //   "itemClsNm": "Gage block set",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111170400",
      //   "itemClsNm": "Illuminators for microscopes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111171500",
      //   "itemClsNm": "Telescopes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111172300",
      //   "itemClsNm":
      //       "Scanning light or spinning disk or laser scanning microscopes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111174100",
      //   "itemClsNm": "Microscope differential interference contrast equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111180800",
      //   "itemClsNm": "X ray radiography examination equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111190500",
      //   "itemClsNm": "Electronic measuring probes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111191800",
      //   "itemClsNm": "Gyroscopic instruments",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111193200",
      //   "itemClsNm": "Liquid leak detectors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111210500",
      //   "itemClsNm": "Temperature transmitters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111221000",
      //   "itemClsNm": "Remote reading thermometers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111240100",
      //   "itemClsNm": "Depth gauges",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111241000",
      //   "itemClsNm": "Pressure transmitters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111241500",
      //   "itemClsNm": "Warburg apparatus",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111260100",
      //   "itemClsNm": "Manual swab test kits",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111302400",
      //   "itemClsNm": "Hydrometers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111311000",
      //   "itemClsNm": "Oxygen gas analyzers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111311300",
      //   "itemClsNm": "Sulfur dioxide analyzers or detectors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111330100",
      //   "itemClsNm": "Acid or base analyzers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111331500",
      //   "itemClsNm": "Organic carbon analyzers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1111160700",
      //   "itemClsNm": "Sandstone",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1112200300",
      //   "itemClsNm": "Medium density fiberboard",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1113150200",
      //   "itemClsNm": "Furs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115150600",
      //   "itemClsNm": "Rayon fibers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115150800",
      //   "itemClsNm": "Wool fibers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115151100",
      //   "itemClsNm": "Polypropylene fibers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115160100",
      //   "itemClsNm": "Cotton thread",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115170200",
      //   "itemClsNm": "Cotton yarn",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115170600",
      //   "itemClsNm": "Ramie yarn",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115171500",
      //   "itemClsNm": "Flax yarn",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1116210800",
      //   "itemClsNm": "Wire mesh fabric or cloth",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1116230600",
      //   "itemClsNm": "Pig leather",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1116240100",
      //   "itemClsNm": "Cotton batting",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1213150100",
      //   "itemClsNm": "Dynamite",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1213170300",
      //   "itemClsNm": "Explosives fuses",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1214172400",
      //   "itemClsNm": "Manganese Mn",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1214200600",
      //   "itemClsNm": "Neon gas Ne",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1214210700",
      //   "itemClsNm": "Hydrogen sulfide",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1214210800",
      //   "itemClsNm": "Carbon monoxide",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1216190400",
      //   "itemClsNm": "Dispersing agents",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1010151000",
      //   "itemClsNm": "Mice",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1013160100",
      //   "itemClsNm": "Cages or its accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015151400",
      //   "itemClsNm": "Melon seeds or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015151500",
      //   "itemClsNm": "Onion seeds or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015153200",
      //   "itemClsNm": "Squash seeds or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015160300",
      //   "itemClsNm": "Barley seeds",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015160800",
      //   "itemClsNm": "Castor oil seeds",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015161400",
      //   "itemClsNm": "Rice seeds or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015170300",
      //   "itemClsNm": "Alfalfa seeds or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015170400",
      //   "itemClsNm": "Grass seeds or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015180100",
      //   "itemClsNm": "Pepper seeds or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015181000",
      //   "itemClsNm": "Mustard seeds or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015190600",
      //   "itemClsNm": "Lily Bulbs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015190700",
      //   "itemClsNm": "Vetch seeds or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015200100",
      //   "itemClsNm": "Fruit tree seeds or cuttings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1016150300",
      //   "itemClsNm": "Cocoa trees",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1016150700",
      //   "itemClsNm": "Rhododendron shrubs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1016180100",
      //   "itemClsNm": "Ferns",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1017150200",
      //   "itemClsNm": "Plant hormones",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1017150400",
      //   "itemClsNm": "Compost",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1017160500",
      //   "itemClsNm": "Nitrogen Phosphorous Potassium Mixtures NPK",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110150200",
      //   "itemClsNm": "Emery",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110150300",
      //   "itemClsNm": "Quartz",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110150600",
      //   "itemClsNm": "Chalk",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110150700",
      //   "itemClsNm": "Graphite",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110151400",
      //   "itemClsNm": "Feldspar",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110152600",
      //   "itemClsNm": "Carnallite",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110152700",
      //   "itemClsNm": "Diatomaceous silica",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110160300",
      //   "itemClsNm": "Uranium ore",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110161300",
      //   "itemClsNm": "Tungsten or wolfram ore",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110161900",
      //   "itemClsNm": "Vermiculite ore",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110162000",
      //   "itemClsNm": "Thorium ore",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110170500",
      //   "itemClsNm": "Aluminum",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110180100",
      //   "itemClsNm": "Gold",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2010170200",
      //   "itemClsNm": "Roll crushers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2010170600",
      //   "itemClsNm": "Jaw crushers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2110150200",
      //   "itemClsNm": "Harrows",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2110190400",
      //   "itemClsNm": "Feed mixers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2110220100",
      //   "itemClsNm": "Decorticators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2110220200",
      //   "itemClsNm": "Lumbering equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2111150100",
      //   "itemClsNm": "Commercial fish hooks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210150500",
      //   "itemClsNm": "Rollers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210151100",
      //   "itemClsNm": "Compactors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210151300",
      //   "itemClsNm": "Draglines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210162400",
      //   "itemClsNm": "Road marking machine",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210162800",
      //   "itemClsNm": "Aggregate washer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210171100",
      //   "itemClsNm": "Paving breaker tools or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210190100",
      //   "itemClsNm": "Concrete mixers or plants",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2310150100",
      //   "itemClsNm": "Coping machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2310152800",
      //   "itemClsNm": "Drum sander",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2312160400",
      //   "itemClsNm": "Cloth cutting machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2313150300",
      //   "itemClsNm": "Grinding wheels",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2313150600",
      //   "itemClsNm": "Polishing wheels",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2314160300",
      //   "itemClsNm": "Leather dyeing machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2315150300",
      //   "itemClsNm": "Extruders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2316160100",
      //   "itemClsNm": "Foundry bellows",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2318150100",
      //   "itemClsNm": "Filling machinery",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2519150400",
      //   "itemClsNm": "Aircraft flight simulators or trainers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2519150500",
      //   "itemClsNm": "Aircraft cargo handling equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2519150900",
      //   "itemClsNm": "Aircraft pushback or tow tractors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2519170200",
      //   "itemClsNm": "Wheel alignment equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520150200",
      //   "itemClsNm": "Aircraft fins",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520151300",
      //   "itemClsNm": "Aircraft radomes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520200400",
      //   "itemClsNm": "Auxiliary power unit systems APUs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520220100",
      //   "itemClsNm": "Aircraft braking systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520220200",
      //   "itemClsNm": "Aircraft drag chutes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520250400",
      //   "itemClsNm": "Aircraft windshield wipers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520260100",
      //   "itemClsNm": "Aircraft environment controllers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610110600",
      //   "itemClsNm": "Inverter motor AC",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610111400",
      //   "itemClsNm": "Induction motor AC",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610120200",
      //   "itemClsNm": "Step motor DC",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610140400",
      //   "itemClsNm": "Motor brush",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610150600",
      //   "itemClsNm": "Turbine engines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610151100",
      //   "itemClsNm": "Hydraulic turbine engines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610171900",
      //   "itemClsNm": "Supercharger",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610172700",
      //   "itemClsNm": "Piston rings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610173200",
      //   "itemClsNm": "Spark plugs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610173500",
      //   "itemClsNm": "Oil pan",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2611160400",
      //   "itemClsNm": "Gas generators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2611172000",
      //   "itemClsNm": "Battery holders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2611172900",
      //   "itemClsNm": "Auto battery charger unit",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2611190100",
      //   "itemClsNm": "Plate clutches",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2611210200",
      //   "itemClsNm": "Hydraulic braking systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2612151400",
      //   "itemClsNm": "Underground wire",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2612153200",
      //   "itemClsNm": "Inter connect wire",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2612160200",
      //   "itemClsNm": "Submarine cable",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2612160600",
      //   "itemClsNm": "Coaxial cable",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2612161300",
      //   "itemClsNm": "Insulated or covered cable",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2614180700",
      //   "itemClsNm": "Hot cell lead glass windows",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711150200",
      //   "itemClsNm": "Razor knives",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711151600",
      //   "itemClsNm": "Punching pliers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711152200",
      //   "itemClsNm": "Flaring tool",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711160300",
      //   "itemClsNm": "Anvils",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711172200",
      //   "itemClsNm": "Die stocks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711172600",
      //   "itemClsNm": "Spanner wrenches",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711180900",
      //   "itemClsNm": "Bevels",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711210400",
      //   "itemClsNm": "Tongs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711214700",
      //   "itemClsNm": "Crimping pliers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711220600",
      //   "itemClsNm": "Screed board",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711230300",
      //   "itemClsNm": "Scribers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711270400",
      //   "itemClsNm": "Power grinders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711270600",
      //   "itemClsNm": "Power planes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711271100",
      //   "itemClsNm": "Power staple guns",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711271300",
      //   "itemClsNm": "Impact wrenches",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2324140300",
      //   "itemClsNm": "Internal grinding machine",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2324162000",
      //   "itemClsNm": "Shell reamer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2324211300",
      //   "itemClsNm": "Metal cutting circular saw blade",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2325160100",
      //   "itemClsNm": "Thread rolling machine",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410150400",
      //   "itemClsNm": "Hand trucks or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410150500",
      //   "itemClsNm": "Pallet trucks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410160400",
      //   "itemClsNm": "Lifts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410165600",
      //   "itemClsNm": "Tractor towed crane",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410170800",
      //   "itemClsNm": "Extendable conveyors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410171200",
      //   "itemClsNm": "Belt conveyors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410171500",
      //   "itemClsNm": "Conveyor belting",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410172200",
      //   "itemClsNm": "Chain conveyors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410173000",
      //   "itemClsNm": "Screw conveyor",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2411180300",
      //   "itemClsNm": "Storage tanks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2411211100",
      //   "itemClsNm": "Stabilizer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2411240200",
      //   "itemClsNm": "Hazardous materials cabinets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2411260200",
      //   "itemClsNm": "Jars",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2413150100",
      //   "itemClsNm": "Combined refrigerator freezers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2413150600",
      //   "itemClsNm": "Refrigerated tanks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2414170700",
      //   "itemClsNm": "Reel",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2414171000",
      //   "itemClsNm": "Tag wire",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2510150200",
      //   "itemClsNm": "Busses",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2510150500",
      //   "itemClsNm": "Minivans or vans",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2510161100",
      //   "itemClsNm": "Cargo trucks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2510190300",
      //   "itemClsNm": "Snowmobiles or snow scooter",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2510190700",
      //   "itemClsNm": "Trailer, travel or caravan",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2510191800",
      //   "itemClsNm": "Neighborhood electric vehicle NEV",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2510192100",
      //   "itemClsNm": "Van trucks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2511150800",
      //   "itemClsNm": "Passenger or automobile ferries",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2511171900",
      //   "itemClsNm": "Submarine tenders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2511180600",
      //   "itemClsNm": "Rafts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2511191500",
      //   "itemClsNm": "Dock steps",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2511191700",
      //   "itemClsNm": "Fairleaders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2511192800",
      //   "itemClsNm": "Sail covers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2513150400",
      //   "itemClsNm": "Commercial passenger propeller aircraft",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2513160200",
      //   "itemClsNm": "Cargo transport helicopters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2513170800",
      //   "itemClsNm": "Anti submarine aircraft",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2513190300",
      //   "itemClsNm": "Attack helicopters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2513200200",
      //   "itemClsNm": "Hot air balloons",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2513200500",
      //   "itemClsNm": "Ultra light aircraft",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517190100",
      //   "itemClsNm": "Automobile rims or wheels",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517201100",
      //   "itemClsNm": "Shock absorber",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517210500",
      //   "itemClsNm": "Collision avoidance systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517210600",
      //   "itemClsNm": "Impact sensing systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517290100",
      //   "itemClsNm": "Exterior automobile lighting",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517300300",
      //   "itemClsNm": "Interior railcar lighting",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517381000",
      //   "itemClsNm": "Universal joints",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517381300",
      //   "itemClsNm": "Automatic transmissions",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517400400",
      //   "itemClsNm": "Engine coolant",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517441000",
      //   "itemClsNm": "Vehicle sound systems and components",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2518160200",
      //   "itemClsNm": "Truck chassis",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2518170600",
      //   "itemClsNm": "Temperature controlled container trailers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1217150900",
      //   "itemClsNm": "Reactive dye",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1235230200",
      //   "itemClsNm": "Inorganic metal salts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1235250100",
      //   "itemClsNm": "Formaldehydes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1311100400",
      //   "itemClsNm": "Acrylonitrile butadiene styrene resin",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1311102700",
      //   "itemClsNm": "Urea formaldehyde",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1311102900",
      //   "itemClsNm": "Melamine formaldehyde",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1311103100",
      //   "itemClsNm": "Polyamide",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1311121100",
      //   "itemClsNm": "Polypropylene films",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411150500",
      //   "itemClsNm": "Mimeograph paper",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411150800",
      //   "itemClsNm": "Facsimile paper",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411152500",
      //   "itemClsNm": "Multipurpose paper",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411180100",
      //   "itemClsNm": "Tickets or ticket rolls",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411180200",
      //   "itemClsNm": "Receipts or receipt books",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1412190400",
      //   "itemClsNm": "Offset paper",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1412210600",
      //   "itemClsNm": "Latex treated uncoated paper",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1510161500",
      //   "itemClsNm": "Wood chip fuel",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1512150100",
      //   "itemClsNm": "Engine oil",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1512152500",
      //   "itemClsNm": "Quenching oils",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3137110200",
      //   "itemClsNm": "Sillimanite bricks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3137120200",
      //   "itemClsNm": "Insulating castables",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3137120300",
      //   "itemClsNm": "Low cement castables",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3137120700",
      //   "itemClsNm": "Self flow castable",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3137120800",
      //   "itemClsNm": "Tabular alumina castable",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3210151600",
      //   "itemClsNm": "Circulators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3210154300",
      //   "itemClsNm": "Gauge controller and indicator",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3210160500",
      //   "itemClsNm": "Eraseable programmable read only memory EPROM",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3212150200",
      //   "itemClsNm": "Variable capacitors or varactors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3212150500",
      //   "itemClsNm": "Aluminum electrolytic fixed capacitor",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3213100200",
      //   "itemClsNm": "Semiconductor dies",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3214100900",
      //   "itemClsNm": "Photo tubes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3214101900",
      //   "itemClsNm": "Microwave electron tube",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3214102200",
      //   "itemClsNm": "Voltage regulator electron tube",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3910161500",
      //   "itemClsNm": "Mercury vapor lamp HID",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3911170900",
      //   "itemClsNm": "Emergency light unit",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3911180600",
      //   "itemClsNm": "Light boxes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912100300",
      //   "itemClsNm": "Instrument transformers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912100900",
      //   "itemClsNm": "Electrical or power regulators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912103300",
      //   "itemClsNm": "Potential transformer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912110500",
      //   "itemClsNm": "Switchgear systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912131000",
      //   "itemClsNm": "Utility boxes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912157000",
      //   "itemClsNm": "Recloser",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912163900",
      //   "itemClsNm": "Vacuum interruptor",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912224500",
      //   "itemClsNm": "Magnetic switch",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912231300",
      //   "itemClsNm": "Trip free relay",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912231700",
      //   "itemClsNm": "Latching relay",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010150100",
      //   "itemClsNm": "Air collectors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010160400",
      //   "itemClsNm": "Fans",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010171000",
      //   "itemClsNm": "Reciprocating chiller",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010182600",
      //   "itemClsNm": "Commercial water heaters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010190100",
      //   "itemClsNm": "Vaporizers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010200200",
      //   "itemClsNm": "Water tube boiler",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4014162400",
      //   "itemClsNm": "Lubricated plug valves",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4014163800",
      //   "itemClsNm": "Toggle valves",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4014174500",
      //   "itemClsNm": "Fusible plugs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4014174900",
      //   "itemClsNm": "Vacuum breaker",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4015151300",
      //   "itemClsNm": "Submersible pumps",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4015161200",
      //   "itemClsNm": "Centrifugal compressors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4016150400",
      //   "itemClsNm": "Oil filters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4016160500",
      //   "itemClsNm": "Deodorizing tower",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4016180500",
      //   "itemClsNm": "Filter cloth",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711271900",
      //   "itemClsNm": "Glue guns",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711281200",
      //   "itemClsNm": "Countersinks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2713151100",
      //   "itemClsNm": "Pneumatic grinders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2713151200",
      //   "itemClsNm": "Pneumatic screwdriver",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2713152100",
      //   "itemClsNm": "Pneumatic riveter",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2713160900",
      //   "itemClsNm": "Pneumatic silencers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3010150400",
      //   "itemClsNm": "Steel angles",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3010222100",
      //   "itemClsNm": "Fiber plate",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3010320200",
      //   "itemClsNm": "Stainless steel grating",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3010320400",
      //   "itemClsNm": "Fiberglass grating",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3010360400",
      //   "itemClsNm": "Wood sheathing or sheets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3013150300",
      //   "itemClsNm": "Stone blocks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3013160200",
      //   "itemClsNm": "Ceramic bricks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3013160400",
      //   "itemClsNm": "Stone bricks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3013170400",
      //   "itemClsNm": "Ceramic tiles or flagstones",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3014150800",
      //   "itemClsNm": "Fiber insulation",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3014151100",
      //   "itemClsNm": "Window film",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3015150300",
      //   "itemClsNm": "Roofing fabrics",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3016170300",
      //   "itemClsNm": "Linoleum",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3016180300",
      //   "itemClsNm": "Domestic cupboard",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3016190600",
      //   "itemClsNm": "Molding",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3017150300",
      //   "itemClsNm": "Rolling doors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3017152200",
      //   "itemClsNm": "Air tight door",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3017170900",
      //   "itemClsNm": "Wired glass",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3018150600",
      //   "itemClsNm": "Urinals",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3026640400",
      //   "itemClsNm": "Cork and rubber sheet",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3115160300",
      //   "itemClsNm": "Roller chains",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3115220300",
      //   "itemClsNm": "Stainless steel wire",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116150300",
      //   "itemClsNm": "Drive screws",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116150400",
      //   "itemClsNm": "Machine screws",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116160800",
      //   "itemClsNm": "Lag bolts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116162200",
      //   "itemClsNm": "Shear bolt",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116170300",
      //   "itemClsNm": "Blind nuts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116170800",
      //   "itemClsNm": "Channel nuts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116170900",
      //   "itemClsNm": "Clamping nuts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116173100",
      //   "itemClsNm": "Weld nuts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116181600",
      //   "itemClsNm": "Spacers or standoffs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116220300",
      //   "itemClsNm": "Flat head rivets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116220900",
      //   "itemClsNm": "Button head rivets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116230700",
      //   "itemClsNm": "Mounting plates",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116250400",
      //   "itemClsNm": "Electrical fixture brackets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116290500",
      //   "itemClsNm": "Beam clamps",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116300800",
      //   "itemClsNm": "Disc coupling",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3116320300",
      //   "itemClsNm": "Dowel pin",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3117150400",
      //   "itemClsNm": "Ball bearings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3118170200",
      //   "itemClsNm": "Glands",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3119150400",
      //   "itemClsNm": "Abrasive cloth",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3119151100",
      //   "itemClsNm": "Steel wool",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3120150700",
      //   "itemClsNm": "Fiberglass tape",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3120160400",
      //   "itemClsNm": "Rubber cements",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3120160800",
      //   "itemClsNm": "Foam adhesives",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3120161000",
      //   "itemClsNm": "Glues",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3121150300",
      //   "itemClsNm": "Pigment paints",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3121150800",
      //   "itemClsNm": "Acrylic paints",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3121160200",
      //   "itemClsNm": "Texturing materials",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3126160300",
      //   "itemClsNm": "Steel shells or casings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110411200",
      //   "itemClsNm": "Urine collection containers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110420800",
      //   "itemClsNm": "Dehydrators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110440500",
      //   "itemClsNm": "Shaking incubators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110450700",
      //   "itemClsNm": "Laboratory microwave ovens",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110480200",
      //   "itemClsNm": "Bi distillation units",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110491000",
      //   "itemClsNm": "Laboratory multi sheet or press filters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110510100",
      //   "itemClsNm": "Laboratory vacuum pumps",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110531900",
      //   "itemClsNm": "Polyacrylamide gel making reagents",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110590300",
      //   "itemClsNm": "Complementary deoxyribonucleic acid cDNA synthesis kits",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110622900",
      //   "itemClsNm": "Bottled saline or water for microbiology",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110670100",
      //   "itemClsNm": "Leaf area meter",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110670200",
      //   "itemClsNm": "Photosynthesis measurement apparatus",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111150400",
      //   "itemClsNm": "Pull spring balances",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111150600",
      //   "itemClsNm": "Animal weighing scales",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111151500",
      //   "itemClsNm": "Balance weighing containers or bowls or boats or papers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111151600",
      //   "itemClsNm": "Weight measuring instrument accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111151700",
      //   "itemClsNm": "Analytical balances",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111162300",
      //   "itemClsNm": "Thickness measuring devices",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111163000",
      //   "itemClsNm": "Dial indicator or dial gauge",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111163600",
      //   "itemClsNm": "Cylinder diameter measuring equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111171100",
      //   "itemClsNm": "Electron microscopes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111172700",
      //   "itemClsNm": "Projection microscopes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111173000",
      //   "itemClsNm": "Microscope condensers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111180500",
      //   "itemClsNm": "CO 60 radiography examination equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111190100",
      //   "itemClsNm": "Counters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111210600",
      //   "itemClsNm": "Humidity transmitters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111220200",
      //   "itemClsNm": "Heat tracing equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111220500",
      //   "itemClsNm": "Temperature regulators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111230400",
      //   "itemClsNm": "Moisture meters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111241100",
      //   "itemClsNm": "Pressure controllers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111250400",
      //   "itemClsNm": "Water meters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111270100",
      //   "itemClsNm": "Grain analyzers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111280100",
      //   "itemClsNm": "Speedometers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111303400",
      //   "itemClsNm": "pH test strips or papers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111303600",
      //   "itemClsNm": "Microplates",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111305700",
      //   "itemClsNm": "Sludge densitometer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111310100",
      //   "itemClsNm": "Automotive exhaust emission analyzers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111310500",
      //   "itemClsNm": "Hydrocarbons analyzers or detectors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111331400",
      //   "itemClsNm": "Oil content monitors analyzers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111333400",
      //   "itemClsNm": "Paint coating test equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111360100",
      //   "itemClsNm": "Ammeters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111362100",
      //   "itemClsNm": "Impedance meters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111363900",
      //   "itemClsNm": "Accelerometers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111364500",
      //   "itemClsNm": "Earth leakage devices",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111364600",
      //   "itemClsNm": "Temperature calibrator or simulator",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111365700",
      //   "itemClsNm": "Circuit breaker tester",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111366300",
      //   "itemClsNm": "Transformer tester",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111367000",
      //   "itemClsNm": "Resister test equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215241600",
      //   "itemClsNm": "Dental duplicating materials",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215241700",
      //   "itemClsNm": "Dental ethyl silicate investments",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215242000",
      //   "itemClsNm": "Dental inlay casting waxes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215245000",
      //   "itemClsNm": "Dental instrument cleaning compounds",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215270400",
      //   "itemClsNm": "Dental retainers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215280100",
      //   "itemClsNm": "Periodontal chisels",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4216163200",
      //   "itemClsNm": "Hemodialysis units",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4217160600",
      //   "itemClsNm": "Emergency medical services air splints",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4217161100",
      //   "itemClsNm": "Emergency response litters or stretchers or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4217161200",
      //   "itemClsNm": "Scoop stretchers or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4217210100",
      //   "itemClsNm": "Automated external defibrillators AED or hard paddles",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218151000",
      //   "itemClsNm": "Transcutaneous jaundice meters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218151900",
      //   "itemClsNm": "Drop carrier",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218160200",
      //   "itemClsNm": "Electronic blood pressure units",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218160800",
      //   "itemClsNm": "Blood pressure measuring instrument accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218171300",
      //   "itemClsNm":
      //       "Long term continuous electrocardiography EKG or holter monitoring systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218180100",
      //   "itemClsNm": "Pulse oximeter units",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218190100",
      //   "itemClsNm":
      //       "Acute care fetal or maternal monitoring units or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218190800",
      //   "itemClsNm":
      //       "Intracompartmental pressure monitoring sets or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218191100",
      //   "itemClsNm": "Fetal scalp electrode",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218200500",
      //   "itemClsNm": "Ophthalmoscopes or otoscopes or scope sets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218201100",
      //   "itemClsNm": "Medical exam specula or dilator tips or tip dispensers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218220600",
      //   "itemClsNm": "Mercury medical thermometers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218290100",
      //   "itemClsNm": "Obstetrical or gynecological exam tables",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218301000",
      //   "itemClsNm": "Ophthalmic lensometers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218301100",
      //   "itemClsNm": "Ophthalmic perimeters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218303300",
      //   "itemClsNm": "Spectacle fitting sets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218303500",
      //   "itemClsNm": "Combination refractor keratometers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218304500",
      //   "itemClsNm": "Electroretinogram systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4218305300",
      //   "itemClsNm": "Interpupillary distance meter",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4219180300",
      //   "itemClsNm":
      //       "Clinical bassinets or cribs or pediatric beds or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4219180400",
      //   "itemClsNm": "Medical or surgical bedside rails",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4219180800",
      //   "itemClsNm": "Patient care beds or accessories for specialty care",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4219190600",
      //   "itemClsNm": "Blanket or solution warmer cabinets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4219190800",
      //   "itemClsNm": "Medical chart caddies or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4219221000",
      //   "itemClsNm": "Wheelchairs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220180300",
      //   "itemClsNm": "Mammography x ray equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220180500",
      //   "itemClsNm": "Medical cine fluoroscopy equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220181200",
      //   "itemClsNm":
      //       "Medical x ray tables or stands or chairs or cabinets or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220181700",
      //   "itemClsNm": "X ray bone densitometers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220184900",
      //   "itemClsNm": "Fluorescent scanner",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4220200100",
      //   "itemClsNm": "Medical gamma cameras for general use",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111382700",
      //   "itemClsNm": "Soil unconfined compression apparatus",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111390900",
      //   "itemClsNm": "Soil core sampling apparatus",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111421700",
      //   "itemClsNm": "Lead line",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111451000",
      //   "itemClsNm": "Torque limiter",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111460100",
      //   "itemClsNm": "Abrasion testers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111460200",
      //   "itemClsNm": "Compression testers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111460600",
      //   "itemClsNm": "Creep testers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111460800",
      //   "itemClsNm": "Fatigue testers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111461100",
      //   "itemClsNm": "Hardness testers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111463700",
      //   "itemClsNm": "Beam test apparatus",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111541500",
      //   "itemClsNm": "Electron spectroscopy system for chemical analysis",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111571000",
      //   "itemClsNm": "Gas chromatography GC columns",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111580700",
      //   "itemClsNm": "Chemistry analyzers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111612900",
      //   "itemClsNm": "Microbiology or bacteriology test kits or supplies",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4111616400",
      //   "itemClsNm":
      //       "Test kit or probe for laboratory proficiency assessment or laboratory performance improvement tracking",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112151400",
      //   "itemClsNm": "Pipette pumps",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112160100",
      //   "itemClsNm": "Filter tip pipette tips",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112160200",
      //   "itemClsNm": "Aerosol barrier pipette tips",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112180500",
      //   "itemClsNm": "Laboratory graduated cylinders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112240300",
      //   "itemClsNm": "Laboratory spatulas",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112250200",
      //   "itemClsNm": "Laboratory stoppers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112260500",
      //   "itemClsNm": "Microscope immersion oil",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112300200",
      //   "itemClsNm": "Cabinet desiccators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4112340100",
      //   "itemClsNm": "Dosing cups",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4212151300",
      //   "itemClsNm": "Veterinary castration instruments",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4212160100",
      //   "itemClsNm": "Gastrointestinal veterinary products",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4212160700",
      //   "itemClsNm": "Genito urinary system sex or hormone veterinary products",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4212170100",
      //   "itemClsNm": "Veterinary surgical tables",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4213150400",
      //   "itemClsNm": "Patient gowns",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214160300",
      //   "itemClsNm": "Emesis basins",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214210400",
      //   "itemClsNm": "Medical hydrocollators or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214230200",
      //   "itemClsNm": "Medical charting systems components or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214240200",
      //   "itemClsNm": "Medical suction cannulas or tubes or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214240400",
      //   "itemClsNm": "Medical suction or vacuum appliances",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214261600",
      //   "itemClsNm": "Blood collection syringes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214290300",
      //   "itemClsNm": "Eyeglass frames",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214291300",
      //   "itemClsNm": "Contact lenses",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4214310700",
      //   "itemClsNm": "Perinometer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215150100",
      //   "itemClsNm": "Cosmetic dentistry curing lights or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215166000",
      //   "itemClsNm": "Dental applicators or absorbents",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215166500",
      //   "itemClsNm": "Dental gages or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215180200",
      //   "itemClsNm": "Dental material pluggers or tips or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215180300",
      //   "itemClsNm": "Dental amalgam capsules",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215200900",
      //   "itemClsNm": "Dental x ray viewers or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215210300",
      //   "itemClsNm": "Dental impression tray adhesives",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215220800",
      //   "itemClsNm": "Dental laboratory engines or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4215221900",
      //   "itemClsNm": "Dental laboratory waxing units",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4017530700",
      //   "itemClsNm": "Pipe saddles",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110150400",
      //   "itemClsNm": "Homogenizers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110170100",
      //   "itemClsNm": "Laboratory mills",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110242600",
      //   "itemClsNm": "Heating or drying equipment or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110301000",
      //   "itemClsNm": "Blood bank refrigerators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110301100",
      //   "itemClsNm": "General purpose refrigerators or refrigerator freezers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110320700",
      //   "itemClsNm": "Microplate washers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110331700",
      //   "itemClsNm": "Surface tension measuring instruments",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110340900",
      //   "itemClsNm": "Heated reach in environmental or growth chambers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110390200",
      //   "itemClsNm": "Refrigerated microcentrifuges",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110390800",
      //   "itemClsNm": "Vacuum centrifuges",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110400800",
      //   "itemClsNm": "Air samplers or collectors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4110402100",
      //   "itemClsNm": "Fraction collector",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4230150600",
      //   "itemClsNm": "Dual earpiece stethoscopes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4231151000",
      //   "itemClsNm": "Foam dressings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4231170300",
      //   "itemClsNm": "Medical or surgical tapes for skin attachment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4231211500",
      //   "itemClsNm": "Ostomy irrigation sleeves",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4231220200",
      //   "itemClsNm": "Suturing kits or trays or packs or sets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4232150200",
      //   "itemClsNm": "Orthopedic guidewire or guide pin or guide rod",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4232150300",
      //   "itemClsNm": "Bone graft extender or void filler or substitute",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4232200200",
      //   "itemClsNm": "Wrist joint implant",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4320150300",
      //   "itemClsNm": "Central processing unit CPU processors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4320153300",
      //   "itemClsNm": "Musical instrument digital interface MIDI interfaces",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4320161400",
      //   "itemClsNm": "Console extenders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4320182600",
      //   "itemClsNm": "Compact disk read only memory CD ROM array",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4320210200",
      //   "itemClsNm": "Floppy disk cases",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321161300",
      //   "itemClsNm": "Computer or notebook stands",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321170500",
      //   "itemClsNm": "Game pads or joy sticks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321171100",
      //   "itemClsNm": "Scanners",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321172000",
      //   "itemClsNm": "Point of sale payment terminal",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321172200",
      //   "itemClsNm": "Business card scanner",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321211400",
      //   "itemClsNm": "Digital image printers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321211600",
      //   "itemClsNm": "Radio frequency identification RFID tag printer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4321211700",
      //   "itemClsNm": "Printer controller",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322150500",
      //   "itemClsNm": "Standalone telephone caller identification",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322152900",
      //   "itemClsNm": "Call meter",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322172600",
      //   "itemClsNm": "Reflector for antenna",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322250100",
      //   "itemClsNm": "Firewall network security equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322261200",
      //   "itemClsNm": "Network switches",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322281800",
      //   "itemClsNm": "Telephone distributing terminal frame",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322282000",
      //   "itemClsNm": "Voice echo cancellers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4322330600",
      //   "itemClsNm": "Network system cabinet or enclosure",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4323151200",
      //   "itemClsNm": "License management software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4323250100",
      //   "itemClsNm": "Foreign language software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4323260400",
      //   "itemClsNm": "Computer aided design CAD software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4323260500",
      //   "itemClsNm": "Analytical or scientific software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4323320100",
      //   "itemClsNm": "Authentication server software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4323320500",
      //   "itemClsNm": "Transaction security and virus protection software",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410160200",
      //   "itemClsNm": "Paper punching or binding machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410180800",
      //   "itemClsNm": "Scientific calculator",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410180900",
      //   "itemClsNm": "Desktop calculator",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410260400",
      //   "itemClsNm": "Stenotype machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410280500",
      //   "itemClsNm": "Binding punch machine",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410290600",
      //   "itemClsNm": "Computer or office equipment cleaning kit",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410300400",
      //   "itemClsNm": "Fusers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410311600",
      //   "itemClsNm": "Kit for printer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410312500",
      //   "itemClsNm": "Printer maintenance kit",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4410312600",
      //   "itemClsNm": "Digital duplicating machine ink",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4411151500",
      //   "itemClsNm": "File storage boxes or organizers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4411190100",
      //   "itemClsNm": "Planning boards or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4411190500",
      //   "itemClsNm": "Dry erase boards or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4411190700",
      //   "itemClsNm": "Bulletin boards or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4411191400",
      //   "itemClsNm": "Chart hanger",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4412161100",
      //   "itemClsNm": "Paper or eyelet punches",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4412161300",
      //   "itemClsNm": "Staple removers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5043326400",
      //   "itemClsNm": "Dried organic sugar snow corn",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5043361200",
      //   "itemClsNm": "Dried organic sugarhat endives",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5043690800",
      //   "itemClsNm": "Dried organic oregon sugar pod peas",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5044622200",
      //   "itemClsNm": "Frozen sugar loaf squash",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5032348400",
      //   "itemClsNm": "Dried sugarose grapes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5033680100",
      //   "itemClsNm": "Dried organic kampong mauve sugar apple",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5034680300",
      //   "itemClsNm": "Frozen thai lessard sugar apple",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5035348400",
      //   "itemClsNm": "Frozen organic sugarose grapes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5036348500",
      //   "itemClsNm": "Canned or jarred sugarthirteen grapes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5046192200",
      //   "itemClsNm": "Canned or jarred sugar beets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5046622200",
      //   "itemClsNm": "Canned or jarred sugar loaf squash",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5047326200",
      //   "itemClsNm": "Canned or jarred organic sugar and gold corn",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5052560400",
      //   "itemClsNm": "Non GMO kona sugarloaf pineapple",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5052560900",
      //   "itemClsNm": "Non GMO sugarloaf pineapple",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5052680300",
      //   "itemClsNm": "Non GMO thai lessard sugar apples",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5053158700",
      //   "itemClsNm": "Dried non GMO tsugaru apples",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5053348500",
      //   "itemClsNm": "Dried non GMO sugarthirteen grapes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5054158700",
      //   "itemClsNm": "Frozen non GMO tsugaru apples",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5054348400",
      //   "itemClsNm": "Frozen non GMO sugarose grapes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5054680100",
      //   "itemClsNm": "Frozen non GMO kampong mauve sugar apple",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5054680200",
      //   "itemClsNm": "Frozen non GMO seedless sugar apple",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5055465400",
      //   "itemClsNm": "Canned or jarred non GMO sugar baby melons",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5055536100",
      //   "itemClsNm": "Canned or jarred non GMO sugar lady peaches",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5055680300",
      //   "itemClsNm": "Canned or jarred non GMO thai lessard sugar apple",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5056158700",
      //   "itemClsNm": "Non GMO tsugaru apple purees",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5056670100",
      //   "itemClsNm": "Non GMO kampong mauve sugar apple purees",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5060326200",
      //   "itemClsNm": "Frozen Non GMO sugar and gold corn",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5062351200",
      //   "itemClsNm": "Non GMO sugarhat endive purees",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5062670900",
      //   "itemClsNm": "Non GMO butter and sugar corn purees",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5021161000",
      //   "itemClsNm": "Tobacco pipe cleaners",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "8527250400",
      //   "itemClsNm":
      //       "Diagnosis of mental and behavioral disorders due to use of tobacco withdrawal state",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410163400",
      //   "itemClsNm": "Chain bags",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4213211100",
      //   "itemClsNm": "Hospital bio-hazard bags",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4216150500",
      //   "itemClsNm": "Peritoneal dialysis drainage bags or containers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410161400",
      //   "itemClsNm": "Air bags for loading",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4223150400",
      //   "itemClsNm": "Enteral nutrition bags or containers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "8411160300",
      //   "itemClsNm": "Internal audits",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "8413152000",
      //   "itemClsNm": "Insurance of motorcycles",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "8512200100",
      //   "itemClsNm": "Dentists services",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3110191100",
      //   "itemClsNm": "Precious metal investment casting",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3129122000",
      //   "itemClsNm": "Non metallic machined impact extrusions",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3129132000",
      //   "itemClsNm": "Non metallic machined cold extrusions",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3135110600",
      //   "itemClsNm": "Non metallic ultra violet welded tube assemblies",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3134110600",
      //   "itemClsNm": "Non metallic welded or brazed sheet assemblies",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3134130600",
      //   "itemClsNm": "Non metallic ultra violet welded sheet assemblies",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "7215290900",
      //   "itemClsNm": "Metal storage tank erection service",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1510170300",
      //   "itemClsNm": "No.5 Residual heavy fuel oil",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2014250100",
      //   "itemClsNm": "Oil field water oil centrifuges",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "7116120500",
      //   "itemClsNm": "Oilfield planning services",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3018151400",
      //   "itemClsNm": "Toilet tank covers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3120153300",
      //   "itemClsNm": "Lead foil tape",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "7112101200",
      //   "itemClsNm": "Oilfield pressure testing services",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "7112110800",
      //   "itemClsNm": "Coring through coiled tubing services",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010185100",
      //   "itemClsNm": "Boiler parts and accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5124184200",
      //   "itemClsNm":
      //       "Calcium caseinate/cod liver oil/lanolin/lanolin alcohol/methylbe",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3018160300",
      //   "itemClsNm": "Toilet seat",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3018160400",
      //   "itemClsNm": "Toilet seat lid",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5124187100",
      //   "itemClsNm": "Glycerin/silicone oil/triethanolamine",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4713160800",
      //   "itemClsNm": "Toilet brushes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2012250200",
      //   "itemClsNm": "Coiled tubing truck crane units",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5124184900",
      //   "itemClsNm": "Castor oil/peruvian balsam/trypsin",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4016160400",
      //   "itemClsNm": "Oil regenerator",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "7115100500",
      //   "itemClsNm": "Oilfield well data transmission services",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "7112140600",
      //   "itemClsNm": "Oilfield drilling bit footage contracts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "7112270300",
      //   "itemClsNm": "Oilfield rod pump repair services",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "7112271000",
      //   "itemClsNm": "Oilfield tubular maintenance services",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1111150100",
      //   "itemClsNm": "Soil",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1111160800",
      //   "itemClsNm": "Limestone",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1111170100",
      //   "itemClsNm": "Silica sand",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1111181000",
      //   "itemClsNm": "Fullers earth",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1114160400",
      //   "itemClsNm": "Paper wastes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115150900",
      //   "itemClsNm": "Silk fibers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115151200",
      //   "itemClsNm": "Glass fibers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115160800",
      //   "itemClsNm": "Nylon thread",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115171000",
      //   "itemClsNm": "Jute yarn",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1115171100",
      //   "itemClsNm": "Coir yarn",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1116160100",
      //   "itemClsNm": "Plain weave wool fabrics",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1116230500",
      //   "itemClsNm": "Cow leather",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1119160300",
      //   "itemClsNm": "Ferrous alloy scrap",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1119160400",
      //   "itemClsNm": "Non ferrous alloy scrap",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1213170100",
      //   "itemClsNm": "Blasting caps",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1214190100",
      //   "itemClsNm": "Chlorine Cl",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1214190300",
      //   "itemClsNm": "Nitrogen N",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1214200400",
      //   "itemClsNm": "Argon gas Ar",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1216170500",
      //   "itemClsNm": "Basic buffers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1216190100",
      //   "itemClsNm": "Anti foaming agents",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015153400",
      //   "itemClsNm": "Cantaloupe seeds or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015180800",
      //   "itemClsNm": "Thyme seeds or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015181100",
      //   "itemClsNm": "Ginseng roots or seedlings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1015200200",
      //   "itemClsNm": "Conifer tree seeds or cuttings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1016180300",
      //   "itemClsNm": "Philodendrons",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1017150700",
      //   "itemClsNm": "urea fertilizer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1017161100",
      //   "itemClsNm": "Calcium fertilizer",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110152200",
      //   "itemClsNm": "Activated carbon",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110152400",
      //   "itemClsNm": "Fluorspar",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110152900",
      //   "itemClsNm": "Zeolite",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110160900",
      //   "itemClsNm": "Zinc ore",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110161700",
      //   "itemClsNm": "Tantalum ore",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110170100",
      //   "itemClsNm": "Slag or ash",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110170900",
      //   "itemClsNm": "Antimony",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1110171000",
      //   "itemClsNm": "Cadmium",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2010161800",
      //   "itemClsNm": "Apron feeder",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2011160900",
      //   "itemClsNm": "Sinker drills",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2110170200",
      //   "itemClsNm": "Haymaking machinery",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2110170300",
      //   "itemClsNm": "Harvesters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2110180400",
      //   "itemClsNm": "Fertilizer spreaders or distributors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2110190300",
      //   "itemClsNm": "Incubators or brooders for poultry",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2110200400",
      //   "itemClsNm": "Rice cleaning or hulling equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210152600",
      //   "itemClsNm": "Track excavators",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210153500",
      //   "itemClsNm": "Pile extractor",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210160400",
      //   "itemClsNm": "Vibratory plates",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210161400",
      //   "itemClsNm": "Concrete paving strike offs",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210170200",
      //   "itemClsNm": "Earthmoving buckets or its parts or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2210170900",
      //   "itemClsNm": "Grapples",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2310150800",
      //   "itemClsNm": "Cutting machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2310151100",
      //   "itemClsNm": "Turning machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2310151200",
      //   "itemClsNm": "Sawing machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2310152500",
      //   "itemClsNm": "Oscillating spindle sander",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2312150800",
      //   "itemClsNm": "Finishing machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2315150200",
      //   "itemClsNm": "Coating machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2315150800",
      //   "itemClsNm": "Vacuum molding machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2315151000",
      //   "itemClsNm": "Plastic cutting machinery",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2315190200",
      //   "itemClsNm": "Slitters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2519150200",
      //   "itemClsNm": "Ground support test or maintenance systems",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2519151000",
      //   "itemClsNm": "Ground power units for aircraft",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520150100",
      //   "itemClsNm": "Aircraft spoilers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520150500",
      //   "itemClsNm": "Aircraft slats",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520150900",
      //   "itemClsNm": "Aircraft ailerons",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520170700",
      //   "itemClsNm": "Aircraft gyros",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520190400",
      //   "itemClsNm": "Parachutes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2520260700",
      //   "itemClsNm": "Aircraft oxygen equipment",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610150100",
      //   "itemClsNm": "Hydraulic engines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610171700",
      //   "itemClsNm": "Engine heaters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610174300",
      //   "itemClsNm": "Engine valves",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2610175500",
      //   "itemClsNm": "Valve guide",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2611161100",
      //   "itemClsNm": "Auxiliary generator",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2611170400",
      //   "itemClsNm": "Battery chargers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2611171400",
      //   "itemClsNm": "Zinc air",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2611171800",
      //   "itemClsNm": "Silver oxide batteries",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2611180300",
      //   "itemClsNm": "Round belts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2612151000",
      //   "itemClsNm": "Trolley wire",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2612163000",
      //   "itemClsNm": "Cable accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2612170100",
      //   "itemClsNm": "Panel wiring harness",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711150500",
      //   "itemClsNm": "Punches or nail sets or drifts",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711151300",
      //   "itemClsNm": "Hose cutter",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711170200",
      //   "itemClsNm": "Nut drivers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711170400",
      //   "itemClsNm": "Sockets",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711171300",
      //   "itemClsNm": "Combination wrenches",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711171500",
      //   "itemClsNm": "Torque wrenches",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711172700",
      //   "itemClsNm": "Chuck keys",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711173700",
      //   "itemClsNm": "Hand push automatic screwdriver",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711180200",
      //   "itemClsNm": "Levels",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711181100",
      //   "itemClsNm": "Folding ruler",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711200300",
      //   "itemClsNm": "Rakes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711200800",
      //   "itemClsNm": "Hoes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711211300",
      //   "itemClsNm": "Slip or groove joint pliers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711230200",
      //   "itemClsNm": "Awls",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2711250400",
      //   "itemClsNm": "Wedges",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2318150600",
      //   "itemClsNm": "Washing machinery",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2318170100",
      //   "itemClsNm": "Smoking machinery",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2323100100",
      //   "itemClsNm": "Tool holder",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2324220200",
      //   "itemClsNm": "Gear hobbing machine",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2327140100",
      //   "itemClsNm": "Submerged arc welding machine",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2327171200",
      //   "itemClsNm": "Welding or soldering kit",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2327181200",
      //   "itemClsNm": "Welding rod",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410150200",
      //   "itemClsNm": "Bulk transporters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410163800",
      //   "itemClsNm": "Wire rope sling",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2410190300",
      //   "itemClsNm": "Drum lifters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2411220400",
      //   "itemClsNm": "Metallic pails",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2411240100",
      //   "itemClsNm": "Tool chest or cabinet",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2411270100",
      //   "itemClsNm": "Wood pallet",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2510150300",
      //   "itemClsNm": "Automobiles or cars",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2510160200",
      //   "itemClsNm": "Tow trucks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2510180100",
      //   "itemClsNm": "Motorcycles",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2510193800",
      //   "itemClsNm": "Bloodmobile",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2511151400",
      //   "itemClsNm": "Icebreaker",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2511170900",
      //   "itemClsNm": "Destroyers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2511171100",
      //   "itemClsNm": "Fast combat support ships",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2511192000",
      //   "itemClsNm": "Marine fenders",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2511192200",
      //   "itemClsNm": "Mooring whips",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2513190600",
      //   "itemClsNm": "Tilt rotor wing aircraft",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2516150600",
      //   "itemClsNm": "Racing bicycles",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517220300",
      //   "itemClsNm": "Automotive doors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517290700",
      //   "itemClsNm": "Vehicle headlight",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517300100",
      //   "itemClsNm": "Interior automobile lighting",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517370100",
      //   "itemClsNm": "Catalytic converters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517420500",
      //   "itemClsNm": "Tie Rods",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "2517440700",
      //   "itemClsNm": "Pedals",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1216490500",
      //   "itemClsNm": "Waterproof admixture",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1217150700",
      //   "itemClsNm": "Sulfur dye",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1235220300",
      //   "itemClsNm": "Antibodies",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1310160800",
      //   "itemClsNm": "Reclaimed rubber",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1311101600",
      //   "itemClsNm": "Polyethylene",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1311102500",
      //   "itemClsNm": "Polyvinyl chloride resin",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411150700",
      //   "itemClsNm": "Printer or copier paper",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411151400",
      //   "itemClsNm": "Paper pads or notebooks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411154000",
      //   "itemClsNm": "Stamp paper",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411154200",
      //   "itemClsNm": "Korean paper for stationery",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411160500",
      //   "itemClsNm": "Greeting or note or post cards",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411180400",
      //   "itemClsNm": "Bills or bill books",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1411183000",
      //   "itemClsNm": "Engrossing paper",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1412150100",
      //   "itemClsNm": "Bleached paperboard",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1412181200",
      //   "itemClsNm": "Photography paper",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1511150500",
      //   "itemClsNm": "Butane",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1511151100",
      //   "itemClsNm": "Liquefied natural gas LNG",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "1512150200",
      //   "itemClsNm": "Cutting oil",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3137110300",
      //   "itemClsNm": "Acid resistant bricks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3137110600",
      //   "itemClsNm": "Calcium silicate blocks",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3210161700",
      //   "itemClsNm": "Smart cards",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3210161900",
      //   "itemClsNm": "Linear integrated circuits",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3211170200",
      //   "itemClsNm": "Thyristors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3212160900",
      //   "itemClsNm": "Fixed resistors",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3212161400",
      //   "itemClsNm": "Metal film oxide resistor",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3214100300",
      //   "itemClsNm": "Magnetrons",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3910161300",
      //   "itemClsNm": "Infrared lamps",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3911150400",
      //   "itemClsNm": "Stage or projection or studio lighting system",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3911150600",
      //   "itemClsNm": "Chandeliers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3911160300",
      //   "itemClsNm": "Roadway or highway lighting",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3911160800",
      //   "itemClsNm": "Residential street lights",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3911180900",
      //   "itemClsNm": "Light conditioner filters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912101000",
      //   "itemClsNm": "Magnetic coils",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912101300",
      //   "itemClsNm": "Electric rotary converters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912110400",
      //   "itemClsNm": "Motor control centers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912130600",
      //   "itemClsNm": "Switch box",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912140400",
      //   "itemClsNm": "Electrical sleeves",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912153400",
      //   "itemClsNm": "Indicator or pilot lights",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912156100",
      //   "itemClsNm": "Pendant control station",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912161500",
      //   "itemClsNm": "Air circuit breakers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912161700",
      //   "itemClsNm": "Fuse parts or accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912161800",
      //   "itemClsNm": "Fuse wire",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912170600",
      //   "itemClsNm": "Transformer bushings",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912231000",
      //   "itemClsNm": "Selecting ground relay",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912231600",
      //   "itemClsNm": "Reclosing relay",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3912232000",
      //   "itemClsNm": "Horizontal relay",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3913170400",
      //   "itemClsNm": "Cable tray",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "3913170500",
      //   "itemClsNm": "Cable tray fitting and accessories",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010150200",
      //   "itemClsNm": "Air exhausters",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010150400",
      //   "itemClsNm": "Ventilation dampers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010180200",
      //   "itemClsNm": "Heat exchangers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010180700",
      //   "itemClsNm": "Solar heating units",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4010183400",
      //   "itemClsNm": "Burners",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4014160400",
      //   "itemClsNm": "Safety valves",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4014160600",
      //   "itemClsNm": "Relief valves",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4014162200",
      //   "itemClsNm": "Inline check valves",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4014173100",
      //   "itemClsNm": "Nozzles",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4014173400",
      //   "itemClsNm": "Hose fitting",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4014173600",
      //   "itemClsNm": "Grease fitting",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4015151000",
      //   "itemClsNm": "Water pumps",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5020241300",
      //   "itemClsNm": "Tangerine juice",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5020260200",
      //   "itemClsNm": "Pear juice",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "5022130100",
      //   "itemClsNm": "Vegetable flour",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4412163100",
      //   "itemClsNm": "Glue dispensers or refills",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4412163500",
      //   "itemClsNm": "Adhesive tape spindles",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4412170800",
      //   "itemClsNm": "Markers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4412201300",
      //   "itemClsNm": "Report covers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4510150700",
      //   "itemClsNm": "Printing presses",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4510151200",
      //   "itemClsNm":
      //       "Thermal transfer printer for commercial printing applications",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4510180300",
      //   "itemClsNm": "Book punching machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4510180600",
      //   "itemClsNm": "Book gathering machines",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4510190200",
      //   "itemClsNm": "Platemakers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4510190500",
      //   "itemClsNm": "Drawing or retouching boards",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4511161000",
      //   "itemClsNm": "Epidiascopes",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4511172200",
      //   "itemClsNm": "Cassette deck",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4511172300",
      //   "itemClsNm": "Hard disk recorder",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4512150200",
      //   "itemClsNm": "Instant print cameras",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // },
      // {
      //   "itemClsCd": "4512162300",
      //   "itemClsNm": "Camera controllers",
      //   "itemClsLvl": 5,
      //   "taxTyCd": "B",
      //   "mjrTgYn": "N",
      //   "useYn": "Y"
      // }
    ];

    for (final item in itemClsList) {
      // Check if an item with the same 'itemClsCd' already exists
      final existingItem = realm.query<UnversalProduct>(
        r'itemClsCd == $0',
        [item['itemClsCd']],
      ).firstOrNull;

      // If it doesn't exist, add it
      if (existingItem == null) {
        realm.add(UnversalProduct(
          ObjectId(),
          id: 1,
          itemClsCd: item['itemClsCd'],
          itemClsNm: item['itemClsNm'],
          itemClsLvl: item['itemClsLvl'],
          taxTyCd: item['taxTyCd'],
          mjrTgYn: item['mjrTgYn'],
          useYn: item['useYn'],
        ));
      }
    }
  }

  @override
  Future<LocalRealmInterface> configureLocal(
      {required bool useInMemory}) async {
    talker.warning("Opening local realm alongside the synced one!");

    // Set API keys based on the environment
    if (foundation.kDebugMode) {
      apihub = AppSecrets.apihubUat;
      commApi = AppSecrets.commApi;
    } else {
      apihub = AppSecrets.apihubProd;
      commApi = AppSecrets.commApi;
    }

    String path = await dbPath(path: 'local');
    Configuration config;

    // Close any existing local realm instance
    localRealm?.close();

    try {
      if (ProxyService.box.encryptionKey().isEmpty) {
        throw Exception("null encryption");
      }
      config = Configuration.local(
        [
          UserActivity.schema,
          Business.schema,
          Branch.schema,
          Drawers.schema,
          UnversalProduct.schema,
        ],
        initialDataCallback: dataCb,
        path: path,
        encryptionKey: ProxyService.box.encryptionKey().toIntList(),
      );
      localRealm = Realm(config);
    } catch (e) {
      talker.warning(e);
      localRealm?.close();
      config = Configuration.inMemory(
        [UserActivity.schema],
        path: path,
      );
      localRealm = Realm(config);
    }

    return this;
  }

  @override
  bool isRealmClosed() {
    return localRealm?.isClosed ?? true;
  }

  @override
  Future<List<UserActivity>> activities({required int userId}) async {
    // Get the current date
    DateTime now = DateTime.now();

    // Calculate the start and end of the current day
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = startOfDay.add(Duration(days: 1));

    return localRealm!.query<UserActivity>(
        r'lastTouched BETWEEN {$0,$1} ', [startOfDay, endOfDay]).toList();
  }

  Future<bool> hasNoActivityInLast5Minutes(
      {required int userId, int? refreshRate = 5}) async {
    // Get the current time
    DateTime currentTime = DateTime.now();

    // Calculate the time [timer] minutes ago
    DateTime fiveMinutesAgo =
        currentTime.subtract(Duration(minutes: refreshRate!));

    // Retrieve the user activities
    List<UserActivity> userActivities = await activities(userId: userId);

    // Assume no activity in the last 5 minutes by default
    bool returnValue = true;

    for (var activity in userActivities) {
      if (activity.lastTouched!.isAfter(fiveMinutesAgo)) {
        // The user has done an activity within the last 5 minutes
        returnValue = false;
        break; // No need to continue checking, we found an activity
      }
    }
    return returnValue;
  }

  ///TODO: work on this function to be efficient
  @override
  Future<void> refreshSession(
      {required int branchId, int? refreshRate = 5}) async {
    while (true) {
      try {
        int? userId = ProxyService.box.getUserId();
        if (userId == null) return;
        bool noActivity = await hasNoActivityInLast5Minutes(
            userId: userId, refreshRate: refreshRate);
        talker.warning(noActivity.toString());

        if (noActivity) {
          Tenant? tenant = await getTenantBYUserId(userId: userId);
          ProxyService.realm.realm!
              .writeAsync(() => tenant!.sessionActive = false);
        }
      } catch (error, s) {
        talker.error('Error fetching tenant: $s');
      }
      await Future.delayed(Duration(minutes: refreshRate!));
    }
  }

  Future<void> _configureTheBox(String userPhone, IUser user) async {
    await ProxyService.box.writeString(key: 'userPhone', value: userPhone);
    await ProxyService.box.writeString(key: 'bearerToken', value: user.token);

    talker.warning("Upon login: UserId ${user.id}: UserPhone: ${userPhone}");

    /// the token from firebase that link this user with firebase
    /// so it can be used to login to other devices
    await ProxyService.box.writeString(key: 'uid', value: user.uid ?? "");
    await ProxyService.box.writeInt(key: 'userId', value: user.id!);

    if (user.tenants.isEmpty) {
      talker.error("User created does not have tenants");
      throw BusinessNotFoundException(
          term:
              "No tenant added to the user, if a business is added it should have one tenant");
    }
    if (user.tenants.first.businesses.isEmpty ||
        user.tenants.first.branches.isEmpty) {
      throw BusinessNotFoundException(
          term:
              "No tenant added to the user, if a business is added it should have one tenant");
    }
    await ProxyService.box.writeInt(
        key: 'branchId',
        value:
            user.tenants.isEmpty ? 0 : user.tenants.first.branches.first.id!);

    talker.info("UserId:" + user.id.toString());
    await ProxyService.box.writeInt(
        key: 'businessId',
        value:
            user.tenants.isEmpty ? 0 : user.tenants.first.businesses.first.id!);
    await ProxyService.box.writeString(
        key: 'encryptionKey',
        value: user.tenants.first.businesses.first.encryptionKey);
  }

  @override
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false}) async {
    String phoneNumber = userPhone;

    if (!isEmail(userPhone) && !phoneNumber.startsWith('+')) {
      phoneNumber = '+' + phoneNumber;
    }
    http.Response response;
    String? uid = firebase.FirebaseAuth.instance.currentUser?.uid ?? null;

    response = await flipperHttpClient.post(Uri.parse(apihub + '/v2/api/user'),
        body: jsonEncode(
            <String, String?>{'phoneNumber': phoneNumber, 'uid': uid}));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      // Parse the JSON response
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      // Create an IUser object using the fromJson constructor
      IUser user = IUser.fromJson(jsonResponse);
      await _configureTheBox(userPhone, user);

      await configureLocal(useInMemory: false);
      await ProxyService.realm
          .configure(useInMemoryDb: false, useFallBack: false);

      /// after we login this is the best time to open the synced database to start persisting the data
      /// this will close whatever inMemory db we opened temporarly to have the app running

      if (stopAfterConfigure) return user;
      if (skipDefaultAppSetup == false) {
        await ProxyService.box.writeString(
            key: 'defaultApp',

            /// because we don update default app from server
            /// because we want the ability of switching apps to be entirely offline
            /// then if we have a default app in the box we use it if it only different from "1"
            value: user.tenants.isEmpty
                ? 'null'
                : ProxyService.box.getDefaultApp() != "1"
                    ? ProxyService.box.getDefaultApp()
                    : user.tenants.first.businesses.first.businessTypeId
                        .toString());
      }

      for (ITenant tenant in user.tenants) {
        Tenant iTenant = Tenant(ObjectId(),
            isDefault: tenant.isDefault,
            id: tenant.id,
            name: tenant.name,
            businessId: tenant.businessId,
            nfcEnabled: tenant.nfcEnabled,
            email: tenant.email,
            userId: user.id!,
            phoneNumber: tenant.phoneNumber,
            pin: tenant.pin);
        final businessesToAdd = <Business>[];
        final branchToAdd = <Branch>[];

        for (IBusiness business in tenant.businesses) {
          Business biz = Business(ObjectId(),
              userId: business.userId,
              serverId: business.id,
              name: business.name,
              currency: business.currency,
              categoryId: business.categoryId,
              latitude: business.latitude,
              longitude: business.longitude,
              timeZone: business.timeZone,
              country: business.country,
              businessUrl: business.businessUrl,
              hexColor: business.hexColor,
              imageUrl: business.imageUrl,
              type: business.type,
              active: business.active,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
              createdAt: business.createdAt,
              deviceToken: business.deviceToken,
              backUpEnabled: business.backUpEnabled,
              subscriptionPlan: business.subscriptionPlan,
              nextBillingDate: business.nextBillingDate,
              previousBillingDate: business.previousBillingDate,
              isLastSubscriptionPaymentSucceeded:
                  business.isLastSubscriptionPaymentSucceeded,
              backupFileId: business.backupFileId,
              email: business.email,
              lastDbBackup: business.lastDbBackup,
              fullName: business.fullName,
              tinNumber: business.tinNumber,
              bhfId: business.bhfId,
              dvcSrlNo: business.dvcSrlNo,
              adrs: business.adrs,
              taxEnabled: business.taxEnabled,
              taxServerUrl: business.taxServerUrl,
              isDefault: business.isDefault,
              businessTypeId: business.businessTypeId,
              lastTouched: business.lastTouched,
              action: business.action,
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey);
          Business? exist = localRealm!
              .query<Business>(r'serverId == $0', [business.id]).firstOrNull;
          if (exist == null) {
            businessesToAdd.add(biz);
          }
        }
        localRealm!.writeAsync(() {
          localRealm!.addAll<Business>(businessesToAdd);
        });
        for (IBranch brannch in tenant.branches) {
          Branch branch = Branch(ObjectId(),
              active: brannch.active,
              serverId: brannch.id,
              description: brannch.description,
              name: brannch.name,
              businessId: brannch.businessId,
              longitude: brannch.longitude,
              latitude: brannch.latitude,
              isDefault: brannch.isDefault,
              lastTouched: brannch.lastTouched,
              action: brannch.action,
              deletedAt: brannch.deletedAt);
          Branch? exist = localRealm!
              .query<Branch>(r'serverId == $0', [branch.serverId]).firstOrNull;
          if (exist == null) {
            branchToAdd.add(branch);
          }
        }

        localRealm!.write(() {
          localRealm!.addAll<Branch>(branchToAdd);
        });
        final permissionToAdd = <LPermission>[];
        for (IPermission permission in tenant.permissions) {
          LPermission? exist = ProxyService.realm.realm!
              .query<LPermission>(r'id == $0', [permission.id]).firstOrNull;
          if (exist == null) {
            final perm = LPermission(ObjectId(),
                id: permission.id, name: permission.name);
            permissionToAdd.add(perm);
          }
        }
        ProxyService.realm.realm!.write(() {
          ProxyService.realm.realm!.addAll<LPermission>(permissionToAdd);
        });

        Tenant? exist = ProxyService.realm.realm!
            .query<Tenant>(r'id == $0', [iTenant.id]).firstOrNull;
        if (exist == null) {
          if (user.id == iTenant.userId) {
            ProxyService.realm.realm!.write(() {
              iTenant.sessionActive = true;
              ProxyService.realm.realm!.add<Tenant>(iTenant);
            });
          } else {
            ProxyService.realm.realm!.write(() {
              ProxyService.realm.realm!.add<Tenant>(iTenant);
            });
          }
        }
      }
      // ProxyService.box.writeInt(key: 'businessId', value: user.tenants.first.businessId);

      return user;
    } else if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw ErrorReadingFromYBServer(term: "Not found");
    } else {
      log(response.body.toString(), name: "login error");
      throw Exception(response.body.toString());
    }
  }

  @override
  Future<List<Business>> businesses({int? userId}) async {
    List<Business> businesses = [];
    if (userId != null) {
      businesses =
          localRealm!.query<Business>(r'userId == $0 ', [userId]).toList();
    } else {
      throw Exception("userId is required");
    }

    return businesses;
  }

  @override
  Future<List<Branch>> branches({int? businessId}) async {
    if (businessId != null) {
      return localRealm!
          .query<Branch>(r'businessId == $0 ', [businessId]).toList();
    } else {
      throw Exception("BusinessId is required");
    }
  }

  @override
  Future<Business> getOnlineBusiness({required int userId}) async {
    final response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/businessUserId/$userId"));

    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    }
    if (response.statusCode == 404) {
      throw BusinessNotFoundException(term: "IBusiness not found");
    }

    Business? business = localRealm!.query<Business>(r'serverId == $0',
        [IBusiness.fromJson(json.decode(response.body)).id!]).firstOrNull;

    if (business == null) {
      localRealm!.write(() {
        localRealm!.add<Business>(Business(ObjectId(),
            serverId: IBusiness.fromJson(json.decode(response.body)).id,
            userId: IBusiness.fromJson(json.decode(response.body)).userId,
            name: IBusiness.fromJson(json.decode(response.body)).name,
            currency: IBusiness.fromJson(json.decode(response.body)).currency,
            categoryId:
                IBusiness.fromJson(json.decode(response.body)).categoryId,
            latitude: IBusiness.fromJson(json.decode(response.body)).latitude,
            longitude: IBusiness.fromJson(json.decode(response.body)).longitude,
            timeZone: IBusiness.fromJson(json.decode(response.body)).timeZone,
            country: IBusiness.fromJson(json.decode(response.body)).country,
            businessUrl:
                IBusiness.fromJson(json.decode(response.body)).businessUrl,
            hexColor: IBusiness.fromJson(json.decode(response.body)).hexColor,
            imageUrl: IBusiness.fromJson(json.decode(response.body)).imageUrl,
            type: IBusiness.fromJson(json.decode(response.body)).type,
            active: IBusiness.fromJson(json.decode(response.body)).active,
            chatUid: IBusiness.fromJson(json.decode(response.body)).chatUid,
            metadata: IBusiness.fromJson(json.decode(response.body)).metadata,
            role: IBusiness.fromJson(json.decode(response.body)).role,
            lastSeen: IBusiness.fromJson(json.decode(response.body)).lastSeen,
            firstName: IBusiness.fromJson(json.decode(response.body)).firstName,
            lastName: IBusiness.fromJson(json.decode(response.body)).lastName,
            createdAt: IBusiness.fromJson(json.decode(response.body)).createdAt,
            deviceToken:
                IBusiness.fromJson(json.decode(response.body)).deviceToken,
            backUpEnabled:
                IBusiness.fromJson(json.decode(response.body)).backUpEnabled,
            subscriptionPlan:
                IBusiness.fromJson(json.decode(response.body)).subscriptionPlan,
            nextBillingDate:
                IBusiness.fromJson(json.decode(response.body)).nextBillingDate,
            previousBillingDate: IBusiness.fromJson(json.decode(response.body))
                .previousBillingDate,
            isLastSubscriptionPaymentSucceeded:
                IBusiness.fromJson(json.decode(response.body))
                    .isLastSubscriptionPaymentSucceeded,
            backupFileId:
                IBusiness.fromJson(json.decode(response.body)).backupFileId,
            email: IBusiness.fromJson(json.decode(response.body)).email,
            lastDbBackup:
                IBusiness.fromJson(json.decode(response.body)).lastDbBackup,
            fullName: IBusiness.fromJson(json.decode(response.body)).fullName,
            tinNumber: IBusiness.fromJson(json.decode(response.body)).tinNumber,
            bhfId: IBusiness.fromJson(json.decode(response.body)).bhfId,
            dvcSrlNo: IBusiness.fromJson(json.decode(response.body)).dvcSrlNo,
            adrs: IBusiness.fromJson(json.decode(response.body)).adrs,
            taxEnabled:
                IBusiness.fromJson(json.decode(response.body)).taxEnabled,
            taxServerUrl:
                IBusiness.fromJson(json.decode(response.body)).taxServerUrl,
            isDefault: IBusiness.fromJson(json.decode(response.body)).isDefault,
            businessTypeId:
                IBusiness.fromJson(json.decode(response.body)).businessTypeId,
            lastTouched:
                IBusiness.fromJson(json.decode(response.body)).lastTouched,
            action: IBusiness.fromJson(json.decode(response.body)).action,
            deletedAt: IBusiness.fromJson(json.decode(response.body)).deletedAt,
            encryptionKey:
                IBusiness.fromJson(json.decode(response.body)).encryptionKey));
      });
    }
    business =
        localRealm!.query<Business>(r'userId == $0', [userId]).firstOrNull;
    ProxyService.box.writeInt(key: 'businessId', value: business!.serverId!);

    return business;
  }

  @override
  Future<List<ITenant>> signup({required Map business}) async {
    talker.info(business.toString());
    final http.Response response = await flipperHttpClient
        .post(Uri.parse("$apihub/v2/api/business"), body: jsonEncode(business));
    if (response.statusCode == 200) {
      /// because we want to close the inMemory realm db
      /// as soon as possible so I can be able to save real data into realm
      /// then I call login in here after signup as login handle configuring
      await login(
          userPhone: business['phoneNumber'], skipDefaultAppSetup: true);

      await configureLocal(useInMemory: false);
      await ProxyService.realm.configure(useInMemoryDb: false);
      final tenantToAdd = <Tenant>[];
      for (ITenant tenant in ITenant.fromJsonList(response.body)) {
        ITenant jTenant = tenant;

        Tenant iTenant = Tenant(ObjectId(),
            isDefault: jTenant.isDefault,
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        final businessToAdd = <Business>[];
        for (IBusiness business in jTenant.businesses) {
          Business biz = Business(ObjectId(),
              serverId: business.id,
              userId: business.userId,
              name: business.name,
              currency: business.currency,
              categoryId: business.categoryId,
              latitude: business.latitude,
              longitude: business.longitude,
              timeZone: business.timeZone,
              country: business.country,
              businessUrl: business.businessUrl,
              hexColor: business.hexColor,
              imageUrl: business.imageUrl,
              type: business.type,
              active: business.active,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
              createdAt: business.createdAt,
              deviceToken: business.deviceToken,
              backUpEnabled: business.backUpEnabled,
              subscriptionPlan: business.subscriptionPlan,
              nextBillingDate: business.nextBillingDate,
              previousBillingDate: business.previousBillingDate,
              isLastSubscriptionPaymentSucceeded:
                  business.isLastSubscriptionPaymentSucceeded,
              backupFileId: business.backupFileId,
              email: business.email,
              lastDbBackup: business.lastDbBackup,
              fullName: business.fullName,
              tinNumber: business.tinNumber,
              bhfId: business.bhfId,
              dvcSrlNo: business.dvcSrlNo,
              adrs: business.adrs,
              taxEnabled: business.taxEnabled,
              taxServerUrl: business.taxServerUrl,
              isDefault: business.isDefault,
              businessTypeId: business.businessTypeId,
              lastTouched: business.lastTouched,
              action: business.action,
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey);
          businessToAdd.add(biz);
        }
        localRealm!.write(() {
          localRealm!.addAll<Business>(businessToAdd);
        });
        final branchToAdd = <Branch>[];
        for (IBranch brannch in jTenant.branches) {
          Branch branch = Branch(ObjectId(),
              serverId: brannch.id,
              active: brannch.active,
              description: brannch.description,
              name: brannch.name,
              businessId: brannch.businessId,
              longitude: brannch.longitude,
              latitude: brannch.latitude,
              isDefault: brannch.isDefault,
              lastTouched: brannch.lastTouched,
              action: brannch.action,
              deletedAt: brannch.deletedAt);
          branchToAdd.add(branch);
        }
        localRealm!.write(() {
          localRealm!.addAll<Branch>(branchToAdd);
        });

        for (IPermission permission in jTenant.permissions) {
          ProxyService.realm.realm!.add<LPermission>(LPermission(ObjectId(),
              id: permission.id, name: permission.name));
        }

        ProxyService.realm.realm!.add(iTenant);
      }
      ProxyService.realm.realm!.write(() {
        ProxyService.realm.realm!.addAll<Tenant>(tenantToAdd);
      });
      return ITenant.fromJsonList(response.body);
    } else {
      talker.error(response.body.toString());
      throw InternalServerError(term: response.body.toString());
    }
  }

  @override
  Business getBusiness({int? businessId}) {
    if (businessId != null) {
      return localRealm!.query<Business>(r'serverId == $0', [businessId]).first;
    } else {
      ///FIXME: what will happen if a user has multiple business associated to him
      ///the code bellow suggest that the first in row will be returned which can be wrong.
      int? userId = ProxyService.box.getUserId();
      return localRealm!.query<Business>(r'userId == $0', [userId]).first;
    }
  }

  @override
  Future<Business> getBusinessFuture({int? businessId}) async {
    if (businessId != null) {
      return localRealm!.query<Business>(r'serverId == $0', [businessId]).first;
    } else {
      ///FIXME: what will happen if a user has multiple business associated to him
      ///the code bellow suggest that the first in row will be returned which can be wrong.
      int? userId = ProxyService.box.getUserId();
      return localRealm!.query<Business>(r'userId == $0', [userId]).first;
    }
  }

  @override
  Future<Business?> defaultBusiness() async {
    return localRealm!.query<Business>(r'isDefault == $0 ', [true]).firstOrNull;
  }

  @override
  Future<Branch?> defaultBranch() async {
    return localRealm!.query<Branch>(r'isDefault == $0 ', [true]).firstOrNull;
  }

  @override
  Future<Branch> activeBranch() async {
    return localRealm!.query<Branch>(r'isDefault == $0', [true]).first;
  }

  @override
  Future<Business?> activeBusinesses({required int userId}) async {
    // AND (active == $1 OR active == $2)
    return localRealm!.query<Business>(r'userId == $0 ', [userId]).firstOrNull;
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) async {
    final http.Response response = await flipperHttpClient
        .get(Uri.parse("$apihub/v2/api/tenant/$businessId"));
    if (response.statusCode == 200) {
      final tenantToAdd = <Tenant>[];
      for (ITenant tenant in ITenant.fromJsonList(response.body)) {
        ITenant jTenant = tenant;
        Tenant iTenant = Tenant(ObjectId(),
            isDefault: jTenant.isDefault,
            id: jTenant.id,
            name: jTenant.name,
            userId: jTenant.userId,
            businessId: jTenant.businessId,
            nfcEnabled: jTenant.nfcEnabled,
            email: jTenant.email,
            phoneNumber: jTenant.phoneNumber);

        for (IBusiness business in jTenant.businesses) {
          Business biz = Business(ObjectId(),
              serverId: business.id,
              userId: business.userId,
              name: business.name,
              currency: business.currency,
              categoryId: business.categoryId,
              latitude: business.latitude,
              longitude: business.longitude,
              timeZone: business.timeZone,
              country: business.country,
              businessUrl: business.businessUrl,
              hexColor: business.hexColor,
              imageUrl: business.imageUrl,
              type: business.type,
              active: business.active,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
              createdAt: business.createdAt,
              deviceToken: business.deviceToken,
              backUpEnabled: business.backUpEnabled,
              subscriptionPlan: business.subscriptionPlan,
              nextBillingDate: business.nextBillingDate,
              previousBillingDate: business.previousBillingDate,
              isLastSubscriptionPaymentSucceeded:
                  business.isLastSubscriptionPaymentSucceeded,
              backupFileId: business.backupFileId,
              email: business.email,
              lastDbBackup: business.lastDbBackup,
              fullName: business.fullName,
              tinNumber: business.tinNumber,
              bhfId: business.bhfId,
              dvcSrlNo: business.dvcSrlNo,
              adrs: business.adrs,
              taxEnabled: business.taxEnabled,
              taxServerUrl: business.taxServerUrl,
              isDefault: business.isDefault,
              businessTypeId: business.businessTypeId,
              lastTouched: business.lastTouched,
              action: business.action,
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey);
          Business? exist = localRealm!
              .query<Business>(r'serverId == $0', [business.id]).firstOrNull;
          if (exist == null) {
            localRealm!.add<Business>(biz);
          }
        }

        for (IBranch brannch in jTenant.branches) {
          Branch branch = Branch(ObjectId(),
              serverId: brannch.id,
              active: brannch.active,
              description: brannch.description,
              name: brannch.name,
              businessId: brannch.businessId,
              longitude: brannch.longitude,
              latitude: brannch.latitude,
              isDefault: brannch.isDefault,
              lastTouched: brannch.lastTouched,
              action: brannch.action,
              deletedAt: brannch.deletedAt);
          Branch? exist = localRealm!
              .query<Branch>(r'serverId == $0', [brannch.id]).firstOrNull;
          if (exist == null) {
            localRealm!.write(() => localRealm!.add<Branch>(branch));
          }
        }

        final permissionToAdd = <LPermission>[];
        for (IPermission permission in jTenant.permissions) {
          LPermission? exist = ProxyService.realm.realm!
              .query<LPermission>(r'id == $0', [permission.id]).firstOrNull;
          if (exist == null) {
            final perm = LPermission(ObjectId(),
                id: permission.id, name: permission.name);
            permissionToAdd.add(perm);
          }
        }

        ProxyService.realm.realm!.write(() {
          ProxyService.realm.realm!.addAll<LPermission>(permissionToAdd);
        });

        tenantToAdd.add(iTenant);
      }
      ProxyService.realm.realm!.write(() {
        ProxyService.realm.realm!.addAll<Tenant>(tenantToAdd);
      });
      return ITenant.fromJsonList(response.body);
    }
    throw InternalServerException(term: "we got unexpected response");
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId({required int id}) async {
    Business? business =
        localRealm!.query<Business>(r'serverId == $0', [id]).firstOrNull;

    if (business != null) return business;
    final http.Response response =
        await flipperHttpClient.get(Uri.parse("$apihub/v2/api/business/$id"));
    if (response.statusCode == 200) {
      int id = randomNumber();
      IBusiness iBusiness = IBusiness.fromJson(json.decode(response.body));
      Business business = Business(ObjectId(),
          serverId: iBusiness.id,
          name: iBusiness.name,
          userId: iBusiness.userId,
          createdAt: DateTime.now().toIso8601String());

      business.serverId = id;
      localRealm!.write(() {
        localRealm!.add<Business>(business);
      });
      return business;
    }
    return null;
  }

  @override
  Future<List<Business>> getContacts() async {
    return localRealm!.query<Business>(
        r'userId == $0', [ProxyService.box.getUserId()]).toList();
  }

  @override
  Future<Tenant> saveTenant(String phoneNumber, String name,
      {required Business business,
      required Branch branch,
      required String userType}) async {
    final http.Response response =
        await flipperHttpClient.post(Uri.parse("$apihub/v2/api/tenant"),
            body: jsonEncode({
              "phoneNumber": phoneNumber,
              "name": name,
              "businessId": business.id,
              "permissions": [
                {"name": userType.toLowerCase()}
              ],
              "businesses": [business.toEJson()],
              "branches": [branch.toEJson()]
            }));
    if (response.statusCode == 200) {
      ITenant jTenant = ITenant.fromRawJson(response.body);
      ITenant iTenant = ITenant(
          businesses: jTenant.businesses,
          branches: jTenant.branches,
          isDefault: jTenant.isDefault,
          id: randomNumber(),
          permissions: jTenant.permissions,
          name: jTenant.name,
          businessId: jTenant.businessId,
          email: jTenant.email,
          userId: jTenant.userId,
          nfcEnabled: jTenant.nfcEnabled,
          phoneNumber: jTenant.phoneNumber);
      final branchToAdd = <Branch>[];
      final permissionToAdd = <LPermission>[];
      final businessToAdd = <Business>[];

      for (var business in jTenant.businesses) {
        Business? existingBusiness = localRealm!
            .query<Business>(r'serverId == $0', [business.id]).firstOrNull;
        if (existingBusiness == null) {
          businessToAdd.add(Business(ObjectId(),
              serverId: business.id,
              userId: business.userId,
              name: business.name,
              currency: business.currency,
              categoryId: business.categoryId,
              latitude: business.latitude,
              longitude: business.longitude,
              timeZone: business.timeZone,
              country: business.country,
              businessUrl: business.businessUrl,
              hexColor: business.hexColor,
              imageUrl: business.imageUrl,
              type: business.type,
              active: business.active,
              chatUid: business.chatUid,
              metadata: business.metadata,
              role: business.role,
              lastSeen: business.lastSeen,
              firstName: business.firstName,
              lastName: business.lastName,
              createdAt: business.createdAt,
              deviceToken: business.deviceToken,
              backUpEnabled: business.backUpEnabled,
              subscriptionPlan: business.subscriptionPlan,
              nextBillingDate: business.nextBillingDate,
              previousBillingDate: business.previousBillingDate,
              isLastSubscriptionPaymentSucceeded:
                  business.isLastSubscriptionPaymentSucceeded,
              backupFileId: business.backupFileId,
              email: business.email,
              lastDbBackup: business.lastDbBackup,
              fullName: business.fullName,
              tinNumber: business.tinNumber,
              bhfId: business.bhfId,
              dvcSrlNo: business.dvcSrlNo,
              adrs: business.adrs,
              taxEnabled: business.taxEnabled,
              taxServerUrl: business.taxServerUrl,
              isDefault: business.isDefault,
              businessTypeId: business.businessTypeId,
              lastTouched: business.lastTouched,
              action: business.action,
              deletedAt: business.deletedAt,
              encryptionKey: business.encryptionKey));
        }
      }

      for (var branch in jTenant.branches) {
        // Check if the branch with the same ID already exists
        // var existingBranch =
        //     await isar.iBranchs.filter().idEqualTo(branch.id).findFirst();
        final existingBranch =
            realm!.query<Branch>(r'serverId==$0', [branch.id]).firstOrNull;
        if (existingBranch == null) {
          Branch br = Branch(ObjectId(),
              serverId: branch.id,
              name: branch.name,
              businessId: branch.businessId,
              action: branch.action,
              active: branch.active,
              lastTouched: branch.lastTouched,
              latitude: branch.latitude,
              longitude: branch.longitude);
          branchToAdd.add(br);
        }
      }

      for (var permission in jTenant.permissions) {
        LPermission? existingPermission = ProxyService.realm.realm!
            .query<LPermission>(r'id == $0', [permission.id]).firstOrNull;
        if (existingPermission == null) {
          // Permission doesn't exist, add it
          permissionToAdd.add(LPermission(ObjectId(),
              name: permission.name,
              id: permission.id,
              userId: permission.userId));
        }
      }

      Tenant? tenantToAdd;
      Tenant? tenant = ProxyService.realm.realm!
          .query<Tenant>(r'id==$0', [iTenant.id]).firstOrNull;
      if (tenant == null) {
        tenantToAdd = Tenant(ObjectId(),
            name: jTenant.name,
            phoneNumber: jTenant.phoneNumber,
            email: jTenant.email,
            nfcEnabled: jTenant.nfcEnabled,
            businessId: jTenant.businessId,
            userId: jTenant.userId,
            isDefault: jTenant.isDefault,
            pin: jTenant.pin);
        ProxyService.realm.realm!.add<Tenant>(tenantToAdd);
      }

      localRealm!.write(() {
        localRealm!.addAll<Business>(businessToAdd);
        localRealm!.addAll<Branch>(branchToAdd);
        ProxyService.realm.realm!.addAll<LPermission>(permissionToAdd);
      });

      return tenantToAdd!;
    } else {
      throw InternalServerError(term: "internal server error");
    }
  }
}
