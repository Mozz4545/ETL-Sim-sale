allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Ensure compileSdkVersion and targetSdkVersion are up-to-date
subprojects {
    afterEvaluate {
        if (project.hasProperty("android")) {
            project.extensions.getByName("android").apply {
                this as com.android.build.gradle.BaseExtension
                compileSdkVersion(33)
                defaultConfig {
                    targetSdkVersion(33)
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
