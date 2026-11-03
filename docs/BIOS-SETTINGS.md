# BIOS settings (FX506LI, BIOS `FX506LI.310`)

Open the BIOS with **F2** at power-on (press **F7** for Advanced Mode if it opens in EZ Mode). Write down the original values first.

| Setting | Value |
|---|---|
| Secure Boot | **Disabled** |
| Fast Boot | **Disabled** |
| VT-d / Intel Virtualization for Directed I/O | **Disabled** (if the option is present) |
| SATA mode | AHCI (if you get a choice) |
| Boot order | leave Windows first; use **Esc** for the one-time boot menu |

Notes:

- We did not change **CFG Lock**. The config sets `AppleCpuPmCfgLock` and `AppleXcpmCfgLock` to `True`, so it does not depend on the lock being off.
- `DisableIoMapper` is set to `True` in the config (the Wi-Fi driver does not support DMA remapping).
- BitLocker: if Windows uses BitLocker/Device Encryption, **suspend it or have your recovery key ready** before changing Secure Boot.
