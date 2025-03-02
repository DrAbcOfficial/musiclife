class CNodeCheck : ScriptBaseEntity
{
	void Spawn()
	{
		self.pev.solid = SOLID_BSP;
		self.pev.movetype = MOVETYPE_PUSH;
        self.pev.effects |= EF_NODRAW;
		
		g_EntityFuncs.SetModel( self, self.pev.model );
		g_EntityFuncs.SetSize( self.pev, self.pev.mins, self.pev.maxs );
		g_EntityFuncs.SetOrigin( self, self.pev.origin );

        SetTouch(TouchFunction(this.Touch));
	}

    void DoDrum(CBasePlayer@ pPlayer, USE_TYPE useType)
    {
		
        CBaseEntity@ pEntity = g_EntityFuncs.FindEntityInSphere(@pEntity, self.Center(), 64.0f, "func_hitnode", "classname");
        if(pEntity !is null)
        {
            if(pEntity.pev.skin <= 1 && useType != pEntity.pev.skin)
                return;
            pPlayer.pev.frags += (pEntity.pev.scale > flScale ? iBigScore : iSmallScore) / ((self.Center() - pEntity.Center()).Length() + 1);
            g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_MUSIC, pEntity.pev.skin == 0 ? szHitSoundKa : szHitSoundDon, 1.0, ATTN_NORM, 0, PITCH_NORM ); 
            g_EntityFuncs.Remove(pEntity);
        }
    }

    void Touch(CBaseEntity@ pOther)
    {
        if(pOther.pev.classname == "func_hitnode")
        {
            g_SoundSystem.EmitSoundDyn( self.edict(), CHAN_MUSIC, pOther.pev.skin == 0 ? szHitSoundKa : szHitSoundDon, 1.0, ATTN_NORM, 0, PITCH_NORM ); 
            g_EntityFuncs.Remove(pOther);
        }
    }

    bool IsBSPModel()
	{
		return true;
	}

}