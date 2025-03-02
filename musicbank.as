namespace MusicBank
{
    dictionary dicBank = {};
    void Add(CTJA@ pTJA)
    {
        if(dicBank.exists(pTJA.GetMeta("WAVE")))
            cast<array<CTJA@>@>(dicBank[pTJA.GetMeta("WAVE")]).insertLast(@pTJA);
        else
            dicBank.set(pTJA.GetMeta("WAVE"), array<CTJA@> = {@pTJA});
    }

    array<CTJA@>@ Get(string szWave)
    {
        if(dicBank.exists(szWave))
            return cast<array<CTJA@>@>(dicBank[szWave]);
        return null;
    }

    uint GetMusicLength()
    {
        return dicBank.getKeys().length();
    }

    uint GetLevelLength(uint i)
    {
        array<string>@ aryKeys = dicBank.getKeys();
        return cast<array<CTJA@>@>(dicBank[aryKeys[i]]).length();
    }

    CTJA@ GetTJA(uint i, uint j)
    {
        return cast<array<CTJA@>@>(dicBank[dicBank.getKeys()[i]])[j];
    }

    CTJA@ GetTJA(string szName, array<CTJA@>@ aryTemp)
    {
        for(uint i = 0; i < aryTemp.length(); i++)
        {
            if(aryTemp[i].GetMeta("TITLE") == szName)
                return aryTemp[i];
        }
        return null;
    }

    void Precache()
    {
        array<string>@ aryKeys = dicBank.getKeys();
        for(uint i = 0; i < aryKeys.length(); i++)
        {
            array<CTJA@>@ aryTemp = cast<array<CTJA@>@>(dicBank[aryKeys[i]]);
            for(uint j = 0; j < aryTemp.length(); j++)
            {
                aryTemp[j].Precache();
            }
        }
    }
}