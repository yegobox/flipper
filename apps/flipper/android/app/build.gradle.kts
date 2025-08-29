import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "rw.flipper"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    sourceSets["main"].java.srcDirs("src/main/kotlin")

    defaultConfig {
        applicationId = "rw.flipper"
        minSdk = 26
        targetSdk = 36
        multiDexEnabled = true
        vectorDrawables.useSupportLibrary = true

        manifestPlaceholders.put(
            "POSTHOG_API_KEY",
            if (project.hasProperty("POSTHOG_API_KEY")) {
                project.property("POSTHOG_API_KEY") as String
            } else {
                ""
            }
        )

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }


    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

   buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true // must be true if shrinkResources is used
            isShrinkResources = true // only if you want resource shrinking
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }

        debug {
            // Usually keep shrinking off in debug
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }


    packagingOptions {
        resources {
            excludes += setOf("/META-INF/{AL2.0,LGPL2.1}")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.gms:play-services-base:18.7.0")
    implementation("com.google.android.gms:play-services-auth:21.3.0")

    implementation(platform("com.google.firebase:firebase-bom:33.13.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-firestore")
    // implementation("com.google.firebase:firebase-auth-ktx")

    androidTestUtil("androidx.test:orchestrator:1.5.1")

    // AndroidX
    implementation("androidx.window:window:1.3.0")
    implementation("androidx.window:window-java:1.3.0")

    // Desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // Smart POS
    implementation(files("libs/SmartPos_1.9.4_R250117.jar"))

    // QR/Barcode
    // implementation("com.journeyapps:zxing-android-embedded:4.3.0")
}
