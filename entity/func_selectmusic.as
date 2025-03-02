class CSelectMusic : ScriptBaseEntity
{
    private float flTime = 0.0f;
    private bool bIsLevel = false;
    private bool bIsPlay = false;
    private bool bIsDemo = false;
	void Spawn()
	{
		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;
		
		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );
		
		SetUse( UseFunction( this.Use ) );
	}

    bool KeyValue(const string& in szKeyName, const string& in szValue)
    {
        if(szKeyName == "level" && szValue == "1")
        {
            bIsLevel = true;
            return true;
        } 
        else if(szKeyName == "play" && szValue == "1")
        {
            bIsPlay = true;
            return true;
        } 
        else if(szKeyName == "demo" && szValue == "1")
        {
            bIsDemo = true;
            return true;
        } 
        return BaseClass.KeyValue(szKeyName, szValue);
    }

    int ObjectCaps()
    {
        return FCAP_IMPULSE_USE;
    }

	void Use( CBaseEntity@ pActivator, CBaseEntity@ pCaller, USE_TYPE useType, float value )
	{
        if(g_Engine.time - flTime < 3.0f)
            return;
        flTime = g_Engine.time;

        if(bIsDemo && eCheck.IsValid())
        {
            if(eCheck.GetEntity().pev.solid != SOLID_BSP)
            {
                eCheck.GetEntity().pev.solid = SOLID_BSP;
                g_PlayerFuncs.ShowMessageAll("DEMO On");
            }
            else
            {
                eCheck.GetEntity().pev.solid = SOLID_NOT;
                g_PlayerFuncs.ShowMessageAll("DEMO Off");
            }
            self.pev.frame = 1 - self.pev.frame;
            return;
        }

        if(bIsPlay)
        {
            if(!pTJAPlayer.bIsPlay)
                pTJAPlayer.Play();
            else
                pTJAPlayer.Stop();
            self.pev.frame = 1 - self.pev.frame;
            return;
        }

        if(!bIsLevel)
        {
            if(iNowMusic >= MusicBank::GetMusicLength() - 1)
                iNowMusic = 0;

            iNowMusic++;
            iNowLevel = 0;
        }
        else
        {
            if(iNowLevel >= MusicBank::GetLevelLength(iNowMusic) - 1)
                iNowLevel = 0;
            iNowLevel++;
        }
		pTJAPlayer.Setup(MusicBank::GetTJA(iNowMusic, iNowLevel));
        pTJAPlayer.ShowInfo();
        self.pev.frame = 1 - self.pev.frame;
	}

    bool IsBSPModel()
	{
		return true;
	}

}