/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <codmod>
#include <cstrike>
#include <fakemeta_util>

new const perk_name[] = "Granatnik";
new const perk_desc[] = "Co runde dostajesz 3 granaty (HE)";

#define MAX 20
new bool:ma_perk[ MAX + 1 ];

public plugin_init() 
{
	register_plugin(perk_name, "1.0", "RPK. Shark");
        
	cod_register_perk(perk_name, perk_desc);
	register_event("ResetHUD", "ResetHUD", "abe");
}

public cod_perk_enabled(id)
{
	fm_give_item(id,"weapon_hegrenade");
	ma_perk[id] = true;
	cs_set_user_bpammo(id, CSW_HEGRENADE, cs_get_user_bpammo(id, CSW_HEGRENADE)+2)
}

public cod_perk_disabled(id)
{
	cs_set_user_bpammo(id, CSW_HEGRENADE, cs_get_user_bpammo(id, CSW_HEGRENADE)-3)
	ma_perk[id] = false;
}

public ResetHUD(id)
	set_task(0.2, "ResetHUDx", id);
        
public ResetHUDx(id)
{
	if(!is_user_connected(id)) return;
        
	if(!ma_perk[id]) return;
        
	cs_set_user_bpammo(id, CSW_HEGRENADE, cs_get_user_bpammo(id, CSW_HEGRENADE)+2)
}
