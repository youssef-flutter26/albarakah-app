plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.albarakah.perfumeapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.albarakah.perfumeapp"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = "upload"
            keyPassword = "kk6907291177kk"
            storeFile = file("upload-keystore.jks")
            storePassword = "kk6907291177kk"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // تم إضافة السطور دي عشان نمنع تقليص الكود اللي بيعمل مشاكل مع الـ Models والـ Casting
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}