/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <fakemeta>
#include <codmod>

#define DMG_BULLET (1<<1)
#define MAX 20
new const perk_name[] = "Helm Generala";
new const perk_desc[] = "Nie dostajesz obrazen od strzalu w glowe";

new bool:ma_perk[MAX + 1];

public plugin_init() 
{
	register_plugin(perk_name, "1.0", "QTM_Peyote");
	
	cod_register_perk(perk_name, perk_desc);
	
	register_forward(FM_TraceLine, "TraceLine");
}
	

public cod_perk_enabled(id, wartosc)
{
	ma_perk[id] = true;
	
	return COD_CONTINUE;
}

public cod_perk_disabled(id)
	ma_perk[id] = false;

public TraceLine(Float:start[3], Float:end[3], conditions, id, trace)
{	
	if(get_tr2(trace, TR_iHitgroup) != HIT_HEAD)
		return FMRES_IGNORED;
		
	new iHit = get_tr2(trace, TR_pHit);
	
	if(!is_user_connected(iHit))
		return FMRES_IGNORED;

	if(!ma_perk[iHit])
		return FMRES_IGNORED;
		
	set_tr2(trace, TR_iHitgroup, 8);
	
	return FMRES_IGNORED;
}
