#include "tja/CTJALoader"
#include "tja/TJAPlayer"
#include "Logger"
#include "musicbank"
#include "entity/func_hitnode"
#include "entity/func_nodecheck"
#include "entity/func_selectmusic"

void MapInit()
{
    g_Scheduler.ClearTimerList();
	g_Module.ScriptInfo.SetAuthor("123");
	g_Module.ScriptInfo.SetContactInfo("123");


    File@ file = g_FileSystem.OpenFile("scripts/plugins/musilife/music.txt", OpenFile::READ);
    if (file !is null && file.IsOpen()) 
	{
		while(!file.EOFReached()) 
		{
            string sLine;
            file.ReadLine(sLine);
            sLine.Trim();
            if(sLine.IsEmpty())
                continue;
            
            if(!sLine.EndsWith(".tja"))
                sLine = sLine + ".tja";

            MusicBank::Add(CTJALoader::Builder("scripts/plugins/musilife/store/" + sLine));
		}
		file.Close();
	}
    
    MusicBank::Precache();
    g_CustomEntityFuncs.RegisterCustomEntity( "CHitNode", "func_hitnode" );
    g_CustomEntityFuncs.RegisterCustomEntity( "CNodeCheck", "func_nodecheck" );
    g_CustomEntityFuncs.RegisterCustomEntity( "CSelectMusic", "func_selectmusic" );
    g_Game.PrecacheModel("sprites/flare3.spr");
    g_Game.PrecacheModel("sprites/gworm_beam.spr");
    g_Game.PrecacheOther("func_hitnode");

    g_Hooks.RegisterHook(Hooks::Player::PlayerPreThink, @PlayerPreThink);
    pTJAPlayer.flScrollDistance = 672.0f;
    pTJAPlayer.AddCommandHook(@GoGoEnd);
    pTJAPlayer.AddNoteHook(@GoGoColor);
}

bool GoGoEnd(string szCommand, TJAPlayer::TJAPlayer@ pTJAPlayer)
{
    if(szCommand != "#GOGOEND")
        return false;

    CBaseEntity@ pWall = g_EntityFuncs.FindEntityByTargetname(pWall, "gogoblue");
    if(@pWall !is null)
        pWall.Use(pWall, pWall, USE_OFF, 0.0);
    @pWall = g_EntityFuncs.FindEntityByTargetname(pWall, "gogored");
    if(pWall !is null)
        pWall.Use(pWall, pWall, USE_OFF, 0.0);
    @pWall = g_EntityFuncs.FindEntityByTargetname(pWall, "gogoyellow");
    if(@pWall !is null)
        pWall.Use(pWall, pWall, USE_OFF, 0.0);
    return true;
}

bool GoGoColor(uint uiNote, CBaseEntity@ pEntity, TJAPlayer::TJAPlayer@ pTJAPlayer)
{
    if(!pTJAPlayer.bIsGOGO || pEntity is null)
        return false;

    CBaseEntity@ pWall = null;
    array<USE_TYPE> aryUSE = {USE_OFF, USE_OFF, USE_OFF};
    Logger::Log(pEntity.pev.skin);
    aryUSE[pEntity.pev.skin] = USE_ON;
    @pWall = g_EntityFuncs.FindEntityByTargetname(pWall, "gogoblue");
    if(@pWall !is null)
        pWall.Use(pWall, pWall, aryUSE[0], 0.0);
    @pWall = g_EntityFuncs.FindEntityByTargetname(pWall, "gogored");
    if(pWall !is null)
        pWall.Use(pWall, pWall, aryUSE[1], 0.0);
    @pWall = g_EntityFuncs.FindEntityByTargetname(pWall, "gogoyellow");
    if(@pWall !is null)
        pWall.Use(pWall, pWall, aryUSE[2], 0.0);
    return true;
}

void MapStart()
{
    CBaseEntity@ pSpawner = g_EntityFuncs.FindEntityByClassname(pSpawner, "func_nodecheck");
    if(pSpawner !is null)
        eCheck = pSpawner;
}

HookReturnCode PlayerPreThink( CBasePlayer@ pPlayer, uint& out uiFlags )
{
    if(eCheck.IsValid())
    {
        CNodeCheck@ pCheck = cast<CNodeCheck@>(CastToScriptClass(@eCheck.GetEntity()));
        if(pPlayer.pev.button & IN_ATTACK2 == 0 && pPlayer.pev.button & IN_ATTACK != 0 && pPlayer.pev.oldbuttons & IN_ATTACK == 0)
            pCheck.DoDrum(@pPlayer, USE_ON);
        if(pPlayer.pev.button & IN_ATTACK == 0 && pPlayer.pev.button & IN_ATTACK2 != 0 && pPlayer.pev.oldbuttons & IN_ATTACK2 == 0)
            pCheck.DoDrum(@pPlayer, USE_OFF);
    }
    return HOOK_CONTINUE;
}

uint iNowMusic = 0;
uint iNowLevel = 0;
TJAPlayer::TJAPlayer pTJAPlayer;
EHandle eCheck;