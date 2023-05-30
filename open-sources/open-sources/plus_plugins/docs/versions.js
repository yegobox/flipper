export default {
  // Plugin versions are sourced from the public pub.dev API
  // See website/plugins/source-versions.js for more information on how these are sourced & injected via Webpack
  plugins: {
    battery_plus: PUB_BATTERY_PLUS,
    connectivity_plus: PUB_CONNECTIVITY_PLUS,
    device_info_plus: PUB_DEVICE_INFO_PLUS,
    network_info_plus: PUB_NETWORK_INFO_PLUS,
    package_info_plus: PUB_PACKAGE_INFO_PLUS,
    sensors_plus: PUB_SENSORS_PLUS,
    share_plus: PUB_SHARE_PLUS,
    android_alarm_manager_plus: PUB_ANDROID_ALARM_MANAGER_PLUS,
    android_intent_plus: PUB_ANDROID_INTENT_PLUS,
  }, // other stuff
};
