import com.android.build.gradle.internal.api.ApkVariantOutputImpl

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "org.tutorlanguage.app"
    compileSdk = 36
    buildToolsVersion = "36.1.0"
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "org.tutorlanguage.app"
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // BUILD and SIGN are deliberately separate. Gradle produces the
            // reproducible unsigned artifact; tool/release/sign_apk.sh applies
            // the permanent developer signature outside the source build.
            // F-Droid never receives or needs the private signing key.
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

// Per-ABI version codes for F-Droid's ABI split.
//
// F-Droid requires the ABI digit in the lowest position, ordered
// armeabi-v7a < arm64-v8a < x86_64, so that every code of a new release
// outranks every code of the previous one.
//
// The legacy variant API is used deliberately. Two alternatives were measured
// and do not work here: `androidComponents.onVariants` is overridden by
// Flutter's own `abiVersionCode * 1000 + versionCode` composition (produced
// versionCode 1031 instead of 31), and assigning from `afterEvaluate` fails
// with "The value for this property cannot be changed any further" because the
// property is already finalized.
//
// After changing anything here, verify every built APK:
//   aapt2 dump badging <apk> | grep versionCode
val abiCodes = mapOf("armeabi-v7a" to 1, "arm64-v8a" to 2, "x86_64" to 3)

android.applicationVariants.configureEach {
    val variant = this
    variant.outputs.forEach { output ->
        val abiVersionCode = abiCodes[output.filters.find { it.filterType == "ABI" }?.identifier]
        if (abiVersionCode != null) {
            (output as ApkVariantOutputImpl).versionCodeOverride =
                variant.versionCode * 10 + abiVersionCode
        }
    }
}
