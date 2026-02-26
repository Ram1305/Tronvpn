# iOS VPN Setup Instructions

To enable VPN on iOS, you must add a Network Extension target and configure capabilities. **Test on a physical iOS device** (VPN does not work in the simulator).

## Step 1: Create VPNExtension Target in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode (not the .xcodeproj).
2. **File → New → Target**
3. Select **iOS → Network Extension → Packet Tunnel Provider**
4. Click **Next**
5. Product Name: **VPNExtension**
6. Team: Select your development team
7. Bundle Identifier: **com.yencodetech.vpn.VPNExtension**
8. Click **Finish**
9. If asked "Activate VPNExtension scheme?", click **Cancel**

## Step 2: Replace PacketTunnelProvider.swift

1. In Xcode, open **VPNExtension/PacketTunnelProvider.swift** (the file created by the template)
2. Replace its entire contents with the contents of `ios/VPNExtension/PacketTunnelProvider.swift` from this project

## Step 3: Add Capabilities

### Runner target
1. Select the **Runner** target
2. Open the **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **App Groups** → Add group: `group.com.yencodetech.vpn`
5. Add **Network Extensions**

### VPNExtension target
1. Select the **VPNExtension** target
2. Open **Signing & Capabilities**
3. Add **App Groups** → Add the same: `group.com.yencodetech.vpn`
4. Add **Network Extensions** (if not already present)

## Step 4: Install Pods

```bash
cd ios
pod install
cd ..
```

## Step 5: Apple Developer Account

- **Network Extensions** requires an Apple Developer Program membership.
- You may need to enable the "Personal VPN" entitlement in your Apple Developer account.

## Step 6: Build and Run

```bash
flutter run
```

Or build from Xcode onto a connected iOS device.
