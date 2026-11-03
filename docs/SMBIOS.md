# SMBIOS — you must generate your own

The `config.plist` in this repo has **placeholders** in `PlatformInfo → Generic`:

```
SystemSerialNumber = CHANGEME
MLB                = CHANGEME
SystemUUID         = 00000000-0000-0000-0000-000000000000
ROM                = 000000000000
SystemProductName  = MacBookPro16,2
```

Do **not** reuse someone else's values. Each Hackintosh needs its own unique set.

## How

1. Use **GenSMBIOS** ([corpnewt/GenSMBIOS](https://github.com/corpnewt/GenSMBIOS)) or OpenCore's `macserial` utility.
2. Generate for the model **`MacBookPro16,2`** (the model this EFI uses and boots with).
3. Copy the results into:
   - `SystemSerialNumber` ← Serial
   - `MLB` ← Board Serial
   - `SystemUUID` ← SmUUID
   - `ROM` ← your Ethernet adapter's MAC address (as 6 bytes), or any 6 random bytes.
4. Check that the serial is *not* already in use: Apple's coverage page should report an invalid serial or "purchase date not validated".

If you plan to use iMessage / FaceTime / iCloud, follow a current guide for iServices on OpenCore; that is outside the scope of this repo.
