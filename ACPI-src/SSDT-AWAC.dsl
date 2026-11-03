DefinitionBlock ("", "SSDT", 2, "HKINTO", "AWAC", 0x00000000)
{
    External (STAS, FieldUnitObj)

    Scope (\)
    {
        Method (_INI, 0, NotSerialized)
        {
            If (_OSI ("Darwin"))
            {
                STAS = One
            }
        }
    }
}
