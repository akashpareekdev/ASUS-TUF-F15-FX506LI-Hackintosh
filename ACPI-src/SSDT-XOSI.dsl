DefinitionBlock ("", "SSDT", 2, "HKINTO", "XOSI", 0x00000000)
{
    Method (XOSI, 1, NotSerialized)
    {
        // Report the Windows versions this firmware needs for I2C touchpad and power features
        Local0 = Package ()
        {
            "Windows 2001",
            "Windows 2006",
            "Windows 2009",
            "Windows 2012",
            "Windows 2013",
            "Windows 2015"
        }

        If (_OSI ("Darwin"))
        {
            Return ((Ones != Match (Local0, MEQ, Arg0, MTR, Zero, Zero)))
        }
        Else
        {
            Return (_OSI (Arg0))
        }
    }
}
