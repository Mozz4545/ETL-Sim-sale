plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.etl_simstore_final"
    compileSdk = 35  // เปลี่ยนจาก flutter.compileSdkVersion เป็น 35

    // เปลี่ยน NDK version เป็นตัวที่ plugins ต้องการ
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.etl_simstore_final"
        minSdk = flutter.minSdkVersion
        targetSdk = 35  // เปลี่ยนจาก flutter.targetSdkVersion เป็น 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}