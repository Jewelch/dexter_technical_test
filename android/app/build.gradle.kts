import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Read config.properties
val configProperties = Properties()
val configPropertiesFile = rootProject.file("config.properties")
if (configPropertiesFile.exists()) {
    configProperties.load(FileInputStream(configPropertiesFile))
}

// Read local.properties
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
}

// Extract properties
val flutterApplicationId: String = configProperties.getProperty("flutter.applicationId") 
    ?: throw GradleException("flutter.applicationId must be defined in config.properties")
val flutterMinSdkVersion: Int = configProperties.getProperty("flutter.minSdkVersion")?.toInt()
    ?: throw GradleException("flutter.minSdkVersion must be defined in config.properties")
val flutterTargetSdkVersion: Int = configProperties.getProperty("flutter.targetSdkVersion")?.toInt()
    ?: throw GradleException("flutter.targetSdkVersion must be defined in config.properties")
val flutterCompileSdkVersion: Int = configProperties.getProperty("flutter.compileSdkVersion")?.toInt()
    ?: throw GradleException("flutter.compileSdkVersion must be defined in config.properties")
val flutterNdkVersion: String = configProperties.getProperty("flutter.ndkVersion")
    ?: throw GradleException("flutter.ndkVersion must be defined in config.properties")

val jksKeyAlias = configProperties.getProperty("jks.keyAlias")
val jksKeyPassword = configProperties.getProperty("jks.keyPassword")
val jksStoreFile = configProperties.getProperty("jks.storeFile")
val jksStorePassword = configProperties.getProperty("jks.storePassword")

val flutterVersionName: String = localProperties.getProperty("flutter.versionName")
    ?: throw GradleException("flutter.versionName must be defined in local.properties")
val flutterVersionCode: Int = localProperties.getProperty("flutter.versionCode")?.toInt()
    ?: throw GradleException("flutter.versionCode must be defined in local.properties")

android {
    namespace = flutterApplicationId
    compileSdk = flutterCompileSdkVersion
    ndkVersion = flutterNdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = flutterApplicationId
        minSdk = flutterMinSdkVersion
        targetSdk = flutterTargetSdkVersion
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    signingConfigs {
        create("release") {
            keyAlias = jksKeyAlias
            keyPassword = jksKeyPassword
            storeFile = jksStoreFile?.let { project.file(it) }
            storePassword = jksStorePassword
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
