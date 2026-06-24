#!/usr/bin/env bash
# Downloads Outfit + JetBrains Mono TTFs from fonts.gstatic.com using the same
# file hashes as package:google_fonts (v6.3.x). Output names must match
# GoogleFontsFamilyWithVariant.toApiFilenamePrefix() + ".ttf".
set -euo pipefail
DEST="$(cd "$(dirname "$0")/.." && pwd)/google_fonts"
BASE="https://fonts.gstatic.com/s/a"
mkdir -p "$DEST"

download() {
  local hash="$1"
  local name="$2"
  local out="$DEST/${name}.ttf"
  echo "Fetching $name..."
  curl -fsSL "$BASE/$hash.ttf" -o "$out"
  test -s "$out"
}

# --- Outfit (normal weights w100–w900; hashes from google_fonts part_o.g.dart) ---
download 7862cd4b53431575b32ae6509a15cb714d274bde8088481d858a1795cd7b7c0e Outfit-Thin
download ffb3337923f8f928ad02b0ed5170bc6d3f57595453b0e8fd2d822552c06fd9eb Outfit-ExtraLight
download d50dc4a5ec5b238e67bd0ca121356315cec4f7bceaebb9cc68b3c7b88be34427 Outfit-Light
download b667551a8e7d406c089cb2fdf754f2fddfb1dc256a33fcc06c690965c6b9d5d7 Outfit-Regular
download 593c02128a0077461e58f5c86a2432a3894ad365c8302f13120fc17b2c4aad88 Outfit-Medium
download 3b9c6753e282f674c8acfa64c24eba2057c1c123830595cba4e3adbf8c5e9f24 Outfit-SemiBold
download 8d3a851bbdbcef9f4e7bbee2ffdb74271a80d745c40dbb68888e5759d5976477 Outfit-Bold
download 95f91a67031e82a8ddcdbac44fcf4fff74e58f1e017f1759f90087390922f14a Outfit-ExtraBold
download f1d36e271d33f7c75eca8ea0c0192635ae255c4b0d39fb5a49779f42a53bcdb7 Outfit-Black

# --- JetBrains Mono (normal + italic w100–w800; part_j.g.dart) ---
download 9a44b1b4adc03c445877e325d57d0879cb22840ff640a40e6515be59c845b015 JetBrainsMono-Thin
download 9133ef0d504f0d80e5478902ee49e8f815ade6f5621fc89c5d6b9263549325d7 JetBrainsMono-ExtraLight
download 0623d0562debca9e5d97996af1de5e98f672a20f2ee6085cec86cd6a77ec3595 JetBrainsMono-Light
download fc34426314d00825ccc768a0c4b1178fe704f04bd947882ef10c2b71b7e355e7 JetBrainsMono-Regular
download ba10286722bd7dc2274b817575046e39ee816d6ba1e2ace48e22bcd068576941 JetBrainsMono-Medium
download f833596d98e0e021dd43d993254658d0f32318f82f08afee0fc2e41c16ce9571 JetBrainsMono-SemiBold
download b43a7dfebfb8816fb3859f6a7932824f594e115538ccd3f1ebc0ffc231b0acab JetBrainsMono-Bold
download 98ea78a2337e1ef2274f247c857a63e40e975c6907a7baff9209033fa42142ac JetBrainsMono-ExtraBold

download 0ad56d15852c41931b3640756ff18d55178c649d5fb55daf346a6831918c2c49 JetBrainsMono-ThinItalic
download 446787ed370004cd92c5043b5710c0fe7222eea7b1cce8d6a0d48008e8d4fa9b JetBrainsMono-ExtraLightItalic
download 9002d02f91013aaf6ee54f0d03bde3e7d114597f49401b022c948ed5c4229702 JetBrainsMono-LightItalic
download 93f2f2d90bcd64e35bf1b7bd90149b168df727499667b5d2fde1758ed0297da5 JetBrainsMono-Italic
download d33f9b81805d2984778b134e68b0a7f242a2d10a81fa5299b8c5081f3f7f0e83 JetBrainsMono-MediumItalic
download 93aae81b1f8697f683ae32b65bacb4d74679d7a6a69357fbe45858aaa05db9b4 JetBrainsMono-SemiBoldItalic
download a89a53b6ccccdfd6431441572e542901c7620e55d91f10d0eaa3fd39adaa3b83 JetBrainsMono-BoldItalic
download 013382b52ceb65565ac0ecf7dbaaf9369d29f4d4d3a8763439e3eb77c2b1009b JetBrainsMono-ExtraBoldItalic

echo "Done. Fonts in: $DEST"
ls -la "$DEST"/*.ttf | wc -l
