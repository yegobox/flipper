import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

// Release signing comes from CI secrets (or a local, gitignored
// keystore.properties). The key must stay the same for the life of the app:
// Android refuses an update signed with a different key, and the package is
// registered with it for developer verification.
val keystoreProps = Properties().apply {
    val f = rootProject.file("keystore.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}
fun signingValue(key: String, env: String): String? =
    keystoreProps.getProperty(key) ?: System.getenv(env)

android {
    namespace = "rw.flipper.smsbridge"
    compileSdk = 36

    defaultConfig {
        applicationId = "rw.flipper.smsbridge"
        minSdk = 26 // same as Flipper; adaptive icon needs no fallback
        targetSdk = 36
        versionCode = (System.getenv("SMS_BRIDGE_VERSION_CODE") ?: "1").toInt()
        versionName = System.getenv("SMS_BRIDGE_VERSION_NAME") ?: "1.0.0"
    }

    signingConfigs {
        create("release") {
            val store = signingValue("storeFile", "SMS_BRIDGE_KEYSTORE_PATH")
            if (store != null) {
                storeFile = file(store)
                storePassword = signingValue("storePassword", "SMS_BRIDGE_KEYSTORE_PASSWORD")
                keyAlias = signingValue("keyAlias", "SMS_BRIDGE_KEY_ALIAS")
                keyPassword = signingValue("keyPassword", "SMS_BRIDGE_KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            val release = signingConfigs.getByName("release")
            if (release.storeFile != null) signingConfig = release
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    buildFeatures {
        viewBinding = true
        buildConfig = true
    }
}

kotlin {
    jvmToolchain(17)
}

dependencies {
    implementation(project(":core"))
    implementation("androidx.appcompat:appcompat:1.7.1")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.9.2")
    implementation("androidx.work:work-runtime-ktx:2.10.3")
    implementation("com.journeyapps:zxing-android-embedded:4.3.0")
}
