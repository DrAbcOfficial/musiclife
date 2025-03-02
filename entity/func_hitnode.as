string szSprPath = "sprites/taikocoop/taiko.spr";
string szHitSoundKa = "taikocoop/ka.mp3";
string szHitSoundDon = "taikocoop/don.mp3";
float flScale = 0.5f;
float flSize = 32;
int iSmallScore = 200;
int iBigScore = 500;

class CHitNode : ScriptBaseAnimating
{
    void Spawn()
	{	
        BaseClass.Spawn();
        Precache();

		pev.movetype = MOVETYPE_FLY;
		pev.solid = SOLID_TRIGGER;

        self.pev.framerate = 1.0f;
        self.pev.rendermode = kRenderTransAlpha;
        self.pev.renderamt = 255;
		
		self.pev.model = szSprPath;
        self.pev.scale = flScale;

        self.pev.frame = self.pev.skin;

        g_EngineFuncs.MakeVectors(self.pev.angles);

		g_EntityFuncs.SetModel( self, self.pev.model );
        g_EntityFuncs.SetOrigin( self, self.pev.origin );
        SetTouch(TouchFunction(Touch));
	}

    void Precache()
    {
        BaseClass.Precache();
		
		g_Game.PrecacheModel( szSprPath );
        g_Game.PrecacheGeneric( szSprPath );

        g_SoundSystem.PrecacheSound( szHitSoundDon );
        g_Game.PrecacheGeneric( "sound/" + szHitSoundDon );
        g_SoundSystem.PrecacheSound( szHitSoundKa );
        g_Game.PrecacheGeneric( "sound/" + szHitSoundKa );
    }

    void Touch(CBaseEntity@ pOther)
    {
        if(pOther.pev.classname == "worldspawn")
            g_EntityFuncs.Remove(self);
    }
}