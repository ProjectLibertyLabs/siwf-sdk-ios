//
//  README.md
//  SiwfApp
//
//  Created by Claire Olmstead on 3/17/25.
//

# **Sign-In With Frequency (SIWF) SDK For iOS**

🚀 **[Sign-In With Frequency (SIWF)](https://github.com/ProjectLibertyLabs/siwf)** is an authentication SDK designed for seamless integration with mobile apps.

This repository contains the local SIWF SDK and Demo App, for seamless spinup and as a reference for how to use the SIWF SDK in your app.

## 📌 **Index**
1. 🚀 [Getting Started - SIWF SDK Demo App](#getting-started---siwf-sdk-demo-app)
2. 📝 [Getting Started - SIWF SDK For Your App](#getting-started---siwf-sdk-for-your-app)
3. 🛠 [Usage For Your App](#usage-for-your-app)
4. 🤝 [Contributing](#contributing)
5. 📦 [Release](#📦-release)

## 🚀 **Getting Started - SIWF SDK Demo App**

Follow these steps to set up and run the Swift app:

### 1️⃣ Install XCode
If you haven't already, download and install [XCode](https://apps.apple.com/us/app/xcode/id497799835?mt=12) to set up your development environment.

### 2️⃣ Clone the Repository
Run the following command in your terminal to clone the repository:
```sh
git clone git@github.com:ProjectLibertyLabs/siwf-sdk-ios.git
cd siwf-sdk-ios/siwf-app
```

### 3️⃣ Open the Project in XCode
Open the `siwf-app`. You should see a package dependency titled `Siwf`. If not, add `siwf-sdk-ios/siwf-sdk` as a local dependency.

### 4️⃣ Run the App
- Click **▶** in XCode to run the simulator. It may take a moment to load.

Your SIWF SDK Demo App should now be running! 🚀

## 📝 **Getting Started - SIWF SDK For Your App**

### ⚙️ Requirements
iOS 15.0 or later, macOS 11.0 or later, and Swift

## 🛠 **Usage For Your App**
When you decide to use the SIWF SDK in your own app, follow the steps below for easy integration:

### **1️⃣ Define an `authRequest`**
- Refer to the Demo App for examples of encoded and non-encoded requests.
- To create your own, use [Frequency's Signed Request Generator](https://projectlibertylabs.github.io/siwf/v2/docs/Generate.html).

### **2️⃣ Display the SIWF Sign-In Button**
Use `Siwf.createSignInButton` to create a SIWF Button in your UI:

```swift
    import Siwf

    Siwf.createSignInButton(mode: .dark, authRequest: authRequest)
```

### **3️⃣ Handle Authorization Callbacks**

`OnOpenURL`, use `Siwf.handleRedirectUrl()` to listen for the deep link(`siwfdemoapp://login`) and handle the authorization callback.

```swift
    var body: some Scene {
    WindowGroup {
        NavigationView {
            ContentView() //Renders the SIWF Button
                .navigationTitle("SIWF Demo App")
        }
        .onOpenURL { url in
            guard let redirectUrl = URL(string: "siwfdemoapp://login") else {
                print("❌ Error: Invalid redirect URL.")
                return
            }

            Siwf.handleRedirectUrl(
                incomingUrl: url,
                redirectUrl: redirectUrl,
                processAuthorization: { code in
                    print("✅ Successfully extracted authorization code: \(code)")
                    authorizationCode = code
                    showAlert = true
                }
            )
        }
    }
}
```

## 🤝 **Contributing**
To contribute:
- Fork the repo and create a feature branch.
- Make changes and test.
- Submit a pull request with details.

## 📦 **Release**

Use GitHub to create a release.
That will trigger CI to do the release and update with [jreleaser](https://jreleaser.org/guide/latest/tools/jreleaser-gradle.html).

### Example Release Steps

1. Set the environment variable: `RELEASE_VERSION` to `x.y.z` or `x.y.z-SNAPSHOT`
2. Show config: `RELEASE_VERSION="1.0.0" ./gradlew siwf:jreleaserConfig --dryrun --full`
3. Staging build `RELEASE_VERSION="1.0.0" ./gradlew siwf:publishReleasePublicationToPreDeployRepository`
4. Dry run `RELEASE_VERSION="1.0.0" ./gradlew siwf:jreleaserFullRelease --dryrun`
5. Full `RELEASE_VERSION="1.0.0" ./gradlew siwf:jreleaserFullRelease --dryrun`

### Release Secrets
Can be set in `/siwf/.env`
```
# Release Username for Maven Central / SonaType
JRELEASER_MAVENCENTRAL_SONATYPE_USERNAME=<replace>
# Release Token for Maven Central / SonaType
JRELEASER_MAVENCENTRAL_SONATYPE_TOKEN=<replace>

# Release GitHub Token with Permissions
JRELEASER_GITHUB_TOKEN=<replace>

# Release Signing GPG Passphrase
JRELEASER_GPG_PASSPHRASE=<replace>
# Release Signing GPG Public Key (base64 encoded)
```

### GPG Signing Key Rotation

1. Generate new key
2. Export key and commit `gpg --armor --export <KEY ID> > ./siwf/signing-public-key.asc`
3. Update GitHub Actions Secret `GPG_SECRET_KEY_BASE64` with the Secret Key `gpg --armor --export-secret-key <KEY ID> | base64 -w 0`
4. Update the GPG Passphrase GitHub Actions Secret: `JRELEASER_GPG_PASSPHRASE`
