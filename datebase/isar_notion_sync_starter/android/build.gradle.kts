import com.android.build.api.dsl.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// Inject namespace for third-party libraries that miss it (AGP 8+ requirement)
subprojects {
    pluginManager.withPlugin("com.android.library") {
        extensions.configure<LibraryExtension> {
            compileSdk = 36
            buildToolsVersion = "36.0.0"
            if (name == "isar_flutter_libs" || group.toString() == "dev.isar.isar_flutter_libs") {
                if (namespace.isNullOrBlank()) {
                    namespace = "dev.isar.isar_flutter_libs"
                }
            }
        }
    }
    if (name == "isar_flutter_libs" || group.toString() == "dev.isar.isar_flutter_libs") {
        // Remove deprecated manifest package attribute to satisfy AGP 8+
        afterEvaluate {
            val manifestFile = file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                val original = manifestFile.readText()
                val updated = original.replace(Regex("\\s*package=\"[^\"]+\""), "")
                if (original != updated) {
                    manifestFile.writeText(updated)
                }
            }
        }
    }
}
