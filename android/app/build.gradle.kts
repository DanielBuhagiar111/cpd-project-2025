plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // Correct Kotlin plugin ID
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.pets_tracker"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true // Enable desugaring
        sourceCompatibility = JavaVersion.VERSION_1_8 // Use Java 8 compatibility
        targetCompatibility = JavaVersion.VERSION_1_8 // Use Java 8 compatibility
    }

    kotlinOptions {
        jvmTarget = "1.8" // Use Java 8 target
    }

    defaultConfig {
        applicationId = "com.example.pets_tracker"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    dependencies {
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.2") // Add desugaring dependency
    }
}

flutter {
    source = "../.."
}