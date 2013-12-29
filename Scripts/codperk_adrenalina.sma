/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <codmod>
#include <fun>

new const nazwa[] = "Adrenalina";
new const opis[] = "Za kazdego fraga dostajesz 50 hp";

#define MAX 20

new bool:ma_perk[ MAX + 1 ];

public plugin_init() 
{
	register_plugin(nazwa, "1.0", "QTM_Peyote");
	
	cod_register_perk(nazwa, opis);
	
	register_event("DeathMsg", "Death", "ade");
}

public cod_perk_enabled(id)
	ma_perk[id] = true;
	
public cod_perk_disabled(id)
	ma_perk[id] = false;

public Death()
{
	new attacker = read_data(1);
	
	if(!is_user_connected(attacker))
		return PLUGIN_CONTINUE;
		
	if(!ma_perk[attacker])
		return PLUGIN_CONTINUE;
		
	new cur_health = get_user_health(attacker);
	new max_health = 100+cod_get_user_health(attacker);
	new new_health = cur_health+50<max_health? cur_health+50: max_health;
	set_user_health(attacker, new_health);
	
	return PLUGIN_CONTINUE;
}
